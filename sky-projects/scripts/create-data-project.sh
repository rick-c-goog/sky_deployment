####set following variables
source set-common-vars.sh
export project_id=sky-data-$deployment_id
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





