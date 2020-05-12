module "api-gateway" {
  source = "../../modules/api-gateway"
  function_name = module.lambda.function_name
  invoke_arn = module.lambda.invoke_arn
}

module "lambda" {
  source = "../../modules/lambda"
}

module "cloudwatch" {
  source = "../../modules/cloudwatch"
  lambda_arn = module.lambda.lambda_arn
  lambda_name = module.lambda.function_name
}