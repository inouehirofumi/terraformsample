provider "aws" {
  region 						= 	"us-east-1"
  s3_force_path_style 			= 	true
  secret_key 					= 	"Dummy"
  access_key 					= 	"Dummy"
  skip_credentials_validation 	= 	true
  skip_metadata_api_check 		= 	true
  skip_requesting_account_id 	= 	true
  max_retries 					= 	1

  endpoints {
	apigateway 	= 	"http://192.168.33.33:4567"
	iam 		= 	"http://192.168.33.33:4593"
    s3 			= 	"http://192.168.33.33:4572"
    dynamodb 	= 	"http://192.168.33.33:4569"
    lambda 		= 	"http://192.168.33.33:4574"
  }
}

data "archive_file" "sample_function" {
  type 			= 	"zip"
  source_dir 	= 	"sample_function"
  output_path 	= 	"upload/sample_function.zip"
}

resource "aws_iam_role" "lambda_sample_function" {
  name = "lambda_sample_function"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_lambda_function" "sample_function" {
  filename 			= 	data.archive_file.sample_function.output_path
  function_name 	= 	"sample_function"
  role 				= 	aws_iam_role.lambda_sample_function.arn
  handler 			= 	"handler.hello"
  source_code_hash 	= 	data.archive_file.sample_function.output_base64sha256
  runtime 			= 	"python3.6"
}

resource "aws_lambda_permission" "apigw" {
  statement_id 	= 	"AllowAPIGatewayInvoke"
  action 		= 	"lambda:InvokeFunction"
  function_name 	= 	aws_lambda_function.sample_function.function_name
  principal 	= 	"apigateway.amazonaws.com"

  source_arn 	= 	aws_api_gateway_rest_api.example.execution_arn
}
