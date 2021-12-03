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
|project-namespace  | existing namespace to hold project resources|
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
|project-namespace | existing namespace to hold project resources|
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
|project-namespace | existing namespace to hold project resources|
|data-job-group|full email address for data job group, this group need to be in both data and job projects |
### slotadmin
Add package for data admin project, with commitment purchase, reservation management. 
Setters:
| Setter | Description |
|    ----   | ----   |
|project-id |project ID|
|project-number | Project number from base pakcage execution|
|project-namespace | existing namespace to hold project resources|
|data-reservation-group |full email address for data admin group |

## Usage:
### How to use packages when projects created from other workflow:
Prerequisistes:
1. Need to provision empty GCP project outside current workflow, usually one project will match to one DID folder and one namespace in KCC cluster
2. Get the following parameters related to the project:
    project-id
    project-number
    project-namespace 
3. Need one repo sync configured for each project namespace, need get gcr deployment-repo url and have access permission to pull and push templates into the repo. 
4. Each type of package will need different type of user groups so that IAM roles will be assigned to them, the group email address needs to set in package setters files
Group requirements: 
| Package | Group |  
|    ----   | ----   |
|base |system-admin-group |
|data | data-admin-group|
|data| data-editor-group|
|data|data-viewer-group |
|data|data-job-group |
|job |data-job-group |
|admin|data-reservation-group |


Sample Steps to apply packages:
1. mkdir bq-packages
2. cd bq-packages
// clone the project-deployment-repo which kcc syncs with resources in namespace
3. gcloud source repos clone project-deployment-repo --project=lob1-kcc-root
cd project-deployment-repo
// download base pacakge
4. kpt pkg get $source_repo/sky-projects/base@main .
5. cd base , change values setters.yaml file
6. kpt fn render
//download one of the following 3 packages( only one package allowed in project):
7.1 kpt pkg get $source_repo/sky-projects/bigquery@main .
7.2 kpt pkg get $source_repo/sky-projects/job@main .
7.3 kpt pkg get $source_repo/sky-projects/slotadmin@main admin
8.1 cd bigquery 
8.2 cd job
8.3 cd admin
9. change values setters.yaml file
10. kpt fn render
11.  submit code changes: 
 git add .
 git commit -m "render package templates"
 git push origion master
12. check kcc cluster, the resources should show up in kcc cluster namespace associated with the project


### How to use packages when projects needs to be created:
Notes:
under base folder, 
project.yaml.create template can be restored to create project
setters.yaml.template.createproject includes setters required to create new gcp project:
   project-id: ${project_id}
   deployment-id: ${deployment_id}
   did-folder-id: ${did_folder_id}
   billing-account-id: ${billing_account_id}
   project-namespace: ${project_namespace}
   projects-namespace: ${projects_namespace}
   system-admin-group: ${system_admin_group}

There are shell scripts under sky-poroject/scripts folder,to create different type of projects: 
1. create-admin-project.sh  create bq admin project, 
2. create-project-set.sh  create bq project set( includes bq data project and compute projects)
3. set-common-vars.sh  shared common variables passing to setters.yaml.templates

Make to modify the set-common-vars.sh environment variables to match your environemnt. 
Assumption for the scripts:
1. there is an exisitng directory to hold your source repo, and can kick off the blueprint cloud build job after git code push
2. have jq, kubectl installed, access to kcc cluster
3. each project have 2 steps, first step to commit and push code to create base project. And it will wait for 3 minutes to get the project number of base project provisioned through the management project, this is necessary to retrieve project number. The second step will get the add-on package on top of the base project and do another code commit push, kick off the cloud build pipeline job. 
5. each step use envsust command to override the setters.yaml.template file
Note: feel free to use other mechanism to update the setters values and run the packages,  










