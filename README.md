# tf-aws-module_primitive-api_gateway_v2_stage

[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![License: CC BY-NC-ND 4.0](https://img.shields.io/badge/License-CC_BY--NC--ND_4.0-lightgrey.svg)](https://creativecommons.org/licenses/by-nc-nd/4.0/)

## Overview

Provides an API Gateway Stage resource.

## Pre-Commit hooks

[.pre-commit-config.yaml](.pre-commit-config.yaml) file defines certain `pre-commit` hooks that are relevant to terraform, golang and common linting tasks. There are no custom hooks added.

`commitlint` hook enforces commit message in certain format. The commit contains the following structural elements, to communicate intent to the consumers of your commit messages:

- **fix**: a commit of the type `fix` patches a bug in your codebase (this correlates with PATCH in Semantic Versioning).
- **feat**: a commit of the type `feat` introduces a new feature to the codebase (this correlates with MINOR in Semantic Versioning).
- **BREAKING CHANGE**: a commit that has a footer `BREAKING CHANGE:`, or appends a `!` after the type/scope, introduces a breaking API change (correlating with MAJOR in Semantic Versioning). A BREAKING CHANGE can be part of commits of any type.
footers other than BREAKING CHANGE: <description> may be provided and follow a convention similar to git trailer format.
- **build**: a commit of the type `build` adds changes that affect the build system or external dependencies (example scopes: gulp, broccoli, npm)
- **chore**: a commit of the type `chore` adds changes that don't modify src or test files
- **ci**: a commit of the type `ci` adds changes to our CI configuration files and scripts (example scopes: Travis, Circle, BrowserStack, SauceLabs)
- **docs**: a commit of the type `docs` adds documentation only changes
- **perf**: a commit of the type `perf` adds code change that improves performance
- **refactor**: a commit of the type `refactor` adds code change that neither fixes a bug nor adds a feature
- **revert**: a commit of the type `revert` reverts a previous commit
- **style**: a commit of the type `style` adds code changes that do not affect the meaning of the code (white-space, formatting, missing semi-colons, etc)
- **test**: a commit of the type `test` adds missing tests or correcting existing tests

Base configuration used for this project is [commitlint-config-conventional (based on the Angular convention)](https://github.com/conventional-changelog/commitlint/tree/master/@commitlint/config-conventional#type-enum)

If you are a developer using vscode, [this](https://marketplace.visualstudio.com/items?itemName=joshbolduc.commitlint) plugin may be helpful.

`detect-secrets-hook` prevents new secrets from being introduced into the baseline. TODO: INSERT DOC LINK ABOUT HOOKS

In order for `pre-commit` hooks to work properly

- You need to have the pre-commit package manager installed. [Here](https://pre-commit.com/#install) are the installation instructions.
- `pre-commit` would install all the hooks when commit message is added by default except for `commitlint` hook. `commitlint` hook would need to be installed manually using the command below

```
pre-commit install --hook-type commit-msg
```

## To test the resource group module locally

1. For development/enhancements to this module locally, you'll need to install all of its components. This is controlled by the `configure` target in the project's [`Makefile`](./Makefile). Before you can run `configure`, familiarize yourself with the variables in the `Makefile` and ensure they're pointing to the right places.

```
make configure
```

This adds in several files and directories that are ignored by `git`. They expose many new Make targets.

2. _THIS STEP APPLIES ONLY TO MICROSOFT AZURE. IF YOU ARE USING A DIFFERENT PLATFORM PLEASE SKIP THIS STEP._ The first target you care about is `env`. This is the common interface for setting up environment variables. The values of the environment variables will be used to authenticate with cloud provider from local development workstation.

`make configure` command will bring down `azure_env.sh` file on local workstation. Devloper would need to modify this file, replace the environment variable values with relevant values.

These environment variables are used by `terratest` integration suit.

Service principle used for authentication(value of ARM_CLIENT_ID) should have below privileges on resource group within the subscription.

```
"Microsoft.Resources/subscriptions/resourceGroups/write"
"Microsoft.Resources/subscriptions/resourceGroups/read"
"Microsoft.Resources/subscriptions/resourceGroups/delete"
```

Then run this make target to set the environment variables on developer workstation.

```
make env
```

3. The first target you care about is `check`.

**Pre-requisites**
Before running this target it is important to ensure that, developer has created files mentioned below on local workstation under root directory of git repository that contains code for primitives/segments. Note that these files are `azure` specific. If primitive/segment under development uses any other cloud provider than azure, this section may not be relevant.

- A file named `provider.tf` with contents below

```
provider "azurerm" {
  features {}
}
```

- A file named `terraform.tfvars` which contains key value pair of variables used.

Note that since these files are added in `gitignore` they would not be checked in into primitive/segment's git repo.

After creating these files, for running tests associated with the primitive/segment, run

```
make check
```

If `make check` target is successful, developer is good to commit the code to primitive/segment's git repo.

`make check` target

- runs `terraform commands` to `lint`,`validate` and `plan` terraform code.
- runs `conftests`. `conftests` make sure `policy` checks are successful.
- runs `terratest`. This is integration test suit.
- runs `opa` tests
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0, <= 1.5.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.14 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.6 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.56.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_stage"></a> [stage](#module\_stage) | terraform.registry.launch.nttdata.com/module_primitive/api_gateway_v2_stage/aws | ~> 1.0 |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.log_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_api_id"></a> [api\_id](#input\_api\_id) | ID of the API Gateway to which this stage will attach | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name of the stage. Must be between 1 and 128 characters in length. | `string` | `"$default"` | no |
| <a name="input_description"></a> [description](#input\_description) | Description for the stage. Must be less than or equal to 1024 characters in length. | `string` | `null` | no |
| <a name="input_deployment_id"></a> [deployment\_id](#input\_deployment\_id) | Optional deployment identifier of the stage. Use the aws\_apigatewayv2\_deployment resource to configure a deployment. | `string` | `null` | no |
| <a name="input_auto_deploy"></a> [auto\_deploy](#input\_auto\_deploy) | Whether updates to an API automatically trigger a new deployment. Defaults to `false`. Applicable for HTTP APIs. | `bool` | `false` | no |
| <a name="input_log_group_arn"></a> [log\_group\_arn](#input\_log\_group\_arn) | ARN of the CloudWatch Logs log group to receive access logs. Any trailing :* is trimmed from the ARN. If not supplied (default), the stage will create a log group with a name based on the name of the stage. | `string` | `null` | no |
| <a name="input_log_group_retention_days"></a> [log\_group\_retention\_days](#input\_log\_group\_retention\_days) | Specifies the number of days you want to retain log events in the specified log group. Possible values are: 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1096, 1827, 2192, 2557, 2922, 3288, 3653, and 0. If you select 0, the events in the log group are always retained and never expire. Defaults to 30, has no effect if `log_group_arn` is supplied. | `number` | `30` | no |
| <a name="input_log_group_skip_destroy"></a> [log\_group\_skip\_destroy](#input\_log\_group\_skip\_destroy) | Set to true if you do not wish the log group (and any logs it may contain) to be deleted at destroy time, and instead just remove the log group from the Terraform state. Has no effect if `log_group_arn` is supplied. | `bool` | `false` | no |
| <a name="input_access_log_format"></a> [access\_log\_format](#input\_access\_log\_format) | Single line format of the access logs of data. Refer to log settings for HTTP (https://docs.aws.amazon.com/apigateway/latest/developerguide/http-api-logging-variables.html) or Websocket (https://docs.aws.amazon.com/apigateway/latest/developerguide/websocket-api-logging.html). | `string` | `"{ \"requestId\":\"$context.requestId\", \"ip\": \"$context.identity.sourceIp\", \"requestTime\":\"$context.requestTime\", \"httpMethod\":\"$context.httpMethod\",\"routeKey\":\"$context.routeKey\", \"status\":\"$context.status\",\"protocol\":\"$context.protocol\", \"responseLength\":\"$context.responseLength\" }"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Map of tags to assign to the API. | `map(string)` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_api_gateway_stage_id"></a> [api\_gateway\_stage\_id](#output\_api\_gateway\_stage\_id) | Identifier of the Stage |
| <a name="output_api_gateway_stage_arn"></a> [api\_gateway\_stage\_arn](#output\_api\_gateway\_stage\_arn) | ARN of the Stage |
| <a name="output_api_gateway_stage_name"></a> [api\_gateway\_stage\_name](#output\_api\_gateway\_stage\_name) | Name of the Stage |
| <a name="output_execution_arn"></a> [execution\_arn](#output\_execution\_arn) | ARN prefix to be used in an `aws_lambda_permission`'s `source_arn` attribute or in an `aws_iam_policy` to authorize access to the @connections API. See https://docs.aws.amazon.com/apigateway/latest/developerguide/apigateway-websocket-control-access-iam.html for details. |
| <a name="output_invoke_url"></a> [invoke\_url](#output\_invoke\_url) | URL to invoke the API pointing to the Stage |
| <a name="output_log_group_created"></a> [log\_group\_created](#output\_log\_group\_created) | Whether or not the module created its own Log Group. |
| <a name="output_log_group_arn"></a> [log\_group\_arn](#output\_log\_group\_arn) | ARN of the Log Group to receive Stage logs. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
