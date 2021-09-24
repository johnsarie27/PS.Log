function Start-Log {
    <# =========================================================================
    .SYNOPSIS
        Start a new log file
    .DESCRIPTION
        Start a new log file
    .PARAMETER Directory
        Output directory for log file. Paraent directory must exist.
    .PARAMETER Name
        log file name
    .PARAMETER Frequency
        Frequency of new log file creation (defaults to daily)
    .INPUTS
        System.String.
    .OUTPUTS
        System.String.
    .EXAMPLE
        PS C:\> Start-Log -Directory C:\temp -Name myLog
        Creates a new log file in the folder C:\temp
    .NOTES
        General notes
    ========================================================================= #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory, ValueFromPipeline, HelpMessage = 'Output directory for log file')]
        [ValidateScript({ Test-Path -Path (Split-Path -Path $_) -PathType Container })]
        [string] $Directory,

        [Parameter(Mandatory, HelpMessage = 'Log file name')]
        [ValidateNotNullOrEmpty()]
        [string] $Name,

        [Parameter(HelpMessage = 'New log file creation frequency')]
        [ValidateSet('Daily', 'Monthly', 'Yearly')]
        [string] $Frequency = 'Daily'
    )
    Begin {
        # CREATE DIRECTORY IF NOT EXIST
        if ( -not (Test-Path $Directory) ) { New-Item -Path $Directory -ItemType "Directory" -Force | Out-Null }

        # SET DATE FORMAT FOR LOG NAME
        $dateFormat = switch ($Frequency) {
            'Yearly'  { '{0:yyyy}' -f (Get-Date) }
            'Monthly' { '{0:yyyy-MM}' -f (Get-Date) }
            'Daily'   { '{0:yyyy-MM-dd}' -f (Get-Date) }
        }

        # SET FILE LOG PATH
        $filePath = Join-Path -Path $Directory -ChildPath ('{0}-{1}.log' -f $Name, $dateFormat)

        # CHECK FOR EXISTANCE OF LOG FILE
        if ( Test-Path -Path $filePath ) { throw 'Log file already exists.' }

        # ADD INITIAL LOG ENTRY
        $logEntry = '{0} # [INFO ] - Begin Logging' -f (Get-Date).ToString($format)

        # ADD FIRST ENTRY TO LOG FILE
        Set-Content -Path $filePath -Value $logEntry
    }
    End {
        # RETURN FILEPATH
        return $filePath
    }
}