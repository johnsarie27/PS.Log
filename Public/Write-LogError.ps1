function Write-LogError {
    <#
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
        PS C:\> Write-LogError -Path C:\temp\log.log -Message 'Job encountered an error'
        Adds the error-level log entry 'Job encountered an error'
    .NOTES
        General notes
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory, HelpMessage = 'Log file path')]
        [ValidateScript({ Test-Path $_ -PathType 'Leaf' -Include "*.log" })]
        [System.String] $Path,

        [Parameter(Mandatory, ValueFromPipeline, HelpMessage = 'Log entry message')]
        [ValidateNotNullOrEmpty()]
        [System.String[]] $Message,

        [Parameter(HelpMessage = 'Id')]
        [ValidateRange(0, 99999)]
        [System.Int32] $Id = 0
    )
    Process {

        foreach ( $msg in $Message ) {

            $logEntry = '{0} [ERROR] {1} - {2}' -f (Get-Date).ToString($FORMAT), $Id, $msg

            Add-Content -Path $Path -Value $logEntry -ErrorAction Stop
        }
    }
}