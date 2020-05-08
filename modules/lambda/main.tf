locals {
    lambda_file = "../../files/handler.zip"
}

resource "aws_lambda_function" "example" {
    function_name = "ServerlessExample-pbugno"
    filename = local.lambda_file
    source_code_hash = "${filebase64sha256(local.lambda_file)}"
    handler = "sample_handler.lambda_handler"
    runtime = "python3.7"
    role = aws_iam_role.lambda_exec.arn
}

# IAM role which dictates what other AWS services the Lambda function
# may access.
resource "aws_iam_role" "lambda_exec" {
   name = "serverless_example_lambda"

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
