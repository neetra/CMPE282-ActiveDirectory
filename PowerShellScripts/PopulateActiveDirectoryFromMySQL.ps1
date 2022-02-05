﻿# Refernce : http://woshub.com/run-mysql-queries-from-powershell/

#Connect to my sql
[system.reflection.assembly]::LoadWithPartialName("MySql.Data") 
$mysql_server = "localhost"
$mysql_user = "root"
$mysql_password = "netra_123"
$mysql_database = "employees"
write-host "Create conection to $mysql_database"
# Connect to MySQL database 'db1'

$cn = New-Object -TypeName MySql.Data.MySqlClient.MySqlConnection
$cn.ConnectionString = "SERVER=$mysql_server;DATABASE=$mysql_database;UID=$mysql_user;PWD=$mysql_password"

$MYSQLCommand = New-Object MySql.Data.MySqlClient.MySqlCommand
$MYSQLDataAdapter = New-Object MySql.Data.MySqlClient.MySqlDataAdapter
$MYSQLDataSet = New-Object System.Data.DataSet
$MYSQLCommand.Connection=$cn
$currentDirc = $PSScriptRoot + "\FetchUsersByDepartment.sql"

$sql = Get-Content $currentDirc 

$OFS = "`r`n"
$MYSQLCommand.CommandText = "$sql"
$currentDirc = $PSScriptRoot + "\FetchUsersByDepartment.sql"

#$MYSQLCommand.CommandText='SELECT * from  employees'
$MYSQLDataAdapter.SelectCommand=$MYSQLCommand
$NumberOfDataSets=$MYSQLDataAdapter.Fill($MYSQLDataSet, "data")
$allemployees = [system.collections.arrayList]@()
foreach($DataSet in $MYSQLDataSet.tables[0])
{
$employee =[pscustomobject]@{
    FirstName = $DataSet.first_name
    LastName = $DataSet.last_name
    Department = $DataSet.dept_name
}
$allemployees.Add($employee)
$newPath  = $PSScriptRoot + "\employees.csv"
$employee | export-csv -Path $newPath -Append
write-host "First NAme:" $DataSet.first_name  "Last Name:" $DataSet.last_name "Department :" $DataSet.dept_name
}
$allemployees | export-csv -Path 'PSScriptRoot\employees2.csv'

$Connection.Close()


$cn.Open()
write-host "Running backup script against db1"