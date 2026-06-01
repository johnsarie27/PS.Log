BeforeDiscovery {
    if (-not (Get-Module -Name $env:BHProjectName)) {
        Import-Module -Name $env:BHPSModuleManifest -ErrorAction Stop -Force
    }
}

Describe -Name 'Write-LogError' -Fixture {

    BeforeAll {
        $script:dir = Join-Path -Path $TestDrive -ChildPath 'write-error'
        New-Item -Path $script:dir -ItemType Directory -Force | Out-Null
        $script:path = Start-Log -Directory $script:dir -Name 'error'
    }

    Context -Name 'normal usage' -Fixture {
        It -Name 'should append an [ERROR] entry containing the message' -Test {
            Write-LogError -Path $script:path -Message 'boom'
            Get-Content -Path $script:path | Select-Object -Last 1 | Should -Match '\[ERROR\] 0 - boom$'
        }
    }

    Context -Name 'security' -Fixture {
        It -Name 'should sanitize CR/LF so a message cannot forge an extra log line' -Test {
            $before = (Get-Content -Path $script:path).Count
            Write-LogError -Path $script:path -Message "x`ny"
            $after = (Get-Content -Path $script:path).Count
            ($after - $before) | Should -Be 1
            Get-Content -Path $script:path | Select-Object -Last 1 | Should -Match 'x\\ny$'
        }
    }

    Context -Name 'parameter validation' -Fixture {
        It -Name 'should reject an Id outside the 0..999999 range' -Test {
            { Write-LogError -Path $script:path -Message 'x' -Id 1000000 } | Should -Throw
        }
    }
}
