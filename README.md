# Deploy-ECS-with-Fargate-and-MongoDB
# Web Application on AWS ECS using AWS Fargate with Terraform and Ansible

This repository contains Terraform and Ansible code to provision a web application connected to a MongoDB database on AWS ECS using AWS Fargate.

## Architecture

The architecture of the solution is illustrated in the following diagram:

<img width="686" alt="image" src="https://user-images.githubusercontent.com/47325353/227780631-12b44434-a60a-416f-a523-8dce88f35a19.png">


## Prerequisites

To use this code, you must have the following installed:

- Terraform
- Ansible
- Docker

You will also need an AWS account and an understanding of AWS services, Docker, and the web application's requirements.

## Usage

1. Clone this repository to your local machine.
2. In the `terraform` directory, run `terraform init`, `terraform plan`, and then `terraform apply` to provision the infrastructure on AWS.
3. Once the infrastructure is provisioned, navigate to the `ansible` directory and run `ansible-playbook playbook.yml` to deploy and configure the web application.
4. Test the web application by running `curl -X GET "{uri}/mobile/search?announceDate=1999&priceEur=200" -H "accept: application/json"` and replace `{uri}` with the actual URI of the load balancer for the ECS service.

## Customization

You can customize the Terraform and Ansible code to meet your specific requirements. For example, you can modify the MongoDB EC2 instance type, change the number of tasks in the ECS service, or update the environment variables passed to the web application.

## Maintenance

The infrastructure and application will need to be regularly maintained and updated to ensure security and reliability. Make sure to keep the Docker image and dependencies up to date, regularly apply security updates to the infrastructure, and monitor the performance and logs of the application.

## Security

The security configuration of the infrastructure and application should be carefully considered, such as securing the MongoDB instance with proper authentication and access control.

## License

This code is licensed under the MIT License. See `LICENSE` for more information.
