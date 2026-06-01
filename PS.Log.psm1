# ==============================================================================
# Filename: PS.Log.psm1
# Updated:  2022-02-13
# Author:   Justin Johns
# ==============================================================================

# DOT SOURCE ALL PUBLIC AND PRIVATE FUNCTIONS
$dirs = @(
    (Join-Path -Path $PSScriptRoot -ChildPath 'Public')
    (Join-Path -Path $PSScriptRoot -ChildPath 'Private')
)
foreach ($file in (Get-ChildItem -Path $dirs -Filter '*.ps1' -ErrorAction Ignore)) { . $file.FullName }

# MODULE-SCOPE READ-ONLY VARIABLES
# 'yyyy-MM-ddTHH:mm:ss.ffff'
New-Variable -Name 'FORMAT' -Option ReadOnly -Value 'yyyy-MM-dd HH:mm:ss.ffff'

# EXPORT MEMBERS
# Functions are intentionally omitted here. When a module manifest (.psd1) is
# present, FunctionsToExport in the manifest is authoritative for which
# functions are visible after Import-Module. Variables and aliases are still
# declared here because they are not controlled by the manifest the same way.
Export-ModuleMember -Variable * -Alias *

# FORMAT NOTES
# {"timestamp":"2021-09-24 15:34:34.0001","level":"INFO","id":"#","message":"Begin Logging"}
# {"timestamp":"2021-09-24 15:34:34.0001","level":"ERROR","id":"#","message":"Begin Logging"}
