deployment_dir=$HOME/source-repo/sky-projects
export project_id=sky-slot-admin-$RANDOM
export sky_team_name=sky-test
export billing_account_id=011552-7DA53C-81003E
export projects_namespace=projects
export project_namespace=$project_id
export projects_namespace=projects
export management_project_id=rick-multi-tenancy
export management_namespace=config-control
export system_admin_group="gcp-org-admins@rickruguichen.altostrat.com"
githubtoken=xxxxxx

cd $deployment_dir
kpt pkg get https://$githubtoken@github.com/rick-c-goog/sky_deployment.git/sky-projects/base@main ./$project_id
cd $project_id
envsubst < "./setters.yaml.template" >  "setters.yaml"
cd $deployment_dir
git add .
git commit -m "create project project id: $project_id"
git push


sleep 180
cd $deployment_dir/$project_id
kpt pkg get https://$githubtoken@github.com/rick-c-goog/sky_deployment.git/sky-projects/slotadmin@main ./slotadmin
cd slotadmin
gcloud config set project $management_project_id
export org_id=396496977015
export data_reservation_group="data-reservation@rickruguichen.altostrat.com"
export project_number=$(gcloud projects describe ${project_id} --format='get(projectNumber)')
envsubst < "./setters.yaml.template" >  "setters.yaml"

cd $deployment_dir
git add .
git commit -m "create slot project project id: $project_id"
git push





