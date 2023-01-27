module "polly-lambda-newposts" { 
    source = "../../modules/lambda-function"
    function_name = "${var.polly_lambda_new_posts_name}"
    role = "${module.polly-lambda-role.role_arn}"
    runtime = "python3.7"
    handler = "newposts.lambda_handler"
    timeout = "5"
    lambda_script_name = "newposts"
    lambda_sns_topic_arn = "${module.polly-sns-topic.sns_topic_arn}"
    lambda_audiostorage_bucket_name = "${module.polly-audiostorage-bucket.bucket_name}"
    lambda_ddb_table_name = "${module.polly_ddb.ddb_table_name}"
}

module "polly-lambda-convert-posts-to-audio" { 
    source = "../../modules/lambda-function"
    function_name = "${var.polly_lambda_convert_to_audio_name}"
    role = "${module.polly-lambda-role.role_arn}"
    runtime = "python3.7"
    handler = "text2audio.lambda_handler"
    timeout = "60"
    lambda_script_name = "text2audio"
    lambda_sns_topic_arn = "${module.polly-sns-topic.sns_topic_arn}"
    lambda_audiostorage_bucket_name = "${module.polly-audiostorage-bucket.bucket_name}"
    lambda_ddb_table_name = "${module.polly_ddb.ddb_table_name}"
}

module "polly-lambda-getpostsinfo" { 
    source = "../../modules/lambda-function"
    function_name = "${var.polly_lambda_get_posts_info_name}"
    role = "${module.polly-lambda-role.role_arn}"
    runtime = "python3.7"
    handler = "getpostsinfo.lambda_handler"
    timeout = "20"
    lambda_script_name = "getpostsinfo"
    lambda_sns_topic_arn = "${module.polly-sns-topic.sns_topic_arn}"
    lambda_audiostorage_bucket_name = "${module.polly-audiostorage-bucket.bucket_name}"
    lambda_ddb_table_name = "${module.polly_ddb.ddb_table_name}"
}

resource "aws_sns_topic_subscription" "text2audio_convert_subscription" {
  topic_arn = "${module.polly-sns-topic.sns_topic_arn}"
  protocol  = "lambda"
  endpoint  = "${module.polly-lambda-convert-posts-to-audio.lambda_arn}"
}

resource "aws_lambda_permission" "polly_lambda_text2audio_sns_permissions" {
    statement_id = "AllowExecutionFromSNS"
    action = "lambda:InvokeFunction"
    function_name = "${module.polly-lambda-convert-posts-to-audio.lambda_arn}"
    principal = "sns.amazonaws.com"
    source_arn = "${module.polly-sns-topic.sns_topic_arn}"
}
