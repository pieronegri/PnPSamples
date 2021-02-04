<#
.Description
    This function will add the DocumentId Feature
.LINK
    https://www.sharepointdiary.com/2019/03/sharepoint-online-enable-document-id-service-using-powershell.html
#>

function Add-DocumentIdFeature
{
    param (
        [Parameter(Mandatory = $true)]$siteURl,
        [Parameter(Mandatory = $true)]$docIdPrefix,
        [Parameter(Mandatory = $true)]$libraryName
    )
    Connect-myPnPOnline -Url $siteUrl
    $featureId = "b50e3104-6812-424f-a011-cc90e6327318" #Document ID Feature
    #Configure the Document ID properties in $siteURL
    Write-Verbose "Add-DocumentIdFeature Starting..."
    
    #Get the Feature status
    If(Get-SiteFeatureStatus -siteURl $siteUrl -featureId $featureId -eq [FeatureStatus]::Inactive)
    {   
        #enable document id feature in sharepoint online using powershell
        Enable-PnPFeature -Scope Site -Identity $featureId -Force
        Write-host -f Green "DocumentId Service Feature Activated Successfully!"
    }
    Else
    {
        Write-host -f Yellow "DocumentId Service Feature is already active!"
    }
    Set-DocIdPropertyBag -siteURl $siteURl -docIdPrefix $docIdPrefix
    Add-ColumnToDefaultView -siteURl $siteURl -libraryName $libraryName -columnRef "_dlc_DocIdUrl"
}

