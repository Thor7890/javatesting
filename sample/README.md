###To deploy the java applications there are so many ways to be represented, below are the process as we follow the steps into it
 
 local ways
-------------

1. create docker file
2. Run the below in local once docker login is done commands
- docker build -t supermarket-checkout -f Dockerfile .
- docker tag supermarket-checkout:latest 
- docker run -p 8080:8080 supermarket-checkout
3. after that you can able to see https://localhost/8080

4. install awscli get update access key secret key updated then create an IAM user then give necessary permissions for respective policies, ECR, Cloudformation, S3 etc
below just a example
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ecr-public:InitiateLayerUpload",
                "ecr-public:PutImage",
                "ecr-public:UploadLayerPart",
                "ecr-public:GetAuthorizationToken",
                "ecr-public:*"
                "s3:*"
            ],
            "Resource": "arn:aws:ecr-public::accounid:repository/javatest/supermarket-checkout"
        }
    ]
}
5. login into ECR then Create a repository in ECR and need to push images to repo with latest tag
- docker tag supermarket-checkout:latest your-account-id.dkr.ecr.your-region.amazonaws.com/supermarket-checkout:latest

- docker push your-account-id.dkr.ecr.your-region.amazonaws.com/supermarket-checkout:latest
-----------------------------------------------------------------------------------------
lambda deployment is something different (using serverless deployment you can do or ECM container you can use )
--------------------------------------

- run mvn clean package (it will creaet a target files with ending with .jar)
- run jar tf target/tdd-supermarket-1.0.0-SNAPSHOT.jar to see list for jar
/***created Lambda,vpc,security group, alb but somewhere root error its coming blocked with error for deployment**/
#install samcli in your local and create a template file run sam deploy commmand (before doing this you need configure lambda function, s3access, alb etc)
- sam deploy --template-file sam-template.yaml --stack-name supermarket-checkout --capabilities CAPABILITY_IAM
------------------------------------------------------------------------------------------------------







---------------------------------------------------------------------------------------------------------
Process through gitlab and infrastructure ways
--------------------------

1. create gitlab personal profile
2. create gitlab ci file with stages build, test, create image, publish image to s3 (if you want i can explain steps)


 infrastructure sample  way process -

 1. create a separt repo to maintain the infrastructure
 2. creating the following terraform resources
 3. IAM role for gitlab, iam policy attach to lambda function,


IAM Role for lambda function
--------------------------
resource "aws_iam_role" "lambda_role" {
  name        = "market"
  description = "Allows is$reponame lambda to obtain AWS permissions in ${var.region}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
}



data "aws_ssm_parameter" "oidc_provider_id" { # parameter store
  name = "/standard/oidc_provider_id"
}






IAM Role Infra gitlab role
data "aws_iam_policy_document" "ci_role" {
  statement {
    sid = "AllowGitlabOIDCRole"
    actions = [
      "sts:AssumeRoleWithWebIdentity"
    ]
    principals {
      type        = "Federated"
      identifiers = ["arn:aws:iam::${local.aws_account_id}:oidc-provider/gitlab.com"]
    }
    condition {
      test     = "StringLike"
      variable = "gitlab.com:sub"
      values   = ["project_path:personal/gitlab/reponame${var.team}/${var.reponame}:ref_type:branch:ref:*"]
    }
  }
}

 4. ecr, s3 bucket for resources,
 ---------------------------------


resource "aws_iam_policy" "market" {
  name        = "java market"
  description = "Allows Data to access s3 and ecr"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "lambda:*",
          "s3:PutObject",
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:DeleteObject",
          "s3:DeleteObjectVersion",
          "ecr:*"
        ]
        Resource = [
          "arn:aws:lambda:::function:*paas*",
          "arn:aws:s3:::*sample",
          "arn:aws:s3:::*sample/*",
          "arn:aws:ecr:*:*:repository/*java-test*",
          "arn:aws:ecr:*:*:repository/*java-test*/*",
        ]
      }
    ]
  })
}

 5. lambda configuration using IAC (alb to lambda) or (API gateway to lambda)

 # Cloudfront using route53 record
resource "aws_route53_record" "vid30_staging_external" {
  count   = var.region == "us-west-2" ? local.workspace == "staging" ? 0 : 1 : 0
  zone_id = nonsensitive(data.aws_ssm_parameter.hosted_zone_external_domain_id.value)
  name    = "java-test"
  type    = "CNAME"
  ttl     = "3600"
  records = ["d2lgtb8ah8nkbr.cloudfront.net"]
}
data "aws_ssm_parameter" "oidc_provider_id" { # parameter store
  name = "/standard/oidc_provider_id"
}

# Edge location resources
# Lambda @ Edge function
data "aws_ssm_parameter" "lambda_cloudfront_distribution_staging" {
  provider = aws.rolename
  count    = local.disaster_recovery ? 0 : local.workspace == "staging" ? 0 : 1
  name     = "/reponame/java_cloudfront_url"
}
 6. ALB, DNS(Rote53)
 7. default vpc
 8. 