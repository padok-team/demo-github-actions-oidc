# Demo OIDC Github Action Trigger

This repository demonstrates how to use GitHub Actions with OIDC (OpenID Connect) authentication to securely access AWS resources without storing long-lived credentials.

## Infrastructure Setup

The infrastructure is managed using Terraform and is organized in layers:

1. **Bootstrap Layer** (`terraform/layers/bootstrap/`):
   - Sets up the Terraform backend in S3
   - Creates DynamoDB table for state locking
   - Region: eu-west-3
   - Project: padok_dojo

2. **Main Layer** (`terraform/layers/main/`):
   - Configures OIDC provider for GitHub Actions
   - Sets up IAM roles and policies
   - Manages AWS resources

## Applying Terraform

### Prerequisites
- AWS CLI configured with appropriate credentials
- Terraform installed

### Steps to Apply Terraform

1. Initialize and apply the bootstrap layer:
```bash
cd terraform/layers/bootstrap
terraform init
terraform apply
```

2. Initialize and apply the main layer:
```bash
cd ../main
terraform init
terraform apply
```

## GitHub Actions Workflow

The workflow is configured to use OIDC authentication to access AWS resources. The IAM role is configured to trust GitHub Actions from the main branch of this repository.

### Triggering the Workflow

The workflow can be triggered in two ways:

1. **Manual Trigger**:
   - Go to the "Actions" tab in your GitHub repository
   - Select the workflow
   - Click "Run workflow"
   - Choose the branch (main)
   - Click "Run workflow"

2. **Push to Main Branch**:
   - Any push to the main branch will automatically trigger the workflow

### SSH Access to GitHub Actions Runner

To SSH into the GitHub Actions runner session:

1. The workflow will output a command to connect to the runner
2. Use the provided SSH command to connect
3. The session will be available for debugging and troubleshooting

Note: SSH access is only available during the workflow execution and will be terminated when the workflow completes.

## Security

- The OIDC provider is configured to trust only GitHub Actions from this repository
- IAM roles and policies are scoped to specific actions and resources
- No long-lived credentials are stored in the repository

## Troubleshooting

If you encounter issues:
1. Check the GitHub Actions logs for detailed error messages
2. Verify that the OIDC provider is correctly configured
3. Ensure the IAM role has the necessary permissions
4. Check that the workflow is running from the correct branch