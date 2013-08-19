
$subscription = "[Your Subscription Name]"
$service = "[Your Azure Service Name]"
$slot = "staging" #staging or production
$package = "[ProjectName]\bin\[BuildConfigName]\app.publish\[ProjectName].cspkg"
$configuration = "[ProjectName]\bin\[BuildConfigName]\app.publish\ServiceConfiguration.Cloud.cscfg"
$timeStampFormat = "g"
$deploymentLabel = "ContinuousDeploy to $service v%build.number%"
 
Write-Output "Running Azure Imports"
Import-Module "C:\Program Files (x86)\Microsoft SDKs\Windows Azure\PowerShell\Azure\*.psd1"
Import-AzurePublishSettingsFile "C:\TeamCity\[PSFileName].publishsettings"
Set-AzureSubscription -CurrentStorageAccount $service -SubscriptionName $subscription
 
function Publish(){
$deployment = Get-AzureDeployment -ServiceName $service -Slot $slot -ErrorVariable a -ErrorAction silentlycontinue
 
if ($a[0] -ne $null) {
Write-Output "$(Get-Date -f $timeStampFormat) - No deployment is detected. Creating a new deployment. "
}
if ($deployment.Name -ne $null) {
#Update deployment inplace (usually faster, cheaper, won't destroy VIP)
Write-Output "$(Get-Date -f $timeStampFormat) - Deployment exists in $servicename. Upgrading deployment."
UpgradeDeployment
} else {
CreateNewDeployment
}
}
 
function CreateNewDeployment()
{
write-progress -id 3 -activity "Creating New Deployment" -Status "In progress"
Write-Output "$(Get-Date -f $timeStampFormat) - Creating New Deployment: In progress"
 
$opstat = New-AzureDeployment -Slot $slot -Package $package -Configuration $configuration -label $deploymentLabel -ServiceName $service
 
$completeDeployment = Get-AzureDeployment -ServiceName $service -Slot $slot
$completeDeploymentID = $completeDeployment.deploymentid
 
write-progress -id 3 -activity "Creating New Deployment" -completed -Status "Complete"
Write-Output "$(Get-Date -f $timeStampFormat) - Creating New Deployment: Complete, Deployment ID: $completeDeploymentID"
}
 
function UpgradeDeployment()
{
write-progress -id 3 -activity "Upgrading Deployment" -Status "In progress"
Write-Output "$(Get-Date -f $timeStampFormat) - Upgrading Deployment: In progress"
 
# perform Update-Deployment
$setdeployment = Set-AzureDeployment -Upgrade -Slot $slot -Package $package -Configuration $configuration -label $deploymentLabel -ServiceName $service -Force
 
$completeDeployment = Get-AzureDeployment -ServiceName $service -Slot $slot
$completeDeploymentID = $completeDeployment.deploymentid
 
write-progress -id 3 -activity "Upgrading Deployment" -completed -Status "Complete"
Write-Output "$(Get-Date -f $timeStampFormat) - Upgrading Deployment: Complete, Deployment ID: $completeDeploymentID"
}
 
Write-Output "Create Azure Deployment"
Publish
