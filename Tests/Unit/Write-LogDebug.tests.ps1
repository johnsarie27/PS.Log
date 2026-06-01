BeforeDiscovery {
    if (-not (Get-Module -Name $env:BHProjectName)) {
        Import-Module -Name $env:BHPSModuleManifest -ErrorAction Stop -Force
    }
}

Describe -Name 'Write-LogDebug' -Fixture {

    BeforeAll {
        $script:dir = Join-Path -Path $TestDrive -ChildPath 'write-debug'
        New-Item -Path $script:dir -ItemType Directory -Force | Out-Null
        $script:path = Start-Log -Directory $script:dir -Name 'debug'
    }

    Context -Name 'normal usage' -Fixture {
        It -Name 'should append a [DEBUG] entry containing the message' -Test {
            Write-LogDebug -Path $script:path -Message 'detail'
            Get-Content -Path $script:path | Select-Object -Last 1 | Should -Match '\[DEBUG\] 0 - detail$'
        }
    }

    Context -Name 'security' -Fixture {
        It -Name 'should sanitize CR/LF so a message cannot forge an extra log line' -Test {
            $before = (Get-Content -Path $script:path).Count
            Write-LogDebug -Path $script:path -Message "a`r`nb"
            $after = (Get-Content -Path $script:path).Count
            ($after - $before) | Should -Be 1
        }
    }

    Context -Name 'parameter validation' -Fixture {
        It -Name 'should reject an Id outside the 0..999999 range' -Test {
            { Write-LogDebug -Path $script:path -Message 'x' -Id 1000000 } | Should -Throw
        }
    }
}
