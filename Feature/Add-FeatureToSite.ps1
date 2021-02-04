function Add-FeatureToSite
{[cmdletbinding()]
    param (
        [Parameter(Mandatory = $true)]$siteURl,
        [Parameter(Mandatory = $true, ParameterSetName = 'DocumentId')]$docIdPrefix,
        [Parameter(Mandatory = $true, ParameterSetName = 'DocumentId')]$libraryName,
        [Parameter(Mandatory = $true)][ValidateSet('DocumentId')]$feature
    )
    if($PSCmdlet.ParameterSetName -ne $feature)
    {
        throw "wrong selection feature and parameters. You selected the feature $feature and the parameters for feature $($PSCmdlet.ParameterSetName)"
    }
    else{
        Write-Debug "parameters $($PSCmdlet.ParameterSetName) feature $feature"
    }
    Connect-myPnPOnline -Url $siteUrl
    $null=Get-PnPList -Identity $libraryName -ThrowExceptionIfListNotFound

    Write-host -f Yellow "Activating Service Feature $feature..."
    switch ($feature)
    {
        "DocumentId"
        {
            
            Add-DocumentIdFeature -siteUrl $siteURl -docIdPrefix $docIdPrefix -libraryName $libraryName
        }
    }
}
