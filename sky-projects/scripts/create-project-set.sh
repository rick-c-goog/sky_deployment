# Copyright 2021 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

####Purpose: create generic big project sets, one data project and 0-n slot projects

####1. Create base project
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


#check for status for of project, wait till is ready
totalWait=0
status=''
while [ $totalWait -le 180 ]
do
  sleep 10
  totalWait=$(( $totalWait + 10 ))
  status=$(kubectl get  project ${project_id} -n ${projects_namespace} -o json | jq '.status.conditions[0].status')
  if [[ "$status" == ""True"" ]];  then
      echo $status
      break
  fi
done
if [[ -z $status ]];  then
      echo "There is issue to create project, check kcc project status"
      exit 
fi

##2. Add BigQuery pacage to base project
cd $deployment_dir/$project_id
kpt pkg get $source_repo/sky-projects/bigquery@main ./bigquery
cd bigquery
#get project_number from kubernetes
export project_number=$(kubectl get  project ${project_id} -n ${projects_namespace} -o json | jq '.status.number')
envsubst < "./setters.yaml.template" >  "setters.yaml"
cd $deployment_dir/$project_id
git add .
git commit -m "create project project id: $project_id"
git push
sleep 10
####3. Create BigQuery compute projects
countProject=1
while [ $countProject -le 3 ]   #default is 3 slot projects, change to 0 for data storage project without slot project, or any other number
do
   export project_id=sky-job-$deployment_id-$countProject
   ##Run test scripts to create compute job projects
   cd $deployment_dir
   kpt pkg get $source_repo/sky-projects/base@main ./$project_id
   cd $project_id
   envsubst < "./setters.yaml.template" >  "setters.yaml"
   cd $deployment_dir
   git add .
   git commit -m "create project project id: $project_id"
   git push
   
   totalWait=0
   status=''
   while [ $totalWait -le 180 ]
   do
    sleep 10
    totalWait=$(( $totalWait + 10 ))
    status=$(kubectl get  project ${project_id} -n ${projects_namespace} -o json | jq '.status.conditions[0].status')
    if [[ "$status" == ""True"" ]];  then
      echo $status
      break
    fi
   done
   if [[ -z $status ]];  then
      echo "There is issue to create project, check kcc project status"
      exit 
   fi
 
#export project_number=$(gcloud projects describe ${project_id} --format='get(projectNumber)')
   export project_number=$(kubectl get  project ${project_id} -n ${projects_namespace} -o json | jq '.status.number')
 
   
   cd $deployment_dir/$project_id
   kpt pkg get $source_repo/sky-projects/job@main ./job

   cd job
   #gcloud config set project $management_project_id
   
   #export project_number=$(gcloud projects describe ${project_id} --format='get(projectNumber)')
   envsubst < "./setters.yaml.template" >  "setters.yaml"

   cd $deployment_dir
   git add .
   git commit -m "create slot project project id: $project_id"
   git push
   sleep 10
   countProject=$(( $countProject + 1 ))
done






