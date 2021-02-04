function Connect-myPnPOnLine
{
    param ([Parameter(Mandatory=$true)]$Url,[switch]$force)
    if($global:connectedSiteUrl -ne $Url -or $force.IsPresent)
    {
        Connect-PnPOnline -Url $Url
        $global:connectedSiteUrl=$Url
    }
}