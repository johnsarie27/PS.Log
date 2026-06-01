BeforeDiscovery {
    if (-not (Get-Module -Name $env:BHProjectName)) {
        Import-Module -Name $env:BHPSModuleManifest -ErrorAction Stop -Force
    }
}

Describe -Name 'Start-Log' -Fixture {

    BeforeAll {
        $script:tmpRoot = Join-Path -Path $TestDrive -ChildPath 'start-log'
        New-Item -Path $script:tmpRoot -ItemType Directory -Force | Out-Null
    }

    Context -Name 'normal usage' -Fixture {
        It -Name 'should create a log file and return its path' -Test {
            $dir = Join-Path -Path $script:tmpRoot -ChildPath 'normal'
            $result = Start-Log -Directory $dir -Name 'app'
            $result | Should -Not -BeNullOrEmpty
            Test-Path -Path $result | Should -BeTrue
            $result | Should -BeLike '*.log'
        }

        It -Name 'should write the initial Begin Logging entry' -Test {
            $dir = Join-Path -Path $script:tmpRoot -ChildPath 'initial'
            $path = Start-Log -Directory $dir -Name 'app'
            (Get-Content -Path $path -TotalCount 1) | Should -Match 'Begin Logging'
        }

        It -Name 'should create the target directory if it does not exist' -Test {
            $dir = Join-Path -Path $script:tmpRoot -ChildPath ('mkdir-' + [Guid]::NewGuid().ToString('N').Substring(0,6))
            Test-Path -Path $dir | Should -BeFalse
            Start-Log -Directory $dir -Name 'app' | Out-Null
            Test-Path -Path $dir | Should -BeTrue
        }
    }

    Context -Name 'parameter validation' -Fixture {
        It -Name 'should reject -Name containing path-traversal characters' -Test {
            { Start-Log -Directory $script:tmpRoot -Name '..\evil' } | Should -Throw
        }

        It -Name 'should reject -Name containing a path separator' -Test {
            { Start-Log -Directory $script:tmpRoot -Name 'sub/app' } | Should -Throw
        }

        It -Name 'should reject an invalid -Frequency value' -Test {
            { Start-Log -Directory $script:tmpRoot -Name 'app' -Frequency 'Hourly' } | Should -Throw
        }
    }

    Context -Name 'error handling' -Fixture {
        It -Name 'should Write-Error when the target log file already exists' -Test {
            $dir = Join-Path -Path $script:tmpRoot -ChildPath 'exists'
            Start-Log -Directory $dir -Name 'app' | Out-Null
            { Start-Log -Directory $dir -Name 'app' -ErrorAction Stop } |
                Should -Throw -ExpectedMessage 'Log file already exists*'
        }
    }
}
