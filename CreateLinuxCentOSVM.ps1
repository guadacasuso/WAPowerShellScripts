<#
.SYNOPSIS
    Creates a new VM 
.DESCRIPTION
    1 - Get the list of the Images
    2 - Get the list of the locations
    3 - Create the VM and its associated VM 
      `
.EXAMPLE
    CreateLinuxCentOSVM 
    This example creates a new RightImage CentOS 6.3 x64 VM  
#>



# Mark the start time of the script execution
$startTime = Get-Date

Set-StrictMode -Version 3
$VerbosePreference = "Continue"
$ErrorActionPreference = "Stop"

#Get the images of Windows Server availables
$images = Get-AzureVMImage `
| where { $_.ImageFamily -eq “RightScale Linux v13” } 

$locations = Get-AzureLocation

$mySvc = "UniqueNameOfYourServiceLinux"

# You can test if the Service already exist 
$serviceExist= Test-AzureName -Name $mySvc -Service 

if($serviceExist)
{
    throw "The service already exists - Please select a new one"
    exit; 
}
else
{

    $myPwd = "P@ssw0rd"
    $userName = "username"

    #Be sure to select a Windows Server Image from the list (Ex $images[80].imagename) 
    #Consider the  Source image location to be the same one than the one of the affinity group

    New-AzureQuickVM -Linux -name "MyVM" -ImageName $images[2].imagename  -ServiceName $mySvc `
                      -Location $locations[6].name -LinuxUser $userName -Password $myPwd


}

$finishTime= Get-Date

Write-Verbose ("Total time used (seconds): {0}" -f ($finishTime - $startTime).TotalSeconds)
