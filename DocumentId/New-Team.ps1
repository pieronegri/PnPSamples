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


function New-Team(){
    param (
        [Parameter(Mandatory=$true)]$teamTitle, 
        [Parameter(Mandatory=$true,HelpMessage="Please enter the TenantName e.g. https://tenantName.sharepoint.com")]$tenant,
        [Parameter(Mandatory=$false,HelpMessage="Please enter the UserPrincipalName for 1 Member of the team (to be implemented)")]$memberUPN,
        [Parameter(Mandatory=$true, HelpMessage="Please enter the local path of your template.xml file")]$templatePath,
        $docIdPrefix="myPrefix"
    )

    $teamAlias = $teamTitle.ToLower() #this goes in the url
    $ProgressPreference = "SilentlyContinue"
    $ErrorActionPreference="Stop"

    $tenantUrl="https://{0}.sharepoint.com" -f $tenant
    $siteURL = "https://{0}.sharepoint.com/sites/{1}" -f $tenant,$teamAlias

    if(!Test-Path -Path $templatePath)
    {
        throw "404 on template Path $templatePath"
    }
    Connect-myPnPOnline -Url $tenantUrl  
    $ownerUPN=$(Get-PnPStoredCredential -Name $tenantUrl).UserName
    $parameters=@{
            "TeamTitle"=$teamTitle;
            "TeamAlias"=$teamAlias;
            "MemberUPN"=$memberUPN;
            "OwnerUPN"=$ownerUPN
    } 
    Invoke-PnPTenantTemplate -Path $templatePath -Parameters $parameters
    Connect-myPnPOnline -Url $siteURL -ErrorAction Stop
    Write-host -f Yellow "$teamTitle Team and SiteCollection Created @ $siteURL, if the Team is not created rerun the script"
    Add-DocumentIdFeature -docIdPrefix $docIdPrefix
}

