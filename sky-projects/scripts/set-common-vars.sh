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

####Purpose: common parameters used by kcc templates

deployment_dir=$HOME/source-repo/sky-projects
export deployment_id=did-$RANDOM
export did_folder_id=561366432738
export billing_account_id=XXXX-XXX-XXX
export project_namespace=sky-credit-risk
export projects_namespace=projects
export data_admin_group="data-admin@rickruguichen.altostrat.com"
export data_editor_group="data-editor@rickruguichen.altostrat.com"
export data_viewer_group="data-viewer@rickruguichen.altostrat.com"
export data_job_group="data-job@rickruguichen.altostrat.com"
export data_reservation_group="data-reservation@rickruguichen.altostrat.com"
export data_entitlement_group="data-entitlement@rickruguichen.altostrat.com"
export data_location=us
export system_admin_group="gcp-org-admins@rickruguichen.altostrat.com"
source_repo=https://githubtoken@github.com/rick-c-goog/sky_deployment.git