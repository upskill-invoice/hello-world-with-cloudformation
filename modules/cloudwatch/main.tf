resource "aws_cloudwatch_log_group" "example_log_group" {
  name              = "/aws/lambda/${var.lambda_name}"
  retention_in_days = 14
}

resource "aws_cloudwatch_dashboard" "lambda_dashboard" {
    dashboard_name = "example-lambda"

    dashboard_body = <<EOF
    {
        "widgets": [
            {
                "type": "metric",
                "width": 12,
                "properties": {
                    "title": "Lambda Invocations",
                    "region": "us-east-2",
                    "stat": "Sum",
                    "metrics": [
                        [
                            "AWS/Lambda",
                            "Invocations",
                            "FunctionName",
                            "${var.lambda_name}"
                        ]
                    ]
                }
            },
            {
                "type": "metric",
                "width": 12,
                "properties": {
                    "title": "Errors",
                    "region": "us-east-2",
                    "stat": "Sum",
                    "metrics": [
                        [
                            "AWS/Lambda",
                            "Errors",
                            "FunctionName",
                            "${var.lambda_name}"
                        ]
                    ]
                }
            },
            {
                "type": "metric",
                "width": 12,
                "properties": {
                    "title": "Execution time",
                    "region": "us-east-2",
                    "metrics": [
                        [
                            "AWS/Lambda",
                            "Duration",
                            "FunctionName",
                            "${var.lambda_name}",
                            {
                                "id": "m1",
                                "stat": "Minimum"
                            }
                        ],
                        [
                            "...",
                            {
                                "id": "m2",
                                "stat": "Maximum"
                            }
                        ],
                        [
                            "...",
                            {
                                "id": "m3",
                                "stat": "Average"
                            }
                        ]
                    ]
                }
            },
            {
                "type": "log",
                "width": 24,
                "height": 6,
                "properties": {
                    "region": "us-east-2",
                    "title": "Error & Warning Logs",
                    "query": "SOURCE '${aws_cloudwatch_log_group.example_log_group.name}' | fields @timestamp, @message | sort @timestamp desc | filter @message like /(?i)(Exception|error|fail|warning)/ | limit 20"
                }
            }
        ]
    }
    EOF
}

resource "aws_cloudwatch_event_rule" "every_5_mins" {
    name = "every-5-mins"
    schedule_expression = "rate(5 minutes)"
}

resource "aws_cloudwatch_event_target" "exemple_lambda_every_5_minutes" {
  rule = aws_cloudwatch_event_rule.every_5_mins.name
  arn = var.lambda_arn

  input = "{}"
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_example_lambda" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.every_5_mins.arn
}