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

output "api_gateway_stage_id" {
  description = "Identifier of the Stage"
  value       = module.stage.api_gateway_stage_id
}

output "api_gateway_stage_arn" {
  description = "ARN of the Stage"
  value       = module.stage.api_gateway_stage_arn
}

output "api_gateway_stage_name" {
  description = "Name of the Stage"
  value       = var.name
}

output "execution_arn" {
  description = "ARN prefix to be used in an `aws_lambda_permission`'s `source_arn` attribute or in an `aws_iam_policy` to authorize access to the @connections API. See https://docs.aws.amazon.com/apigateway/latest/developerguide/apigateway-websocket-control-access-iam.html for details."
  value       = module.stage.execution_arn
}

output "invoke_url" {
  description = "URL to invoke the API pointing to the Stage"
  value       = module.stage.invoke_url
}

output "log_group_created" {
  description = "Whether or not the module created its own Log Group."
  value       = var.log_group_arn == null ? true : false
}

output "log_group_arn" {
  description = "ARN of the Log Group to receive Stage logs."
  value       = var.log_group_arn != null ? var.log_group_arn : aws_cloudwatch_log_group.log_group[0].arn
}
