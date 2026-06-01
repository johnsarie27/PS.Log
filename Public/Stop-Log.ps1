function Stop-Log {
    <#
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
        Status: Stable
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([System.Void])]
    Param(
        [Parameter(Mandatory, HelpMessage = 'Log file path')]
        [ValidateScript({ (Test-Path -Path $_ -PathType 'Leaf') -and $_ -like '*.log' })]
        [System.String] $Path
    )
    Begin {

        # SHOULD PROCESS
        if ($PSCmdlet.ShouldProcess($Path)) {

            $logEntry = '{0} [INFO ] # - End logging' -f (Get-Date).ToString($FORMAT)

            Add-Content -Path $Path -Value $logEntry -ErrorAction Stop
        }
    }
}