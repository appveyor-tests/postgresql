$env:isVs2017 = 'false'
if (test-path "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community") { $env:isVs2017 = 'true' }
Write-Host "Is VS 2017?: $env:isVs2017"
if ($env:isVs2017 -eq 'true' -and ($env:PGSQL_VERSION -eq '9.3' -or $env:PGSQL_VERSION -eq '9.4' -or $env:PGSQL_VERSION -eq '9.5')) { 
  Write-Host "It's Visual Sturdio 2017, exiting..."
  #cmd /c appveyor exit #Exit-AppveyorBuild
  #return
  exit 99101
}
$s_name = "postgresql-x64-$env:PGSQL_VERSION"
dir "C:\Program Files\PostgreSQL\"
Start-Service "postgresql-x64-$env:PGSQL_VERSION"
get-service $s_name | select Displayname,Status,ServiceName
$env:PGUSER = 'postgres'
$env:PGPASSWORD = 'Password12!'
$env:path = $env:path + ";C:\Program Files\PostgreSQL\$env:PGSQL_VERSION\bin\"
cmd /c createdb.exe TestDatabase
if($LastExitCode -ne 0) { $host.SetShouldExit($LastExitCode) }


