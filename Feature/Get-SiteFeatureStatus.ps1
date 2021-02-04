function Get-SiteFeatureStatus
{
    param ($siteURl,$featureId)
    Connect-myPnPOnline -Url $siteUrl
    Write-host -f Yellow "Checking Service Feature..."
    $feature = Get-PnPFeature -Scope Site -Identity $featureId

    #Get the Feature status
    If($null -eq $feature.DefinitionId)
    {   
        Write-host -f Green "Service Feature Inactive!"
        return [FeatureStatus]::Inactive
    }
    Write-host -f Yellow "Service Feature Active!"
    return [FeatureStatus]::Active
}