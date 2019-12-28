provider "aws" {
  region                      = "us-east-1"
  s3_force_path_style         = true
  secret_key                  = "Dummy"
  access_key                  = "Dummy"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true
  max_retries = 1

  endpoints {
    s3             = "http://192.168.33.33:4572"
    dynamodb = "http://192.168.33.33:4569"
	lambda = "http://192.168.33.33:4574"
  }
}

resource "aws_s3_bucket" "website_hosting" {
  bucket 	= 	"hosting-test"
  acl 		= 	"public-read"
  policy 	=	file("policy.json")

  /*
  website {
    index_document 	= 	"index.html"
    error_document 	= 	"error.html"
  }
  */
}
