# Video playlist updater

`Update-VideoPlaylist.ps1` rebuilds an M3U playlist from all `.mkv` files in
the configured directories. It searches subdirectories by default, ignores
JSON sidecars and other files, removes stale playlist entries, de-duplicates
overlapping source directories, and skips paths listed in the exclusion file.

## Setup

1. Edit `playlist-directories.txt` and put one source directory on each line.
2. Optionally add exact `.mkv` paths to `playlist-exclude.txt`.
3. Run the script from PowerShell:

   ```powershell
   powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\Update-VideoPlaylist.ps1
   ```

The default output is `videos.m3u` beside the script. Paths in the generated
playlist are absolute, which also works when source directories are on
different drives. Blank lines and lines beginning with `#` are ignored in both
configuration files. `%NAME%` environment variables are expanded. Quoted and
UNC paths are supported. Save the configuration files as UTF-8 when paths
contain non-ASCII characters.

## Options

```powershell
# Put the newest-modified downloads first.
.\Update-VideoPlaylist.ps1 -SortBy LastWriteTime -SortOrder Descending

# Search only the listed directories, not their subdirectories.
.\Update-VideoPlaylist.ps1 -NoRecurse

# Use different configuration and output paths.
.\Update-VideoPlaylist.ps1 `
    -DirectoriesFile C:\Playlist\sources.txt `
    -ExcludeFile C:\Playlist\excluded.txt `
    -OutputFile C:\Playlist\youtube.m3u

# Show whether an update would occur without writing it.
.\Update-VideoPlaylist.ps1 -WhatIf
```

`-SortBy` accepts `Directory` (the default), `Path`, `Name`, or `LastWriteTime`.
Directory sorting keeps videos from each channel folder together, ordered by the
folder name and then the video name.
`-SortOrder` accepts `Ascending` (the default) or `Descending`. The output file
is only rewritten when its content changes.

## Automatic updates

Run the script after `yt-dlp`, or create a Windows Task Scheduler task that
runs it periodically. For a scheduled task, use `powershell.exe` as the program
and arguments similar to:

```text
-NoProfile -ExecutionPolicy Bypass -File "C:\Playlist\Update-VideoPlaylist.ps1"
```
