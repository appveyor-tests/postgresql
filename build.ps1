$env:isVs2017 = 'false'
if (test-path "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community") { $env:isVs2017 = 'true' }
if ($env:isVs2017 -eq 'true' -and ($env:PGSQL_VERSION -eq '9.3' -or $env:PGSQL_VERSION -eq '9.4' -or $env:PGSQL_VERSION -eq '9.5')) { Exit-AppveyorBuild }
Start-Service "postgresql-x64-$env:PGSQL_VERSION"
$env:PGUSER=postgres
$env:PGPASSWORD=Password12!
$oldpath = (Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name PATH).path
$newpath = "$oldpath;C:\Program Files\PostgreSQL\$env:PGSQL_VERSION\bin\"
Set-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name PATH -Value $newPath
cmd /c 'createdb TestDatabase'
