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
###test to create data admin project
####set environment vairables for setters file
source set-common-vars.sh
export project_id=sky-admin-$deployment_id

cd $deployment_dir
kpt pkg get $source_repo/sky-projects/base@main ./$project_id
cd $project_id
envsubst < "./setters.yaml.template" >  "setters.yaml"
cd $deployment_dir
git add .
git commit -m "create project project id: $project_id"
git push

##wait for project number available
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
#get project_number from kubernetes
export project_number=$(kubectl get  project ${project_id} -n ${projects_namespace} -o json | jq '.status.number')
cd $deployment_dir/$project_id
kpt pkg get $source_repo/sky-projects/slotadmin@main ./slotadmin
cd slotadmin
envsubst < "./setters.yaml.template" >  "setters.yaml"

cd $deployment_dir
git add .
git commit -m "create slot project project id: $project_id"
git push





