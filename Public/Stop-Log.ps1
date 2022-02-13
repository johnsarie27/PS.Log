function Stop-Log {
    <# =========================================================================
    .SYNOPSIS
        Stops log
    .DESCRIPTION
        Stops log with final message
    .PARAMETER Path
        Path to log file
    .INPUTS
        None.
    .OUTPUTS
        None.
    .EXAMPLE
        PS C:\> Stop-Log -Path C:\temp\log.log
        Adds the information-level log entry 'End logging'
    .NOTES
        General notes
    ========================================================================= #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory, HelpMessage = 'Log file path')]
        [ValidateScript({ Test-Path $_ -PathType 'Leaf' -Include "*.log" })]
        [string] $Path
    )
    Process {

        $logEntry = '{0} [INFO ] # - End logging' -f (Get-Date).ToString($FORMAT)

        Add-Content -Path $Path -Value $logEntry -ErrorAction Stop
    }
}