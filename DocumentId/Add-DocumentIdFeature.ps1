<#
.Description
    This function will create 
        1. a team of name $teamTitle in the tenant $tenant according to the template.xml located in the local path $templatePath
        2. enable the DocumentID Feature to the sharepoint site collection underneath the team
        3. add the DocumentID Column the the default view of the library in the $libraryName parameters
        The owner of the team will be the user executing the script
        The member feature is to be implemented
    
    The first time you can add your admin credentials (no MFA).
    Add-PnPStoredCredential -Name $tenantUrl -Username <ADMIN_USER_NAME> -Password $(<ADMIN_PSW>|ConvertTo-SecureString -AsPlainText -Force)
    This is storing the credentials in windows credential manager so that Connect-myPnPOnline cmdlet will not prompt for credentials again.
.LINK
    https://www.sharepointdiary.com/2019/03/sharepoint-online-enable-document-id-service-using-powershell.html
    https://www.collabmagazine.com/provisioning-teams-in-microsoft-teams-using-the-pnp-provisioning-engine
#>
function Add-DocumentIdFeature
{
    param ($siteURl,$docIdPrefix="myPrefix",$libraryName="Documents")
    Connect-myPnPOnline -Url $siteUrl
    $featureId = "b50e3104-6812-424f-a011-cc90e6327318" #Document ID Feature
    #Configure the Document ID properties in $siteURL
    Write-host -f Yellow "Activating Service Feature..."
    
    #Get the Feature status
    If(Get-SiteFeatureStatus -siteURl $siteUrl -featureId $featureId -eq [FeatureStatus]::Inactive)
    {   
        #enable document id feature in sharepoint online using powershell
        Write-host -f Yellow "Activating Service Feature..."
        Enable-PnPFeature -Scope Site -Identity $featureId -Force

        Write-host -f Green "Service Feature Activated Successfully!"
    }
    Else
    {
        Write-host -f Yellow "Service Feature is already active!"
    }
    Set-DocIdPropertyBag -siteURl $siteURl -docIdPrefix $docIdPrefix
    Add-ColumnToDefaultView -siteURl $siteURl -libraryName $libraryName -columnRef "_dlc_DocIdUrl"
}

