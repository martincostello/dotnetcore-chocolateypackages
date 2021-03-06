Import-Module au

$releases = "https://raw.githubusercontent.com/dotnet/core/master/release-notes/releases.json"

function global:au_SearchReplace {
    @{
        "tools\data.ps1" = @{
            "(^\s*Url\s*=\s*)('.*')"      = "`$1'$($Latest.URL32)'"           #1
            "(^\s*Checksum\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"      #2
            "(^\s*Url64\s*=\s*)('.*')"      = "`$1'$($Latest.URL64)'"           #1
            "(^\s*Checksum64\s*=\s*)('.*')" = "`$1'$($Latest.Checksum64)'"      #2

        }
    }
}

function global:au_GetLatest {
    $json = (Invoke-WebRequest -Uri $releases -UseBasicParsing | ConvertFrom-Json)
    $info = $json | where { $_.'version-runtime' -notmatch '-' } | sort -Property version-runtime -Descending | select -First 1
   
     $version = $info.'version-runtime'
     $url32   = $info.'dlc-runtime' + $info.'runtime-win-x86'
     $url64   = $info.'dlc-runtime' + $info.'runtime-win-x64'

     return @{ Version = $version; URL32 = $url32; URL64 = $url64; ChecksumType32 = 'sha512'; ChecksumType64 = 'sha512'; }
}

update