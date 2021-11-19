# sky-projects

## Description
KPT package to create BigQuery projects.

* 3 types of projects can  be created: data project, job/compute project, slot admin project
* Use base kpt package as start point to create all 3 types of projects, since it contains base level setup shared by all 3 types of projects. 
* There are 3 sample scripts to test each type of project creation
* The project can be created under specified existing namespace

| Proj Type     | Role | Permissions | Group |
| ---        |    ----   | ----   | ----   | 
|BigQuery Admin Project  | Admin   |Create/update/delete slot commitments, create/update/delete reservations, assign reservations, IAM roles mgmt |Cloud enablement team admin  | 
|Data Project  | Data Admin |Create, delete, manage datasets, row-level, column level policies,encrypt/decrypt, key management  | Application team data admins   |
|Data Project  |Data Editor  |Create tables, read/write/update data, change columns, encrypt/decrypt  |Application team data producers  |
|Data Project  | Data Viewer   |Read Dataset, tables, views etc.  |Application team data consumers |
|Compute Project  |Job User |Create, run jobs/queries   |Application team data producers and consumers |

## Packages:
kpt packages:
### base: 
base level project settings, always start with this one, and apply one of data,job,slotadmin package after base
Includes auditlog setttings, enable logging, monitoring service API. logging, monitoring should be set later on
Includes a system admin

Setters:
| Setter | Description |
|    ----   | ----   |
|project-id  |project id |
|deployment-id |deployment-id did |
|did-folder-id |team parent folder id |
|billing-account-id  |billing account id |
|project-namespace  | existing namespace to hold project resources|
|projects-namespace | existing namespace to hold project, projects namespace or parent folder namespace |
|system-admin-group |full email address for system adim group |
  
### data:
Add on package for BigQuery sample dataset, and sample table
Include sample cloud KMS, and encrption with dataset, table level encrption will be inherited from dataset keys
IAM permission for different roles which bind to user groups with different access permissions
See the previous table for IAM details
Setters:
| Setter | Description |
|    ----   | ----   |
|project-id |project ID|
|project-number | Project number from base pakcage execution|
|bq-dataset-name |sample bq dataset name|
|bq-datatable-name |sample bq datatable name can use default|
|data-admin-group |full email address for data admin group |
|data-editor-group | full email address for data editor group |
|data-viewer-group | full email address for data viewer group |
|data-job-group |full email address for data job group |

### job
Add on package for compute/job project, 
Only include one user group to access the project 
Setters:
| Setter | Description |
|    ----   | ----   |
|project-id |project ID|
|project-number | Project number from base pakcage execution|
|data-job-group|full email address for data job group, this group need to be in both data and job projects |
### slotadmin
Add package for data admin project, with commitment purchase, reservation management. 
Setters:
| Setter | Description |
|    ----   | ----   |
|project-id |project ID|
|project-number | Project number from base pakcage execution|
|data-reservation-group |full email address for data admin group |

## Usage:
There are shell scripts under sky-poroject/scripts folder,to create different type of projects: 
1. create-admin-project.sh
2. create-project-set.sh
3. cereate-slotadmin-project.sh

Make to modify the scripts' environment variables to match your environemnt. 
Assumption for the scripts:
1. there is an exisitng directory to hold your source repo, and can kick off the blueprint cloud build job after git code push
2. have GCP sdk, jq, kubectl installed
3. gcloud config set project management_project ( use this project to access the project created)
4. each project have 2 steps, first step to commit and push code to create base project. And it will wait for 3 minutes to get the project number of base project provisioned through the management project, this is necessary to retrieve project number. The second step will get the add-on package on top of the base project and do another code commit push, kick off the cloud build pipeline job. 
5. each step use envsust command to override the setters.yaml.template file
Note: feel free to use other mechanism to update the setters values and run the packages,  










