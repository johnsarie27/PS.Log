BeforeDiscovery {
    if (-not (Get-Module -Name $env:BHProjectName)) {
        Import-Module -Name $env:BHPSModuleManifest -ErrorAction Stop -Force
    }
}

Describe -Name 'Stop-Log' -Fixture {

    BeforeAll {
        $script:dir = Join-Path -Path $TestDrive -ChildPath 'stop-log'
        New-Item -Path $script:dir -ItemType Directory -Force | Out-Null
    }

    Context -Name 'normal usage' -Fixture {
        It -Name 'should append the End logging entry to an existing log file' -Test {
            $path = Start-Log -Directory $script:dir -Name 'stop-normal'
            Stop-Log -Path $path
            Get-Content -Path $path | Select-Object -Last 1 | Should -Match 'End logging'
        }
    }

    Context -Name 'parameter validation' -Fixture {
        It -Name 'should reject a path that does not exist' -Test {
            { Stop-Log -Path (Join-Path $script:dir 'nope.log') } | Should -Throw
        }

        It -Name 'should reject a path without a .log extension' -Test {
            $notLog = Join-Path -Path $script:dir -ChildPath 'not-a-log.txt'
            Set-Content -Path $notLog -Value 'x'
            { Stop-Log -Path $notLog } | Should -Throw
        }
    }
}
