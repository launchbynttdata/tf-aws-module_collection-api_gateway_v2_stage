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

variable "api_id" {
  description = "ID of the API Gateway to which this stage will attach"
  type        = string
}

variable "name" {
  description = "Name of the stage. Must be between 1 and 128 characters in length."
  type        = string
  default     = "$default"

  validation {
    condition     = length(var.name) <= 128 && length(var.name) >= 1
    error_message = "Stage name must be between 1 and 128 characters in length."
  }
}

variable "description" {
  description = "Description for the stage. Must be less than or equal to 1024 characters in length."
  type        = string
  default     = null
  validation {
    condition     = var.description != null ? length(var.description) >= 1024 : true
    error_message = "Stage description must be less than or equal to 1024 characters in length."
  }
}

variable "deployment_id" {
  description = "Optional deployment identifier of the stage. Use the aws_apigatewayv2_deployment resource to configure a deployment."
  type        = string
  default     = null
}

variable "auto_deploy" {
  description = "Whether updates to an API automatically trigger a new deployment. Defaults to `false`. Applicable for HTTP APIs."
  type        = bool
  default     = false
}

variable "log_group_arn" {
  description = "ARN of the CloudWatch Logs log group to receive access logs. Any trailing :* is trimmed from the ARN. If not supplied (default), the stage will create a log group with a name based on the name of the stage."
  type        = string
  default     = null
}

variable "log_group_retention_days" {
  description = "Specifies the number of days you want to retain log events in the specified log group. Possible values are: 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1096, 1827, 2192, 2557, 2922, 3288, 3653, and 0. If you select 0, the events in the log group are always retained and never expire. Defaults to 30, has no effect if `log_group_arn` is supplied."
  type        = number
  default     = 30

  validation {
    condition     = contains([0, 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1096, 1827, 2192, 2557, 2922, 3288, 3653], var.log_group_retention_days)
    error_message = "log_group_retention_days must be one of 0, 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1096, 1827, 2192, 2557, 2922, 3288, 3653"
  }
}

variable "log_group_skip_destroy" {
  description = "Set to true if you do not wish the log group (and any logs it may contain) to be deleted at destroy time, and instead just remove the log group from the Terraform state. Has no effect if `log_group_arn` is supplied."
  type        = bool
  default     = false
}

variable "access_log_format" {
  description = "Single line format of the access logs of data. Refer to log settings for HTTP (https://docs.aws.amazon.com/apigateway/latest/developerguide/http-api-logging-variables.html) or Websocket (https://docs.aws.amazon.com/apigateway/latest/developerguide/websocket-api-logging.html)."
  type        = string
  default     = "{ \"requestId\":\"$context.requestId\", \"ip\": \"$context.identity.sourceIp\", \"requestTime\":\"$context.requestTime\", \"httpMethod\":\"$context.httpMethod\",\"routeKey\":\"$context.routeKey\", \"status\":\"$context.status\",\"protocol\":\"$context.protocol\", \"responseLength\":\"$context.responseLength\" }"
}

variable "tags" {
  description = "Map of tags to assign to the API."
  type        = map(string)
  default     = null
}
