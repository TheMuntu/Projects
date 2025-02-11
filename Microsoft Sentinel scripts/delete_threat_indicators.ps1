# Define your Workspace variables

$Subscription_ID = "YOUR_SUBSCRIPTION_ID"
$Resource_Group = "YOUR_RESOURCEGROUP_NAME"
$Workspace= "YOUR_WORKSPACE_NAME"
$API_VERSION = "YOUR_API_VERSION"

$NumberOfIterations = 30 # HERE WE ARE RUNNING 30 ITERATIONS OF 1000 DELETIONS. YOU MUST ADJUST BASED ON YOUR NEEDS

for ($i = 1; $i -le $NumberOfIterations; $i++) { 
    Write-Host "Starting iteration: $i"

    #Query and Save Indicators
    try {
        $jsonResult = az rest --method post --url https://management.azure.com/subscriptions/$($Subscription_ID)/resourceGroups/$($Resource_Group)/providers/Microsoft.OperationalInsights/workspaces/$($Workspace)/providers/Microsoft.SecurityInsights/threatIntelligence/main/queryIndicators?api-version=$($API_VERSION) --body "{ 'pageSize': 1000, 'minConfidence': 25, 'maxConfidence': 100, 'minValidUntil': '2020-04-05T17:44:00.114052Z', 'maxValidUntil': '2050-04-25T17:44:00.114052Z', 'sources': [ 'YOUR_SOURCES_NAMES' ], 'sortBy': [ { 'itemKey': 'lastUpdatedTimeUtc', 'sortOrder': 'descending' } ] }" | ConvertFrom-Json

        # Save the indicator names in a text file

        foreach ($item in $jsonResult.value) {
            $item.name | Out-File -FilePath ".\indicator_names.txt" -Append
        }
    }
    catch {
        Write-Error "Error querying and saving indicators in iteration $($i): $($_.Exception.Message)"
        continue # Move to the next iteration if an error occurs
    }

    #Delete Indicators
    try {
        $filepath = ".\indicator_names.txt"

        $indicatorNames = Get-Content -Path $filePath

        foreach ($name in $indicatorNames) {
            $url = "https://management.azure.com/subscriptions/$($Subscription_ID)/resourceGroups/$($Resource_Group)/providers/Microsoft.OperationalInsights/workspaces/$($Workspace)/providers/Microsoft.SecurityInsights/threatIntelligence/main/indicators/$($name)?api-version=$($API_VERSION)"
            Write-Host "Deleting indicator with name: $($name)"
            az rest --method delete --url $url
            $exitCode = $LASTEXITCODE

            if ($exitCode -ne 0) {
                Write-Error "Failed to delete indicator $($name). Exit code: $($exitCode)"
                # Optionally, you can stop the script if an error occurs:
                # break
            }
            else {
                Write-Host "Successfully deleted indicator $($name)."
            }
            Start-Sleep -Seconds 2 # Add a delay after each delete operation
        }

        Write-Host "Finished deleting indicators in iteration $($i)."
        Remove-Item -Path $filePath
        Write-Host " $($filepath) deleted."
    }
    catch {
        Write-Error "Error deleting indicators in iteration $($i): $($_.Exception.Message)"
    }

    Write-Host "Completed iteration: $i"
    Start-Sleep -Seconds 10  # Add a delay between iterations
}

Write-Host "Script completed $($NumberOfIterations) iterations (or terminated prematurely due to errors)."
