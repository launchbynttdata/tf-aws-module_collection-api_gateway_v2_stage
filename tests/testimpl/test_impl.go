package testimpl

import (
	"context"
	"strings"
	"testing"

	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/apigatewayv2"
	apitypes "github.com/aws/aws-sdk-go-v2/service/apigatewayv2/types"
	"github.com/aws/aws-sdk-go-v2/service/cloudwatchlogs"
	"github.com/aws/aws-sdk-go/aws/arn"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/launchbynttdata/lcaf-component-terratest/types"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func TestComposableComplete(t *testing.T, ctx types.TestContext) {
	apiGatewayClient := GetAWSApiGatewayV2Client(t)

	t.Run("TestApiGatewayV2Exists", func(t *testing.T) {
		awsApiGatewayId := terraform.Output(t, ctx.TerratestTerraformOptions(), "api_gateway_id")
		awsApiGatewayProtocolType := terraform.Output(t, ctx.TerratestTerraformOptions(), "api_protocol_type")

		apiGateway, err := apiGatewayClient.GetApi(context.TODO(), &apigatewayv2.GetApiInput{
			ApiId: &awsApiGatewayId,
		})
		if err != nil {
			t.Errorf("Failure during GetApi: %v", err)
		}

		assert.Equal(t, *apiGateway.ApiId, awsApiGatewayId, "Expected ID did not match actual ID!")
		assert.Equal(t, apiGateway.ProtocolType, apitypes.ProtocolType(awsApiGatewayProtocolType), "Expected protocol type did not match actual!")
	})

	t.Run("TestApiGatewayV2StageExists", func(t *testing.T) {
		awsApiGatewayId := terraform.Output(t, ctx.TerratestTerraformOptions(), "api_gateway_id")
		awsApiGatewayStageName := terraform.Output(t, ctx.TerratestTerraformOptions(), "api_stage_name")

		apiGatewayStage, err := apiGatewayClient.GetStage(context.TODO(), &apigatewayv2.GetStageInput{
			ApiId:     &awsApiGatewayId,
			StageName: &awsApiGatewayStageName,
		})
		if err != nil {
			t.Errorf("Failure during GetApi: %v", err)
		}

		assert.Equal(t, *apiGatewayStage.StageName, awsApiGatewayStageName, "Expected Stage Name did not match actual Stage Name!")
	})

	t.Run("TestCloudWatchLogGroupWasCreated", func(t *testing.T) {
		cloudwatchClient := GetAWSCloudwatchClient(t)
		logGroupArn := terraform.Output(t, ctx.TerratestTerraformOptions(), "log_group_arn")
		logGroupCreated := terraform.Output(t, ctx.TerratestTerraformOptions(), "log_group_created")

		assert.Equal(t, logGroupCreated, "true", "Log group should have been created!")

		arn, err := arn.Parse(logGroupArn)
		if err != nil {
			t.Errorf("Failure during parsing Log Group ARN: %v", err)
		}

		namePrefix := strings.Replace(arn.Resource, "log-group:", "", 1)

		logGroups, err := cloudwatchClient.DescribeLogGroups(context.TODO(), &cloudwatchlogs.DescribeLogGroupsInput{
			LogGroupNamePrefix: &namePrefix,
		})
		if err != nil {
			t.Errorf("Failure during GetApi: %v", err)
		}

		assert.Equal(t, len(logGroups.LogGroups), 1, "Expected one matching log group!")
	})
}

func GetAWSCloudwatchClient(t *testing.T) *cloudwatchlogs.Client {
	awsCloudwatchClient := cloudwatchlogs.NewFromConfig(GetAWSConfig(t))
	return awsCloudwatchClient
}

func GetAWSApiGatewayV2Client(t *testing.T) *apigatewayv2.Client {
	awsApiGatewayV2Client := apigatewayv2.NewFromConfig(GetAWSConfig(t))
	return awsApiGatewayV2Client
}

func GetAWSConfig(t *testing.T) (cfg aws.Config) {
	cfg, err := config.LoadDefaultConfig(context.TODO())
	require.NoErrorf(t, err, "unable to load SDK config, %v", err)
	return cfg
}
