# ServiceCloud Manual PSR Creation for Omni Channel Routing

Create PSR's manually via Apex for a work item(Cases, Leads etc) which is assigned to a non omni routing queue/a specific user. Manage the PSR Lifecycle, Create Skills and route work items via Omni Channel using Skills Based Routing.

Standard Omni Channel functionality in Service Cloud, doesn't allow you to have control on PSR's and route them as per your business use case. In the standard routing lifecycle, followed by Omni Channel you can only either use Skills or Queue based routing. And if you have any customizations where you try to perform an update/manipulate the PSR, it can result in a race condition in Salesforce's Real Time backend server.

The real time server is responsible for routing workitems. Sometimes, due to the race condition workitems might get incorrectly routed via Omni Channel. 
Specially if you are using Skills based routing.

In order to avoid the race condition, it is best that you manage the PSR lifecycle completely on your end. This will also allow you to modify the PSRs and use Skills/add additional skills to route. 

This particular class handles and address the race condition issue, by completely managing the PSR lifecycle manually and routes the workitem(Cases in this scenario) via Skills based routing. 

The class can be invoked on an after insert context, from Case Trigger/any SObject Trigger(Workitems which you are trying to route).
