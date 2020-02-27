$pg_versions = @('9.3', '9.4', '9.5', '9.6', '10')
if (test-path "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community") { $pg_versions = @('9.6', '10') }
if (test-path "C:\Program Files (x86)\Microsoft Visual Studio\2019\Community") { $pg_versions = @('9.6', '10', '11', '12') }

dir "C:\Program Files\PostgreSQL\"
$env:PGUSER = 'postgres'
$env:PGPASSWORD = 'Password12!'

foreach ($pg_version in $pg_versions) {
	$svc_name = "postgresql-x64-$pg_version"
	Write-Host "Starting $svc_name..."
	Start-Service $svc_name
	
	get-service $svc_name | select Displayname,Status,ServiceName
	$env:path = "C:\Program Files\PostgreSQL\$pg_version\bin;$env:path"
	
	Write-Host "Creating test database..."
	cmd /c createdb.exe TestDatabase
	if($LastExitCode -ne 0) { $host.SetShouldExit($LastExitCode) }
	
	Write-Host "Stopping $svc_name..."
	Stop-Service $svc_name
}
