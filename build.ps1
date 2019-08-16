$env:isVs2017 = 'false'
if (test-path "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community") { $env:isVs2017 = 'true' }
if ($env:isVs2017 -eq 'true' -and ($env:PGSQL_VERSION -eq '9.3' -or $env:PGSQL_VERSION -eq '9.4' -or $env:PGSQL_VERSION -eq '9.5')) { Exit-AppveyorBuild }
$s_name = postgresql-x64-$env:PGSQL_VERSION
$s_name
Start-Service "postgresql-x64-$env:PGSQL_VERSION"
Start-Sleep -s 10
get-service $s_name | select Displayname,Status,ServiceName
$env:PGUSER = 'postgres'
$env:PGPASSWORD = 'Password12!'
$oldpath = (Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name PATH).path
$newpath = "$oldpath;C:\Program Files\PostgreSQL\$env:PGSQL_VERSION\bin\;C:\Program Files\PostgreSQL\$env:PGSQL_VERSION\lib\"
Set-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name PATH -Value $newPath
echo (Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name PATH).path
cmd /c createdb #TestDatabase
