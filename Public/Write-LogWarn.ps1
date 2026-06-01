function Write-LogWarn {
    <#
    .SYNOPSIS
        Write WARN to log
    .DESCRIPTION
        Write WARN to log
    .PARAMETER Path
        Path to log file
    .PARAMETER Message
        Log message
    .PARAMETER Id
        Unique ID for log entry or set of entries (e.g., process id, etc.)
    .INPUTS
        System.String.
    .OUTPUTS
        None.
    .EXAMPLE
        PS C:\> Write-LogWarn -Path C:\temp\log.log -Message 'Minor issue detected'
        Adds the warning-level log entry 'Minor issue detected'
    .NOTES
        General notes
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory, HelpMessage = 'Log file path')]
        [ValidateScript({ (Test-Path -Path $_ -PathType 'Leaf') -and $_ -like '*.log' })]
        [System.String] $Path,

        [Parameter(Mandatory, ValueFromPipeline, HelpMessage = 'Log entry message')]
        [ValidateNotNullOrEmpty()]
        [System.String[]] $Message,

        [Parameter(HelpMessage = 'Id')]
        [ValidateRange(0, 999999)]
        [System.Int32] $Id = 0
    )
    Process {

        foreach ( $msg in $Message ) {

            # STRIP CR/LF TO PREVENT LOG INJECTION (FORGED LINES)
            $sanitized = $msg -replace '[\r\n]+', '\n'

            $logEntry = '{0} [WARN ] {1} - {2}' -f (Get-Date).ToString($FORMAT), $Id, $sanitized

            Add-Content -Path $Path -Value $logEntry -ErrorAction Stop
        }
    }
}