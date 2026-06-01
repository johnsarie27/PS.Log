function Write-LogDebug {
    <#
    .SYNOPSIS
        Write DEBUG to log
    .DESCRIPTION
        Write DEBUG to log
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
        PS C:\> Write-LogDebug -Path C:\temp\log.log -Message 'process started'
        Adds the debug-level log entry 'process started'
    .NOTES
        Status: Stable
    #>
    [CmdletBinding()]
    [OutputType([System.Void])]
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

            $logEntry = '{0} [DEBUG] {1} - {2}' -f (Get-Date).ToString($FORMAT), $Id, $sanitized

            Add-Content -Path $Path -Value $logEntry -ErrorAction Stop
        }
    }
}