function Write-LogWarn {
    <# =========================================================================
    .SYNOPSIS
        Write INFO to log
    .DESCRIPTION
        Write INFO to log
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
    ========================================================================= #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory, HelpMessage = 'Log file path')]
        [ValidateScript({ Test-Path $_ -PathType 'Leaf' -Include "*.log" })]
        [string] $Path,

        [Parameter(Mandatory, ValueFromPipeline, HelpMessage = 'Log entry message')]
        [ValidateNotNullOrEmpty()]
        [string[]] $Message,

        [Parameter(HelpMessage = 'Id')]
        [ValidateRange(0, 99999)]
        [int] $Id = 0
    )
    Process {

        foreach ( $msg in $Message ) {

            $logEntry = '{0} [WARN ] {1} - {2}' -f (Get-Date).ToString($format), $Id, $msg

            Add-Content -Path $Path -Value $logEntry -ErrorAction Stop
        }
    }
}