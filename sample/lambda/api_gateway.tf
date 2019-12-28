resource "aws_api_gateway_rest_api" "example" {
  name 			= 	"ServerlessExample"
  description 	= 	"Terraform Serverless Application Example"
}

resource "aws_api_gateway_resource" "test_resource" {
  rest_api_id 	= 	aws_api_gateway_rest_api.example.id
  parent_id 	= 	aws_api_gateway_rest_api.example.root_resource_id
  path_part 	= 	"hello"
}

resource "aws_api_gateway_method" "test_resource" {
  rest_api_id 	= 	aws_api_gateway_rest_api.example.id
  resource_id 	= 	aws_api_gateway_resource.test_resource.id
  http_method 	= 	"GET"
  authorization =	"NONE"
}

/*
resource "aws_api_gateway_method_response" "test_resource" {
  rest_api_id 	= 	aws_api_gateway_rest_api.example.id
  resource_id 	= 	aws_api_gateway_rest_api.example.root_resource_id
  http_method 	= 	aws_api_gateway_method.test_resource.http_method
  status_code 	= 	"200"
}
*/

resource "aws_api_gateway_integration" "test_resource" {
  rest_api_id 	= 	aws_api_gateway_rest_api.example.id
  resource_id 	= 	aws_api_gateway_method.test_resource.resource_id
  http_method 	= 	aws_api_gateway_method.test_resource.http_method

  integration_http_method 	= 	"POST"
  type 						= 	"AWS_PROXY"
  uri 						= 	aws_lambda_function.sample_function.invoke_arn
  passthrough_behavior 		=	"WHEN_NO_MATCH"
}

/*
resource "aws_api_gateway_integration_response" "test_resource" {
  rest_api_id 	= 	aws_api_gateway_rest_api.example.id
  resource_id 	= 	aws_api_gateway_rest_api.example.root_resource_id
  http_method 	= 	aws_api_gateway_method.test_resource.http_method
  status_code 	= 	aws_api_gateway_method_response.test_resource.status_code
  selection_pattern 	= 	"200"
}
*/

resource "aws_api_gateway_deployment" "example" {
  depends_on 	= 	[
	aws_api_gateway_method.test_resource,
  ]

  rest_api_id 	= 	aws_api_gateway_rest_api.example.id
  stage_name 	= 	"test"
}

output "base_url" {
  value 	= 	aws_api_gateway_deployment.example.invoke_url
}
