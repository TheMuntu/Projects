# I use this script to identifie and delete unused public IP addresses in a subscription.

# Define variables
$Subscription_ID = "YOUR_SUBSCRIPTION_ID"
$Resource_Group = "YOUR_RESOURCE_GROUP"

# Get all public IP addresses in the resource group
$publicIPs = az network public-ip list --resource-group $Resource_Group | ConvertFrom-Json

foreach ($ip in $publicIPs) {
    if ($ip.ipAddress -eq $null) {
        Write-Host "Deleting unused Public IP: $($ip.name)"
        az network public-ip delete --resource-group $Resource_Group --name $ip.name
    } else {
        Write-Host "Public IP $($ip.name) is in use."
    }
}
