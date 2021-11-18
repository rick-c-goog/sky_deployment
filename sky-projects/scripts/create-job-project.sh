####set following variables
export project_id=sky-job-$deployment_id
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





