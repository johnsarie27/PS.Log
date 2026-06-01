BeforeDiscovery {
    if (-not (Get-Module -Name $env:BHProjectName)) {
        Import-Module -Name $env:BHPSModuleManifest -ErrorAction Stop -Force
    }
}

Describe -Name 'Write-LogInfo' -Fixture {

    BeforeAll {
        $script:dir = Join-Path -Path $TestDrive -ChildPath 'write-info'
        New-Item -Path $script:dir -ItemType Directory -Force | Out-Null
        $script:path = Start-Log -Directory $script:dir -Name 'info'
    }

    Context -Name 'normal usage' -Fixture {
        It -Name 'should append an [INFO ] entry containing the message' -Test {
            Write-LogInfo -Path $script:path -Message 'hello'
            Get-Content -Path $script:path | Select-Object -Last 1 | Should -Match '\[INFO \] 0 - hello$'
        }

        It -Name 'should include the Id when provided' -Test {
            Write-LogInfo -Path $script:path -Message 'with-id' -Id 42
            Get-Content -Path $script:path | Select-Object -Last 1 | Should -Match '\[INFO \] 42 - with-id$'
        }

        It -Name 'should accept multiple messages from the pipeline' -Test {
            'a','b' | Write-LogInfo -Path $script:path
            $tail = Get-Content -Path $script:path | Select-Object -Last 2
            $tail[0] | Should -Match '\[INFO \] 0 - a$'
            $tail[1] | Should -Match '\[INFO \] 0 - b$'
        }
    }

    Context -Name 'security' -Fixture {
        It -Name 'should sanitize CR/LF so a message cannot forge an extra log line' -Test {
            $before = (Get-Content -Path $script:path).Count
            Write-LogInfo -Path $script:path -Message "line1`r`nFAKE [ERROR] 0 - injected"
            $after = (Get-Content -Path $script:path).Count
            ($after - $before) | Should -Be 1
            Get-Content -Path $script:path | Select-Object -Last 1 | Should -Match 'line1\\nFAKE'
        }
    }

    Context -Name 'parameter validation' -Fixture {
        It -Name 'should reject a non-existent path' -Test {
            { Write-LogInfo -Path (Join-Path $script:dir 'nope.log') -Message 'x' } | Should -Throw
        }

        It -Name 'should reject a path without a .log extension' -Test {
            $notLog = Join-Path -Path $script:dir -ChildPath 'info-not-a-log.txt'
            Set-Content -Path $notLog -Value 'x'
            { Write-LogInfo -Path $notLog -Message 'x' } | Should -Throw
        }

        It -Name 'should reject an empty message' -Test {
            { Write-LogInfo -Path $script:path -Message '' } | Should -Throw
        }

        It -Name 'should reject an Id outside the 0..999999 range' -Test {
            { Write-LogInfo -Path $script:path -Message 'x' -Id 1000000 } | Should -Throw
        }
    }
}
