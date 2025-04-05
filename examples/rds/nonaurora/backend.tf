terraform {

  backend "s3" {
    bucket         = "randoneering-ENVIRONMENT-us-east-1-tfstate" # You will need to change the "ENVIRONMENT" to the target environment
    key            = "ENGINE/NAMEOFSERVICE-DB.tfstate"            # Seen as a file path in S3. This will be deployed at the HEAD of the s3 bucket.
    region         = "us-east-1"                                  # Your target region
    dynamodb_table = "randoneering-ENVIRONMENT-tfstate-lock"      # Simply replace the "ENVIRONMENT" with the target environment like the bucket above.
    encrypt        = true
    #profile = "aws-config-profile-alias" # If you deploy via CI/CD, this can remain commented out. However, for local deployments, uncomment and assign the name of your target aws alias in your .aws/config file
  }
}