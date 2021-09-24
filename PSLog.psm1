# ==============================================================================
# Updated:      2021-09-24
# Created by:   Justin Johns
# Filename:     PSLog.psm1
# ==============================================================================

# IMPORT ALL FUNCTIONS
foreach ( $directory in @('Public', 'Private') ) {
    foreach ( $fn in (Get-ChildItem -Path "$PSScriptRoot\$directory\*.ps1") ) { . $fn.FullName }
}

# VARIABLES
$format = 'yyyy-MM-dd HH:mm:ss.ffff' # 'yyyy-MM-ddTHH:mm:ss.ffff'

# EXPORT MEMBERS
# THESE ARE SPECIFIED IN THE MODULE MANIFEST AND THEREFORE DON'T NEED TO BE LISTED HERE
#Export-ModuleMember -Function *
#Export-ModuleMember -Variable *

# FORMAT NOTES
# {"timestamp":"2021-09-24 15:34:34.0001","level":"INFO","id":"#","message":"Begin Logging"}
# {"timestamp":"2021-09-24 15:34:34.0001","level":"ERROR","id":"#","message":"Begin Logging"}