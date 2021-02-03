
#Read more: 
#https://www.sharepointdiary.com/2019/03/sharepoint-online-enable-document-id-service-using-powershell.html
#https://www.collabmagazine.com/provisioning-teams-in-microsoft-teams-using-the-pnp-provisioning-engine

#you need a sharepoint admin user with no MFA required
#install the pnp module via Install-Module -Name PnP.PowerShell -force

function New-Team(){
    param (
        [Parameter(Mandatory=$true)]$teamTitle, 
        [Parameter(Mandatory=$true,HelpMessage="Please enter the TenantName e.g. https://tenantName.sharepoint.com")]$tenant,
        [Parameter(Mandatory=$false,HelpMessage="Please enter the UserPrincipalName for 1 Member of the team (to be implemented)")]$memberUPN,
        $libraryName="Documents",
        [Parameter(Mandatory=$true, HelpMessage="Please enter the local path of your template.xml file")]$templatePath,
        $docIdPrefix="myPrefix"
    )

    $teamAlias = $teamTitle.ToLower() #this goes in the url
    $ProgressPreference = "SilentlyContinue"
    $ErrorActionPreference="Stop"

    $tenantUrl="https://{0}.sharepoint.com" -f $tenant
    $siteURL = "https://{0}.sharepoint.com/sites/{1}" -f $tenant,$teamAlias
    $featureId = "b50e3104-6812-424f-a011-cc90e6327318" #Document ID Feature

    #the first time you can add your admin credentials. This is storing the credentials in windows credential manager
    #Add-PnPStoredCredential -Name $tenantUrl -Username <ADMIN_USER_NAME> -Password $(<ADMIN_PSW>|ConvertTo-SecureString -AsPlainText -Force)

    try{
        Connect-PnPOnline -Url $siteURL -ErrorAction Stop
    }
    catch{
        #Connect to the tenant and create the Team from the templatefileName
        Connect-PnPOnline -Url $tenantUrl  
        $ownerUPN=$(Get-PnPStoredCredential -Name $tenantUrl).UserName
        $parameters=@{
            "TeamTitle"=$teamTitle;
            "TeamAlias"=$teamAlias;
            "MemberUPN"=$memberUPN;
            "OwnerUPN"=$ownerUPN
        } 
        Invoke-PnPTenantTemplate -Path $templatePath -Parameters $parameters
    }
    finally{
        Connect-PnPOnline -Url $siteURL -ErrorAction Stop
        Write-host -f Yellow "$teamTitle Team and SiteCollection Created @ $siteURL"
    }

    #Configure the Document ID properties in $siteURL
    Write-host -f Yellow "Activating Document ID Service Feature..."
    $feature = Get-PnPFeature -Scope Site -Identity $featureId
  
    #Get the Feature status
    If($feature.DefinitionId -eq $null)
    {   
        #enable document id feature in sharepoint online using powershell
        Write-host -f Yellow "Activating Document ID Service Feature..."
        Enable-PnPFeature -Scope Site -Identity $featureId -Force
  
        Write-host -f Green "Document ID Service Feature Activated Successfully!"
    }
    Else
    {
        Write-host -f Yellow "Document ID Service Feature is already active!"
    }
    
    try{
        Set-PnPPropertyBagValue -Key "docid_enabled" -Value "1"
        Set-PnPPropertyBagValue -Key "docid_msft_hier_siteprefix" -Value $docIdPrefix
    }
    catch{
        Write-Error "Set-PnPPropertyBagValue failed please check https://github.com/pnp/PnP-PowerShell/issues/1553"
    }
    $defaultListView  =  Get-PnPView -List $libraryName | Where {$_.DefaultView -eq $True}
 
    #Add column to the View
    If($defaultListView.ViewFields -notcontains "_dlc_DocIdUrl")
    {
        $defaultListView.ViewFields.Add("_dlc_DocIdUrl")
        $defaultListView.Update()
        Invoke-PnPQuery
        Write-host -f Green "Document ID column Added to the Default View!"
    }
    else
    {
        Write-host -f Yellow "Document ID column already exists in the list!"
    }
}



