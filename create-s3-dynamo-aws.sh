#!/bin/bash

# Variables
BUCKET_NAME="lili-terraform-state"
REGION="us-east-1"
DYNAMODB_TABLE="terraform-state"
PROFILE="ecr-eks-user1"
STATE_KEY="terraform/state/terraform.tfstate"

# Create S3 Bucket
if [ "$REGION" != "us-east-1" ]; then
  aws s3api create-bucket --bucket $BUCKET_NAME --region $REGION --create-bucket-configuration LocationConstraint=$REGION --profile $PROFILE
else
  aws s3api create-bucket --bucket $BUCKET_NAME --region $REGION --profile $PROFILE
fi

# Enable versioning on the S3 bucket
aws s3api put-bucket-versioning --bucket $BUCKET_NAME --versioning-configuration Status=Enabled --profile $PROFILE

# Enable server-side encryption on the S3 bucket
aws s3api put-bucket-encryption --bucket $BUCKET_NAME --server-side-encryption-configuration '{
  "Rules": [
    {
      "ApplyServerSideEncryptionByDefault": {
        "SSEAlgorithm": "AES256"
      }
    }
  ]
}' --profile $PROFILE

# Set public access block on the S3 bucket
aws s3api put-public-access-block --bucket $BUCKET_NAME --public-access-block-configuration '{
  "BlockPublicAcls": true,
  "IgnorePublicAcls": true,
  "BlockPublicPolicy": true,
  "RestrictPublicBuckets": true
}' --profile $PROFILE

# Create DynamoDB Table
aws dynamodb create-table \
    --table-name $DYNAMODB_TABLE \
    --attribute-definitions AttributeName=LockID,AttributeType=S \
    --key-schema AttributeName=LockID,KeyType=HASH \
    --billing-mode PAY_PER_REQUEST \
    --tags Key=Environment,Value=Production \
    --region $REGION \
    --profile $PROFILE

echo "Resources created successfully."

# Create backend.tf file
cat <<EOL > backend.tf
terraform {
  backend "s3" {
    bucket         = "$BUCKET_NAME"
    key            = "$STATE_KEY"
    region         = "$REGION"
    dynamodb_table = "$DYNAMODB_TABLE"
    encrypt        = true
  }
}
EOL
