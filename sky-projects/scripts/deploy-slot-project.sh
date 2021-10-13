deployment_dir=$HOME/source-repo/sky-projects
export project_id=sky-slot-$RANDOM
export sky_team_name=sky-test
export billing_account_id=011552-7DA53C-81003E
export projects_namespace=projects
export project_namespace=$project_id
export projects_namespace=projects
export management_project_id=rick-multi-tenancy
export management_namespace=config-control

export data_project_id=XXXXXXX # replace data project reference
export data_job_group="data-job@rickruguichen.altostrat.com"
export data_reservation_group="data-reservation@rickruguichen.altostrat.com"
export bq_dataset_name=bqsampledataset
export bq_datatable_name=bqsampledatatable

cd $deployment_dir
kpt pkg get https://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@github.com/rick-c-goog/sky_deployment.git/sky-projects/base@main ./$project_id
cd $project_id
envsubst < "./setters.yaml.template" >  "setters.yaml"


kpt pkg get https://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@github.com/rick-c-goog/sky_deployment.git/sky-projects/job@main ./job
cd job

envsubst < "./setters.yaml.template" >  "setters.yaml"
cd $deployment_dir
git add .
git commit -m "create slot project project id: $project_id"
git push





