module "polly_ddb" {   
    source = "../../modules/ddb"
    name = "${var.polly_ddb_table_name}" 
    hash_key = "id"
    description = "DDB to story Polly text posts"
}

module "polly-website-bucket" { 
    source = "../../modules/s3_bucket_public"
    name = "${var.polly_bucket_website_name}" 
    description = "Bucket contines polly website files"
}

module "polly-audiostorage-bucket" {
    source = "../../modules/s3_bucket_private"
    name = "${var.polly_bucket_audiostorage_name}" 
    description = "Bucket contines audio files"
}

module "polly-sns-topic" {
    source = "../../modules/sns_topic"
    topic_name = "${var.polly_sns_topic_name}" 
    description = "SNS topic to alert whenever new post arrived"
}

module "polly-lambda-role" { 
    source = "../../modules/iam-roles-with-policies"
    lambda_role_name = "${var.polly_lambda_role_name }"
    lambda_role_description = "Role to allow Polly lambda functions access to resources"
    polly_lambda_access_policy_name = "polly-lambda-access-policy"
    polly_lambda_access_policy_description = "Policy to allow Polly lambda functions access to resources"
    sns_topic_new_posts_arn = "${module.polly-sns-topic.sns_topic_arn}"
    audiostorage_bucket_name = "${module.polly-audiostorage-bucket.bucket_name}"
    polly_ddb_table_name = "${module.polly_ddb.ddb_table_name}"
}
