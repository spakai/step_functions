resource "aws_sfn_state_machine" "example_state_machine" {
  name     = "example_state_machine"
  role_arn = aws_iam_role.step_functions_role.arn

  definition = jsonencode({
    Comment = "A simple AWS Step Functions state machine that waits for 1 second before invoking a Lambda function"
    StartAt = "Wait1Second"
    States = {
      Wait1Second = {
        Type     = "Wait"
        Seconds  = 1
        InputPath = "$"
        Next     = "InvokeLambda"
      }
      InvokeLambda = {
        Type     = "Task"
        Resource = aws_lambda_function.task_processor.arn
        Parameters = {
          "taskId.$" = "States.Format('Task ID: {}', $.taskId)"
        }
        End      = true
      }
    }
  })
}

resource "aws_lambda_function" "task_processor" {
  filename         = "./lambda_package.zip"
  function_name    = "process_overdue_tasks"
  role             = aws_iam_role.lambda_exec_role.arn
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.9"
  source_code_hash = filebase64sha256("lambda_package.zip")
}

resource "aws_iam_role" "lambda_exec_role" {
  name = "example_lambda_exec_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }

              Action = "sts:AssumeRole"
            }
          ]
        })
      }

resource "aws_iam_role" "step_functions_role" {
  name = "example_step_functions_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = {
          Service = "states.amazonaws.com"
        }       
        Action = "sts:AssumeRole"
      }
    ]
  })  
}


resource "aws_iam_policy" "lambda_exec_policy" {
  name   = "lambda_execution_policy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Effect   = "Allow",
        Resource = "arn:aws:logs:*:*:*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_exec_policy_attachment" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = aws_iam_policy.lambda_exec_policy.arn
}


resource "aws_iam_policy" "step_functions_policy" {
  name   = "step_functions_policy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "lambda:InvokeFunction",
        Effect = "Allow",
        Resource = aws_lambda_function.task_processor.arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "step_functions_policy_attachment" {
  role       = aws_iam_role.step_functions_role.name
  policy_arn = aws_iam_policy.step_functions_policy.arn
}