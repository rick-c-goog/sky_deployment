deployment_dir=$HOME/source-repo/sky-projects
export project_id=sky-data-$RANDOM
export sky_team_name=sky-test
export billing_account_id=011552-7DA53C-81003E
export projects_namespace=projects
export project_namespace=$project_id
export management_project_id=rick-multi-tenancy
export management_namespace=config-control
cd $deployment_dir
kpt pkg get https://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@github.com/rick-c-goog/sky_deployment.git/sky-projects/base@main ./$project_id
cd $project_id
envsubst < "./setters.yaml.template" >  "setters.yaml"
kpt pkg get https://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@github.com/rick-c-goog/sky_deployment.git/sky-projects/bigquery@main ./bigquery
cd bigquery
export data_admin_group="data-admin@rickruguichen.altostrat.com"
export data_editor_group="data-editor@rickruguichen.altostrat.com"
export data_viewer_group="data-viewer@rickruguichen.altostrat.com"
export data_job_group="data-job@rickruguichen.altostrat.com"
export bq_dataset_name=bqsampledataset
export bq_datatable_name=bqsampledatatable
envsubst < "./setters.yaml.template" >  "setters.yaml"
cd $deployment_dir
git add .
git commit -m "create project project id: $project_id"
git push



