# Step Functions Terraform Setup

This project contains Terraform configurations for setting up AWS Step Functions. The setup includes the definition of a state machine, associated Lambda functions, and necessary configurations.

## Project Structure

- **main.tf**: Contains the main configuration for the AWS Step Functions state machine, including states and transitions.
- **variables.tf**: Defines input variables for the Terraform configuration, specifying types and default values.
- **outputs.tf**: Specifies output values to be displayed after running `terraform apply`, such as the ARN of the state machine.
- **provider.tf**: Configures the AWS provider, including region and access credentials.

## Getting Started

1. **Prerequisites**: Ensure you have Terraform installed and configured on your machine.
2. **Clone the Repository**: Clone this repository to your local machine.
3. **Navigate to the Directory**: Change to the project directory.
4. **Initialize Terraform**: Run `terraform init` to initialize the Terraform configuration.
5. **Plan the Deployment**: Execute `terraform plan` to see the resources that will be created.
6. **Apply the Configuration**: Run `terraform apply` to deploy the infrastructure.

## Notes

- Make sure to configure your AWS credentials before running the Terraform commands.
- Review the `variables.tf` file to customize any input variables as needed.

For further details, refer to the individual file documentation within the project.