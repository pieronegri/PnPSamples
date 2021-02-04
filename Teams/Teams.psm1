<#
.LINKS
    https://4sysops.com/archives/how-to-export-powershell-module-functions/
#>
$parent=(get-item $PSScriptRoot ).parent

@("Connect","Feature")|%{
    Remove-Module -Name $_ -Force -ErrorAction SilentlyContinue
    Import-Module -Name "$($parent.FullName)\$_\$_" -Force -Global
}


$NoExport = 'empty'
$ModuleFunctions = @(Get-ChildItem -Path $PSScriptRoot\*.ps1 -ErrorAction SilentlyContinue)
$ToExport = $ModuleFunctions | Where-Object { $_.BaseName -notin $NoExport } | Select-Object -ExpandProperty BaseName
# Dot-source the files.
foreach ($import in $ModuleFunctions) {
    try {
        Write-Verbose "Importing $($import.FullName)"
        . $import.FullName
    } catch {
        Write-Error "Failed to import function $($import.FullName): $_"
    }
}
 
Export-ModuleMember -Function $ToExport
