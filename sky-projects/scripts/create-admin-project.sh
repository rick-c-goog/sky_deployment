####set environment vairables for setters file
deployment_dir=$HOME/source-repo/sky-projects
export deployment_id=did-$RANDOM
export project_id=sky-data-$deployment_id
export did_folder_id=561366432738
export billing_account_id=XXXX-XXX-XXX
export project_namespace=sky-credit-risk
export projects_namespace=projects
export system_admin_group="gcp-org-admins@rickruguichen.altostrat.com"
export data_reservation_group="data-reservation@rickruguichen.altostrat.com"
source_repo=https://$githubtoken@github.com/rick-c-goog/sky_deployment.git
management_project_id=rick-multi-tenancy # management project id
###test to create data admin project
cd $deployment_dir
kpt pkg get $source_repo/sky-projects/base@main ./$project_id
cd $project_id
envsubst < "./setters.yaml.template" >  "setters.yaml"
cd $deployment_dir
git add .
git commit -m "create project project id: $project_id"
git push

##wait for project number available
sleep 180
cd $deployment_dir/$project_id
kpt pkg get $source_repo/sky-projects/slotadmin@main ./slotadmin
cd slotadmin
gcloud config set project $management_project_id
export project_number=$(gcloud projects describe ${project_id} --format='get(projectNumber)')
envsubst < "./setters.yaml.template" >  "setters.yaml"

cd $deployment_dir
git add .
git commit -m "create slot project project id: $project_id"
git push





