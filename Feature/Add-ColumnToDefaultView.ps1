function Add-ColumnToDefaultView
{
    param ($siteURl,$columnRef)
    Connect-myPnPOnline -Url $siteUrl
    $null=Get-PnPList -Identity $libraryName -ThrowExceptionIfListNotFound
    $defaultListView  =  Get-PnPView -List $libraryName | Where-Object {$_.DefaultView -eq $True}

    #Add column to the View
    If($defaultListView.ViewFields -notcontains $columnRef)
    {
        $defaultListView.ViewFields.Add($columnRef)
        $defaultListView.Update()
        Invoke-PnPQuery
        Write-host -f Green "$columnRef column Added to the Default View!"
    }
    else
    {
        Write-host -f Yellow "$columnRef column already exists in the list defaultview!"
    }
}

