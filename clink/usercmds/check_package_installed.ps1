# require [pwsh](https://github.com/PowerShell/PowerShell/releases) for this file and yazi

$ErrorActionPreference = 'Stop' # Stop script execution when an error occurs
$VerbosePreference = 'Continue' # Display Write-Verbose messages

# scoop install path
$scoopHome = Join-Path $env:USERPROFILE "scoop"
$scoopAppsDir = Join-Path $scoopHome "apps"

# scoop packages (remove ',' of last one)
$packages = @(
    '7zip',             # neovim, mason
    'bat',              # cmd
    'clipboard',        # yazi, clipboard
    'curl',             # neovim, mason
    'clink',            # cmd prompt
    'deno',             # neovim, peek.nvim
    'eza',              # cmd
    'fd',               # yazi
    'ffmpeg',           # yazi
    'fzf',              # yazi, fzff, fzfg
    'git',              # cmd
    'gawk',             # neovim
    'gh',               # neovim
    'grep',             # neovim
    'gzip',             # neovim, mason
    'iconv',            # fzff, fzfg
    'imagemagick',      # yazi
    'irfanview',        # yazi, smart paste
    'jid',              # yazi
    'jq',               # yazi
    'lua',              # neovim, lua
    'luarocks',         # neovim, lua
    'mingw-winlibs',    # neovim, treesitter, gcc, cmake
    'mpv',              # qutebrowser, video player
    'neovim',           # neovim
    'neovim-qt',        # neovim
    'openjdk11',        # I don't know
    'poppler',          # yazi, pdf
    'python',           # cmd
	'vieb'              # web browser
    'ripgrep',          # cmd, neovim
	# 'rustup', 			# cmd, some environment cannot install this
    'scoop-search',     # scoop
    'sed',              # cmd
    'sioyek',           # pdf viewer
    'tar',              # cmd
    'tree-sitter',      # neovim
    'unar',             # yazi,lsar
    'unzip',            # cmd
    'uutils-coreutils', # cmd, neovim
    'uv',               # neovim, python-uv
    'wget',             # neovim, mason
    'win-vind',         # window manager
	'windows-terminal', # terminal
	'wox',              # window toolbar
	'yazi',             # file explorer
	'yt-dlp',           # youtube downloader
	'zip',              # neovim
	'zoxide'            # cmd, yazi
)

# Indirectly check for the existence of the apps folder
if (-not (Test-Path $scoopHome -PathType Container)) {
	Write-Error "scoop is not installed"
	exit 1
}

# check required buckets -- it would do manually.
$requiredBuckets = @('main', 'extras', 'versions', 'java')


# Process each element of the $packages array in parallel.
# -Throttle Limit: Maximum number of script blocks that will run simultaneously (usually equal to the number of CPU cores)
$results = $packages | ForEach-Object -Parallel {
    $pkg = $_ # pkg name from pipeline of $packages
    $scoopAppsDir = $using:scoopAppsDir # to access from out of region variable

    # objects that which is installed
    [PSCustomObject]@{
        Package = $pkg
        IsInstalled = Test-Path (Join-Path $scoopAppsDir $pkg) -PathType Container
    }
} -ThrottleLimit ([Environment]::ProcessorCount) # 시스템의 CPU 코어 수만큼 병렬 처리

$missingPackages = @()
foreach ($result in $results) {
    if (-not $result.IsInstalled) {
        $missingPackages += $result.Package
    }
}

if (-not $missingPackages.Count -eq 0) {
    try {
		# install missing packages
        scoop install ($missingPackages -join ' ')

		# check error
        if ($LASTEXITCODE -ne 0) {
            Write-Error "Some packages may have failed to install. Check the error messages."
            exit 1
        } else {
            Write-Host "package installed successfully"
        }
    } catch {
        Write-Error "Scoop install error : $($_.Exception.Message)"
        exit 1
    }
}

exit 0
