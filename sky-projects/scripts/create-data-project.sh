####set following variables
deployment_dir=$HOME/source-repo/sky-projects
export project_id=sky-data-$RANDOM
export sky_team_name=sky-credit-risk
export sky_team_folder_id=342025906281
export billing_account_id=XXXX-XXX-XXX
export project_namespace=sky-credit-risk
export projects_namespace=projects
export data_admin_group="data-admin@rickruguichen.altostrat.com"
export data_editor_group="data-editor@rickruguichen.altostrat.com"
export data_viewer_group="data-viewer@rickruguichen.altostrat.com"
export data_job_group="data-job@rickruguichen.altostrat.com"
export data_location=us
export system_admin_group="gcp-org-admins@rickruguichen.altostrat.com"
source_repo=https://githubtoken@github.com/rick-c-goog/sky_deployment.git
management_project_id=rick-multi-tenancy
#run test data project creation
cd $deployment_dir
kpt pkg get $source_repo/sky-projects/base@main ./$project_id
cd $project_id
envsubst < "./setters.yaml.template" >  "setters.yaml"
cd $deployment_dir
git add .
git commit -m "create project project id: $project_id"
git push
#some stuff need project number, maybe not be available during provisioning time
sleep 180

cd $deployment_dir/$project_id
kpt pkg get $source_repo/sky-projects/bigquery@main ./bigquery
cd bigquery
gcloud config set project $management_project_id
export project_number=$(gcloud projects describe ${project_id} --format='get(projectNumber)')

envsubst < "./setters.yaml.template" >  "setters.yaml"
cd $deployment_dir/$project_id
git add .
git commit -m "create project project id: $project_id"
git push





