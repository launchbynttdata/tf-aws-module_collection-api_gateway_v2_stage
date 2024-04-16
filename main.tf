// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

module "stage" {
  source  = "d2lqlh14iel5k2.cloudfront.net/module_primitive/api_gateway_v2_stage/aws"
  version = "~> 1.0"

  api_id      = var.api_id
  name        = var.name
  description = var.description

  deployment_id = var.deployment_id
  auto_deploy   = var.auto_deploy

  log_group_arn     = var.log_group_arn != null ? var.log_group_arn : aws_cloudwatch_log_group.log_group[0].arn
  access_log_format = var.access_log_format

  tags = var.tags
}

resource "aws_cloudwatch_log_group" "log_group" {
  count = var.log_group_arn == null ? 1 : 0

  name              = "/api_gateway_v2/${var.api_id}/stage/${replace(var.name, "$", "")}"
  retention_in_days = var.log_group_retention_days
  skip_destroy      = var.log_group_skip_destroy
}
