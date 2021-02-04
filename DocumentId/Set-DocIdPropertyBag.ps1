function Set-DocIdPropertyBag
{
    param ($siteURl,$docIdPrefix)
    try{
        Connect-myPnPOnline -Url $siteUrl
        Set-PnpSite  -NoScriptSite $false -Identity $siteUrl
        Set-PnPPropertyBagValue -Key "docid_enabled" -Value "1"
        Set-PnPPropertyBagValue -Key "docid_msft_hier_siteprefix" -Value $docIdPrefix
    }
    catch{
        $myPsItem=$PSItem
        Write-Error "Set-PnPPropertyBagValue failed please check https://github.com/pnp/PnP-PowerShell/issues/1553"
        throw $myPsItem
    }
}

