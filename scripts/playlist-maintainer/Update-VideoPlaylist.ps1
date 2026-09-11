[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [Parameter()]
    [string] $DirectoriesFile,

    [Parameter()]
    [string] $ExcludeFile,

    [Parameter()]
    [string] $OutputFile,

    [Parameter()]
    [ValidateSet('Directory', 'Path', 'Name', 'LastWriteTime')]
    [string] $SortBy = 'Directory',

    [Parameter()]
    [ValidateSet('Ascending', 'Descending')]
    [string] $SortOrder = 'Ascending',

    [Parameter()]
    [switch] $NoRecurse
)

Set-StrictMode -Version 3.0
$ErrorActionPreference = 'Stop'

$scriptDirectory = $PSScriptRoot
if ([string]::IsNullOrWhiteSpace($scriptDirectory)) {
    $scriptPath = $MyInvocation.MyCommand.Path
    if ([string]::IsNullOrWhiteSpace($scriptPath)) {
        $scriptDirectory = (Get-Location).ProviderPath
    }
    else {
        $scriptDirectory = Split-Path -Parent $scriptPath
    }
}

if ([string]::IsNullOrWhiteSpace($DirectoriesFile)) {
    $DirectoriesFile = Join-Path $scriptDirectory 'playlist-directories.txt'
}
if ([string]::IsNullOrWhiteSpace($ExcludeFile)) {
    $ExcludeFile = Join-Path $scriptDirectory 'playlist-exclude.txt'
}
if ([string]::IsNullOrWhiteSpace($OutputFile)) {
    $OutputFile = Join-Path $scriptDirectory 'videos.m3u'
}

function Get-NativePath {
    param(
        [Parameter(Mandatory = $true)]
        [string] $Path,

        [Parameter(Mandatory = $true)]
        [string] $BaseDirectory
    )

    $cleanPath = $Path.Trim()
    if ($cleanPath.Length -ge 2) {
        $firstCharacter = $cleanPath[0]
        $lastCharacter = $cleanPath[$cleanPath.Length - 1]
        if (($firstCharacter -eq '"' -and $lastCharacter -eq '"') -or
            ($firstCharacter -eq "'" -and $lastCharacter -eq "'")) {
            $cleanPath = $cleanPath.Substring(1, $cleanPath.Length - 2)
        }
    }

    $cleanPath = [Environment]::ExpandEnvironmentVariables($cleanPath)
    if (-not [IO.Path]::IsPathRooted($cleanPath)) {
        $cleanPath = Join-Path $BaseDirectory $cleanPath
    }

    return [IO.Path]::GetFullPath($cleanPath)
}

function Get-ConfiguredPath {
    param(
        [Parameter(Mandatory = $true)]
        [string] $ListFile,

        [Parameter()]
        [switch] $Optional
    )

    if (-not (Test-Path -LiteralPath $ListFile -PathType Leaf)) {
        if ($Optional) {
            return @()
        }

        throw "Configuration file not found: $ListFile"
    }

    $baseDirectory = Split-Path -Parent $ListFile
    $paths = foreach ($line in Get-Content -LiteralPath $ListFile -Encoding UTF8) {
        $trimmedLine = $line.Trim()
        if ($trimmedLine.Length -eq 0 -or $trimmedLine.StartsWith('#')) {
            continue
        }

        Get-NativePath -Path $trimmedLine -BaseDirectory $baseDirectory
    }

    return @($paths)
}

$DirectoriesFile = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($DirectoriesFile)
$ExcludeFile = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($ExcludeFile)
$OutputFile = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($OutputFile)

$sourceDirectories = @(Get-ConfiguredPath -ListFile $DirectoriesFile)
if ($sourceDirectories.Count -eq 0) {
    throw "No source directories are listed in: $DirectoriesFile"
}

$excludedPaths = [Collections.Generic.HashSet[string]]::new(
    [StringComparer]::OrdinalIgnoreCase
)
foreach ($path in (Get-ConfiguredPath -ListFile $ExcludeFile -Optional)) {
    [void] $excludedPaths.Add($path)
}

$seenPaths = [Collections.Generic.HashSet[string]]::new(
    [StringComparer]::OrdinalIgnoreCase
)
$videos = [Collections.Generic.List[IO.FileInfo]]::new()
$missingDirectoryCount = 0

foreach ($directory in $sourceDirectories) {
    if (-not (Test-Path -LiteralPath $directory -PathType Container)) {
        Write-Warning "Source directory does not exist; skipping: $directory"
        $missingDirectoryCount++
        continue
    }

    $getChildItemArguments = @{
        LiteralPath = $directory
        File = $true
        Filter = '*.mkv'
    }
    if (-not $NoRecurse) {
        $getChildItemArguments.Recurse = $true
    }

    foreach ($video in (Get-ChildItem @getChildItemArguments)) {
        $fullPath = [IO.Path]::GetFullPath($video.FullName)
        if ($excludedPaths.Contains($fullPath) -or -not $seenPaths.Add($fullPath)) {
            continue
        }

        $videos.Add($video)
    }
}

switch ($SortBy) {
    'Directory' {
        $videos = @($videos | Sort-Object -Property `
            @{ Expression = { $_.Directory.Name } }, `
            @{ Expression = { $_.Directory.FullName } }, `
            Name, `
            FullName)
    }
    'Name' {
        $videos = @($videos | Sort-Object -Property Name, FullName)
    }
    'LastWriteTime' {
        $videos = @($videos | Sort-Object -Property LastWriteTimeUtc, FullName)
    }
    default {
        $videos = @($videos | Sort-Object -Property FullName)
    }
}

if ($SortOrder -eq 'Descending') {
    [array]::Reverse($videos)
}

$playlistLines = [Collections.Generic.List[string]]::new()
$playlistLines.Add('#EXTM3U')
foreach ($video in $videos) {
    $playlistLines.Add($video.FullName)
}

$playlistText = [string]::Join(
    [Environment]::NewLine,
    [string[]] $playlistLines
) + [Environment]::NewLine

$existingText = $null
if (Test-Path -LiteralPath $OutputFile -PathType Leaf) {
    $existingText = [IO.File]::ReadAllText($OutputFile)
}

$status = 'Unchanged'
if ($existingText -cne $playlistText) {
    if ($PSCmdlet.ShouldProcess($OutputFile, "Write playlist containing $($videos.Count) video(s)")) {
        $outputDirectory = Split-Path -Parent $OutputFile
        if (-not (Test-Path -LiteralPath $outputDirectory -PathType Container)) {
            [void] (New-Item -ItemType Directory -Path $outputDirectory -Force)
        }

        $temporaryFile = Join-Path $outputDirectory (
            '.{0}.{1}.tmp' -f ([IO.Path]::GetFileName($OutputFile)), ([Guid]::NewGuid().ToString('N'))
        )

        try {
            $utf8WithoutBom = [Text.UTF8Encoding]::new($false)
            [IO.File]::WriteAllText($temporaryFile, $playlistText, $utf8WithoutBom)
            Move-Item -LiteralPath $temporaryFile -Destination $OutputFile -Force
        }
        finally {
            if (Test-Path -LiteralPath $temporaryFile -PathType Leaf) {
                Remove-Item -LiteralPath $temporaryFile -Force
            }
        }

        $status = 'Updated'
    }
    else {
        $status = 'WouldUpdate'
    }
}

[pscustomobject] @{
    Status = $status
    Playlist = $OutputFile
    Videos = $videos.Count
    ExcludedEntries = $excludedPaths.Count
    MissingDirectories = $missingDirectoryCount
}
