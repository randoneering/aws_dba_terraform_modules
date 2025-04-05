#This will generate a path in the bucket based on values in the locals.tf. It allows us to dynamically alter the backend based on the workspace/env you are currently working with (terraform workspace select blah)
data "terraform_remote_state" "rds" {
  backend = "s3"
  config = {
    bucket         = "randoneering-ENVIRONMENT-us-east-1-tfstate" # You will need to change the "ENVIRONMENT" to the target environment
    key            = "ENGINE/NAMEOFSERVICE-DB.tfstate"            # Seen as a file path in S3. This will be deployed at the HEAD of the s3 bucket.
    region         = "us-east-1"                                  # Your target region
    dynamodb_table = "randoneering-ENVIRONMENT-tfstate-lock"      # Simply replace the "ENVIRONMENT" with the target environment like the bucket above.
    encrypt        = true
    #profile = "aws-config-profile-alias" # If you deploy via CI/CD, this can remain commented out. However, for local deployments, uncomment and assign the name of your target aws alias in your .aws/config file
  }
}

data "aws_route53_zone" "zone" {
  name = local.environment.route53zone
}