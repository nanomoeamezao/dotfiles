[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$PlaylistPath,
    [Parameter(Mandatory = $true)]
    [string]$UserName,
    [string]$Server = 'https://localhost:8920',
    [string]$Name,
    [securestring]$ApiKey,
    [ValidateSet('UTF8', 'Default', 'Unicode', 'BigEndianUnicode')]
    [string]$Encoding = 'UTF8',
    [switch]$Preview,
    [switch]$SkipCertificateCheck,
    [switch]$DeleteExisting
)

$ErrorActionPreference = 'Stop'
$Server = $Server.TrimEnd('/')

function Invoke-JellyfinRequest {
    param(
        [string]$Uri,
        [string]$Method = 'Get',
        [string]$Json
    )

    $parameters = $request.Clone()
    $parameters.Uri = $Uri
    $parameters.Method = $Method
    if ($PSBoundParameters.ContainsKey('Json')) {
        $parameters.ContentType = 'application/json; charset=utf-8'
        $parameters.Body = [Text.Encoding]::UTF8.GetBytes($Json)
    }

    $previousCallback = [Net.ServicePointManager]::ServerCertificateValidationCallback
    try {
        if ($SkipCertificateCheck) {
            if ((Get-Command Invoke-WebRequest).Parameters.ContainsKey('SkipCertificateCheck')) {
                $parameters.SkipCertificateCheck = $true
            } else {
                if (-not ('JellyfinM3uImport.TlsPolicy' -as [type])) {
                    Add-Type -TypeDefinition @'
namespace JellyfinM3uImport {
    public static class TlsPolicy {
        public static readonly System.Net.Security.RemoteCertificateValidationCallback Accept =
            (sender, certificate, chain, errors) => true;
    }
}
'@
                }
                [Net.ServicePointManager]::ServerCertificateValidationCallback = [JellyfinM3uImport.TlsPolicy]::Accept
            }
        }

        $response = Invoke-WebRequest @parameters -UseBasicParsing
        if ([int]$response.StatusCode -ge 300 -and [int]$response.StatusCode -lt 400) {
            throw "Jellyfin redirected the request. Set -Server to the final HTTPS API address, such as https://localhost:8920."
        }
        if ($Method -eq 'Delete' -and [int]$response.StatusCode -eq 204) {
            return
        }
        if ($response.Headers['Content-Type'] -notmatch 'application/json') {
            throw 'The server returned a non-JSON response. Use the Jellyfin API base URL, without /web or a browser fragment.'
        }
        return ($response.Content | ConvertFrom-Json)
    } finally {
        [Net.ServicePointManager]::ServerCertificateValidationCallback = $previousCallback
    }
}

$playlistFile = Get-Item -LiteralPath $PlaylistPath
if ($playlistFile.PSIsContainer -or $playlistFile.Extension -notin @('.m3u', '.m3u8')) {
    throw 'PlaylistPath must point to an M3U or M3U8 file.'
}
if ([string]::IsNullOrWhiteSpace($Name)) {
    $Name = $playlistFile.BaseName + ' (imported)'
}

$paths = @(
    foreach ($line in Get-Content -LiteralPath $playlistFile.FullName -Encoding $Encoding) {
        $entry = $line.Trim()
        if ($entry.Length -eq 0 -or $entry.StartsWith('#')) {
            continue
        }
        if (-not [IO.Path]::IsPathRooted($entry)) {
            $entry = Join-Path -Path $playlistFile.DirectoryName -ChildPath $entry
        }
        [IO.Path]::GetFullPath($entry)
    }
)
if ($paths.Count -eq 0) {
    throw 'The playlist contains no file paths.'
}

if (-not $ApiKey) {
    $ApiKey = Read-Host 'Jellyfin API key' -AsSecureString
}
$credential = [PSCredential]::new('api-key', $ApiKey)
$request = @{
    Headers = @{
        Authorization = 'MediaBrowser Client="M3U Import", Device="PowerShell", DeviceId="m3u-import", Version="1.1", Token="{0}"' -f $credential.GetNetworkCredential().Password.Trim()
        Accept = 'application/json'
    }
    TimeoutSec = 120
    MaximumRedirection = 0
    ErrorAction = 'Stop'
}
$users = @(Invoke-JellyfinRequest -Uri "$Server/Users")
$matchingUsers = @($users | Where-Object { $_.Name -eq $UserName })
if ($matchingUsers.Count -ne 1) {
    throw "Expected one Jellyfin user named '$UserName'; found $($matchingUsers.Count)."
}
$userId = $matchingUsers[0].Id
$byPath = [Collections.Generic.Dictionary[string, string]]::new([StringComparer]::OrdinalIgnoreCase)
$offset = 0
do {
    $uri = "$Server/Items?UserId=$userId&Recursive=true&MediaTypes=Video&IsFolder=false&Fields=Path&EnableImages=false&EnableUserData=false&CollapseBoxSetItems=false&StartIndex=$offset&Limit=500"
    $page = Invoke-JellyfinRequest -Uri $uri
    $items = @($page.Items)
    foreach ($item in $items) {
        if ([string]::IsNullOrWhiteSpace($item.Path) -or -not [IO.Path]::IsPathRooted($item.Path)) {
            continue
        }
        $path = [IO.Path]::GetFullPath($item.Path)
        if ($byPath.ContainsKey($path) -and $byPath[$path] -ne $item.Id) {
            $byPath[$path] = ''
        } else {
            $byPath[$path] = $item.Id
        }
    }
    $offset += $items.Count
} while ($items.Count -gt 0 -and $offset -lt $page.TotalRecordCount)

