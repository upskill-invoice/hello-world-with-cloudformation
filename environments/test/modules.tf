module "api-gateway" {
  source = "../../modules/api-gateway"
  function_name = module.lambda.function_name
  invoke_arn = module.lambda.invoke_arn
}

module "lambda" {
  source = "../../modules/lambda"
}
