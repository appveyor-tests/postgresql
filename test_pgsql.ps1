$pg_versions = @('9.3', '9.4', '9.5', '9.6', '10')
if (test-path "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community") { $pg_versions = @('9.6', '10') }
if (test-path "C:\Program Files (x86)\Microsoft Visual Studio\2019\Community") { $pg_versions = @('9.6', '10', '11', '12') }

foreach($pg_version in $pg_versions) {
	$svc_name = "postgresql-x64-$pg_version"
	dir "C:\Program Files\PostgreSQL\"
	Start-Service $svc_name
	get-service $svc_name | select Displayname,Status,ServiceName
	$env:PGUSER = 'postgres'
	$env:PGPASSWORD = 'Password12!'
	$env:path = "C:\Program Files\PostgreSQL\$pg_version\bin;$env:path"
	cmd /c createdb.exe TestDatabase
	if($LastExitCode -ne 0) { $host.SetShouldExit($LastExitCode) }
	Stop-Service $svc_name
}
