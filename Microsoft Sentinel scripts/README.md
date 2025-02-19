## Automate deletion of Threat indicators in Microsoft Sentinel

### Context

We ingested a few million threat indicators into our Azure workspaces from various sources. Later, we decided to remove indicators from one specific source. However, this source alone had more than 2.5 million indicators.
Deleting these data would take years if we had to use the Microsoft Sentinel GUI because it only allows deleting 100 indicators per page.
Technically, there is no easy way to remove these indicators. So, we decided to automate their deletion using the [Threat Intelligence Indicator API](https://learn.microsoft.com/en-us/rest/api/securityinsights/threat-intelligence-indicator?view=rest-securityinsights-2024-09-01).

The script works as follows:
1. Uses the Azure CLI (az rest) to send a POST request to the [Query Indicators](https://learn.microsoft.com/en-us/rest/api/securityinsights/threat-intelligence-indicator/query-indicators?view=rest-securityinsights-2024-09-01&tabs=HTTP) endpoint to retrieve threat intelligence indicators. The request body includes parameters to filter the indicators based on criteria such as pageSize, minConfidence, maxConfidence, minValidUntil, maxValidUntil, and sources.
2. Iterates through the `value` array in the JSON response from the API. For each indicator, extracts the `name` property and appends it to a file named `indicators_names.txt`.
3. Deletes indicators based on names in the file. It uses `az rest --method delete` to send a DELETE request to the [Delete](https://learn.microsoft.com/en-us/rest/api/securityinsights/threat-intelligence-indicator/delete?view=rest-securityinsights-2024-09-01&tabs=HTTP) endpoint to delete the indicator.
4. Querying more than 3500 indicators at once often returned a timeout error, so I decided to proceed by iterating deletion of 3000 indicators(1000 is recommended). I've added a `$NumberOfIterations` variable at the beginning of the script and set its initial value to 30. You can change this value to control the number of loop iterations.


### Usage

``` powershell
> az login
> az account set --subscription Your_Subscription_ID
>.\delete_threat_indicators.ps1
```
### Expected results

``` console
Starting iteration: 1
Deleting indicator with name: cde52f28-ec68-2272-4f7e-70422532531a
Successfully deleted indicator cde52f28-ec68-2272-4f7e-70422532531a.
Deleting indicator with name: 5dd7f72e-878b-624b-6278-afa7327a7d1e
Successfully deleted indicator 5dd7f72e-878b-624b-6278-afa7327a7d1e.

```
