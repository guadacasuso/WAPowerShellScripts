
#Simple Generacion de una VM con Provisioning Config 
New-AzureVMConfig -Name "MyNonDomainVM" -InstanceSize Small -ImageName $img `
| Add-AzureProvisioningConfig -Windows –Password $Password `
| New-AzureVM -ServiceName $svcName

#Generar una VM que haga Join a un AD
VMConfig -Name "MyDomainVM" -InstanceSize Small -ImageName $img `
 | Add-AzureProvisioningConfig -WindowsDomain –Password $Password -ResetPasswordOnFirstLogon `
 -JoinDomain "contoso.com" -Domain "contoso" -DomainUserName "domainadminuser" `
 -DomainPassword "domainPassword" -MachineObjectOU 'OU=AzureVMs,DC=contoso,DC=com' `
 | New-AzureVM -ServiceName $svcName


 #Abrir Endpoint 80 de la Maquina Virtual
 Get-AzureVM -ServiceName "mySvc" -Name "MyVM1" |`
  Add-AzureEndpoint -Name "HttpIn" -Protocol "tcp" -PublicPort 80 `
  -LocalPort 8080 | Update-AzureVM 

#Abrir Endpoint 80 de la Maquina Virtual corriendo Node y Express 
  Get-AzureVM -ServiceName "myServerNose" -Name "MyVMNode" |`
  Add-AzureEndpoint -Name "HTTP" -Protocol "tcp" -PublicPort 80 `
  -LocalPort 3000| Update-AzureVM 

#AConfigurar LB 
Get-AzureVM -ServiceName "myLBSvc" -Name "MyVM2"`
| Add-AzureEndpoint -Name "HttpIn" -Protocol `   "http" -PublicPort 80 -LocalPort 8080 `
-LBSetName "WebFarm" -ProbePort 80 -ProbeProtocol "http" -ProbePath '/' `
| Update-AzureVM

#Obtener un Endpoint 
 Get-AzureVM –ServiceName “MyService” –Name “MyVM” | Get-AzureEndpoint

#Obtener un Endpoint 
 Get-AzureVM –ServiceName "MyService" –Name “MyVM” | Remove-AzureEndpoint –Name "HttpIn" |`
  Update-AzureVM

#Setear un nuevo Endpoint 
 Get-AzureVM -ServiceName "MyService" -Name "MyVM" | Set-AzureEndpoint -Name "Web" -PublicPort 80 `
 -LocalPort 8080 -Protocol "tcp" | Update-AzureVM
