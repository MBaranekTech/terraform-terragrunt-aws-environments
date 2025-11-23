# Terraform + Terragrunt Multi-Environment AWS (Part 2)

Multi-environment AWS infrastructure using Terragrunt (dev/test/prod) with remote state.
It also includes:
- S3 remote backend
- DynamoDB state locking
- Environment inheritance
- Reusable modules

## 🧱 Skills Practiced
- Terragrunt folder hierarchy
- DRY Terragrunt configuration
- Remote backend (S3 + DynamoDB)
- Managing multiple AWS environments

## 📁 Project Structure

```
terraform-terragrunt-aws-environments/
├── live/
│   ├── dev/
│   │   └── s3/
│   │       └── terragrunt.hcl
│   ├── test/
│   │   └── s3/
│   │       └── terragrunt.hcl
│   └── prod/
│       └── s3/
│           └── terragrunt.hcl
├── modules/
│   └── s3/
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
├── README.md
└── .gitignore

```
🔐 Remote State & Locking

This setup uses: <br>
S3 bucket: for storing Terraform state <br>
DynamoDB table: for locking to prevent concurrent state writes <br>
To create DynamoDB table manually (if required): <br>

```
aws dynamodb create-table --table-name terraform-locks --attribute-definitions AttributeName=LockID,AttributeType=S --key-schema AttributeName=LockID,KeyType=HASH --billing-mode PAY_PER_REQUEST --region us-west-2
```

Confirm table creation
```
aws dynamodb list-tables --region us-west-2
You should see:
{
    "TableNames": [
        "terraform-locks"
    ]
}
```
<img width="1285" height="780" alt="Snímek obrazovky 2025-11-23 152604" src="https://github.com/user-attachments/assets/a045a46a-f056-4e61-9611-414bf338348a" />

## How to Deploy

Initialize Terragrunt:

```bash
cd live/dev/s3
terragrunt init
```
Apply changes:
```
terragrunt apply
```
Repeat for test and prod folders.

<img width="1106" height="834" alt="Snímek obrazovky 2025-11-23 152633" src="https://github.com/user-attachments/assets/ebee13cb-160b-4531-bbf7-5dcc85afc555" />


## 🧹 Cleanup / Destroy
To remove all resources:
```
terragrunt destroy -auto-approve
aws s3 rb s3://<state-bucket> --force --region <region>
aws dynamodb delete-table --table-name <lock-table> --region <region>

# Destroy Terraform-managed resources
cd live/dev/s3  
terragrunt destroy -auto-approve  

cd ../test/s3  
terragrunt destroy -auto-approve  

cd ../prod/s3  
terragrunt destroy -auto-approve


# Remove the S3 backend bucket
aws s3 rb s3://my-tf-state-bucket-martin-001 --force --region us-west-2

# Delete the DynamoDB state locking table
aws dynamodb delete-table --table-name terraform-locks --region us-west-2
```
## 🧠 Why This Matters

Scalable: Add more environments/modules without duplicating code <br>
Safe: Remote state + locking prevents race conditions <br>
Reusable: Terraform modules can be shared or extended <br>
Secure: State is encrypted and managed in a centralized place <br>
Maintainable: Clear folder structure and separation of concerns <br>
