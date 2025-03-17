# This is a simple script that checks if all resources in a resource group have a specific tag and adds it if missing.

# Define variables
$Subscription_ID = "YOUR_SUBSCRIPTION_ID"
$Resource_Group = "YOUR_RESOURCE_GROUP"
$Tag_Key = "Environment" #Replace with own value
$Tag_Value = "Production" #Replace with own value

# Get all resources in the resource group
$resources = az resource list --resource-group $Resource_Group | ConvertFrom-Json

foreach ($resource in $resources) {
    # Check if the tag exists
    if (-not ($resource.tags.$Tag_Key)) {
        Write-Host "Adding missing tag to resource: $($resource.name)"
        az resource tag --ids $resource.id --tags @{ $Tag_Key = $Tag_Value }
    } else {
        Write-Host "Resource $($resource.name) already has the required tag."
    }
}
