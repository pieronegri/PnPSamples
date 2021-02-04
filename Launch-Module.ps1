$moduleName="Teams"

Remove-Module -Name $moduleName -Force -ErrorAction SilentlyContinue
Import-Module -Name "$PSScriptRoot\$moduleName\$moduleName" -Force
Get-Command -Module $moduleName