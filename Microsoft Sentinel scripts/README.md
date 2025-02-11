## Bulk Delete Threat indicators

### Context

We ingested a few millions of Threat indicators in our Azure workspaces from various sources. then, later decided to remove indicators from one specific source. However, this source alone had more than 2,5M indicators.
Deleting these data would take years if we had to use Microsoft Sentinel GUI because it allos to delete only 100 indicators per page.
Technically, there is no easy way to remove these indicators. So, we decided to automate its deletion using the [Threat Intelligence Indicator API](https://learn.microsoft.com/en-us/rest/api/securityinsights/threat-intelligence-indicator?view=rest-securityinsights-2024-09-01).

The script works as follows:
1. Uses the Azure CLI (az rest) to send a POST request to the [Query Indicators](https://learn.microsoft.com/en-us/rest/api/securityinsights/threat-intelligence-indicator/query-indicators?view=rest-securityinsights-2024-09-01&tabs=HTTP) endpoint to retrieve threat intelligence indicators. The request body includes parameters to filter the indicators based on criteria such as pageSize, minConfidence, maxConfidence, minValidUntil, maxValidUntil, and sources. It also sorts the results by lastUpdatedTimeUtc in descending order.
2. Iterates through the value array in the JSON response from the API. For each indicator, extracts the name property and appends it to a file named `indicators_names.txt`.
3. Deletes indicators based on names in the file. It uses `az rest --method delete` to send a DELETE request to the [Delete](https://learn.microsoft.com/en-us/rest/api/securityinsights/threat-intelligence-indicator/delete?view=rest-securityinsights-2024-09-01&tabs=HTTP) API to delete the indicator.
