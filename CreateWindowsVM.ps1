<#
.SYNOPSIS
    Creates a new VM 
.DESCRIPTION
    1 - Get the list of the Images
    2 - Get the list of the locations
    3 - Create the VM and its associated VM 
      `
.EXAMPLE
    CreateWindowsVM 
    This example creates a new Windows VM 
#>



# Mark the start time of the script execution
$startTime = Get-Date

Set-StrictMode -Version 3
$VerbosePreference = "Continue"
$ErrorActionPreference = "Stop"

$images = Get-AzureVMImage

$locations = Get-AzureLocation

$mySvc = "UniqueNameOfYourService"

$myPwd = "P@ssw0rd"

$userName = "User"

#Be sure to select a Windows Server Image from the list (Ex $images[80].imagename) 
#Consider the  Source image location to be the same one than the one of the affinity group

New-AzureQuickVM -Windows -name "MyWinVM" -ImageName $images[80].imagename  -ServiceName $mySvc -Location $locations[6].name -AdminUsername $userName -Password $myPwd

$finishTime= Get-Date

Write-Verbose ("Total time used (seconds): {0}" -f ($finishTime - $startTime).TotalSeconds)
