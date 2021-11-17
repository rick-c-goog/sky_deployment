####set following variables
deployment_dir=$HOME/source-repo/sky-projects
export project_id=sky-data-$RANDOM
export sky_team_name=sky-credit-risk
export did_folder_id=705548959577
export billing_account_id=XXX-XXX-XXX
export project_namespace=sky-credit-risk
export projects_namespace=projects
export data_job_group="data-job@rickruguichen.altostrat.com" 
export system_admin_group="gcp-org-admins@rickruguichen.altostrat.com"
source_repo=https://githubtoken@github.com/rick-c-goog/sky_deployment.git
management_project_id=rick-multi-tenancy
##Run test scripts to create compute job projects
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
kpt pkg get $source_repo/sky-projects/job@main ./job

cd job
gcloud config set project $management_project_id

export project_number=$(gcloud projects describe ${project_id} --format='get(projectNumber)')
envsubst < "./setters.yaml.template" >  "setters.yaml"

cd $deployment_dir
git add .
git commit -m "create slot project project id: $project_id"
git push





