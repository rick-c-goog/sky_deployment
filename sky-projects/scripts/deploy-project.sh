deployment_dir=$HOME/source-repo/sky-projects
project_id=sky-data-$RANDOM
cd $deployment_dir
kpt pkg get https://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@github.com/rick-c-goog/sky_deployment/sky-projects/base@main ./$project_id
kpt cfg set $project-id/ project-id $project-id
kpt cfg set $project-id/ sky-team-name sky-test
kpt cfg set $project-id/ billing-account-id 011552-7DA53C-81003E
kpt cfg set $project-id/ projects-namespace projects
kpt cfg set $project-id/ project-namespace $project-id
kpt cfg set $project-id/ management-project-id rick-multi-tenancy
kpt cfg set $project-id/ management-namespace config-control 
cd $project-id
kpt pkg get https://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@github.com/rick-c-goog/sky_deployment/sky-projects/bigquery@main ./bigquery
kpt cfg set bigquery/ data-admin-group "data-admin@rickruguichen.altostrat.com"
kpt cfg set bigquery/ data-editor-group "data-editor@rickruguichen.altostrat.com"
kpt cfg set bigquery/ data-viewer-group "data-viewer@rickruguichen.altostrat.com"
kpt cfg set bigquery/ data-job-group "data-job@rickruguichen.altostrat.com"

cd $deployment_dir
git add .
git commit -m "project id: $project-id"
git push