$ids = [Collections.Generic.List[string]]::new()
$unmatched = [Collections.Generic.List[string]]::new()
foreach ($path in $paths) {
    if ($byPath.ContainsKey($path) -and $byPath[$path]) {
        $ids.Add($byPath[$path])
    } else {
        $unmatched.Add($path)
    }
}
if ($unmatched.Count -gt 0) {
    foreach ($path in $unmatched) {
        Write-Warning "No unique indexed video match: $path"
    }
    throw "$($unmatched.Count) entries could not be matched. No playlist was created."
}

Write-Host "Matched $($ids.Count) entries for '$Name', owned by '$UserName'."
$existingPlaylists = [Collections.Generic.List[object]]::new()
if ($DeleteExisting) {
    $offset = 0
    do {
        $uri = "$Server/Items?UserId=$userId&Recursive=true&IncludeItemTypes=Playlist&EnableImages=false&EnableUserData=false&StartIndex=$offset&Limit=500"
        $page = Invoke-JellyfinRequest -Uri $uri
        $items = @($page.Items)
        foreach ($item in $items) {
            if ($item.Name -ceq $Name) {
                $existingPlaylists.Add($item)
            }
        }
        $offset += $items.Count
    } while ($items.Count -gt 0 -and $offset -lt $page.TotalRecordCount)
    Write-Host "Found $($existingPlaylists.Count) existing playlists named '$Name'."
}

if ($Preview) {
    foreach ($playlist in $existingPlaylists) {
        Write-Host "Would delete playlist '$($playlist.Name)' (ID $($playlist.Id)) before import."
    }
    for ($index = 0; $index -lt $paths.Count; $index++) {
        Write-Output ('{0}: {1}' -f ($index + 1), $paths[$index])
    }
    Write-Host 'Preview complete. Run without -Preview to create the playlist.'
    return
}

$body = @{
    Name = $Name
    UserId = $userId
    MediaType = 'Video'
    IsPublic = $false
    Ids = $ids.ToArray()
} | ConvertTo-Json -Depth 4
foreach ($playlist in $existingPlaylists) {
    Invoke-JellyfinRequest -Uri "$Server/Items/$($playlist.Id)" -Method Delete
    Write-Host "Deleted playlist '$($playlist.Name)' (ID $($playlist.Id))."
}
$created = Invoke-JellyfinRequest -Uri "$Server/Playlists" -Method Post -Json $body
if (-not $created.Id) {
    throw 'The server returned no playlist ID. Check Jellyfin before running again.'
}
Write-Host "Created playlist ID $($created.Id). Verifying its entries..."

$savedIds = [Collections.Generic.List[string]]::new()
$offset = 0
do {
    $uri = "$Server/Playlists/$($created.Id)/Items?UserId=$userId&StartIndex=$offset&Limit=500&EnableImages=false&EnableUserData=false"
    $page = Invoke-JellyfinRequest -Uri $uri
    $items = @($page.Items)
    foreach ($item in $items) {
        $savedIds.Add($item.Id)
    }
    $offset += $items.Count
} while ($items.Count -gt 0 -and $offset -lt $page.TotalRecordCount)

if ($savedIds.Count -ne $ids.Count) {
    throw "Playlist $($created.Id) was created, but contains $($savedIds.Count) entries instead of $($ids.Count). Check it before running again."
}
for ($index = 0; $index -lt $ids.Count; $index++) {
    if ([guid]$savedIds[$index] -ne [guid]$ids[$index]) {
        throw "Playlist $($created.Id) was created, but its order differs at entry $($index + 1)."
    }
}
Write-Host "Verified '$Name': $($ids.Count) video entries in the original order."
