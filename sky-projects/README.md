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

## Package:
Include kpt packages:
###
base




