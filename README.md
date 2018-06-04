# AWS 3-Tier Infrastructure as Code setup and test using Terraform, kitchen-terraform

This project create following Infrastructure components in provided regions
- VPC
- EIP
- NAT
- Internet Gateway
- 3 Subnets
  - Public Subnets for external facing
  - Private subnet for ServerLess Lambdas
  - Database Subnet for MySql RDS
- Security Groups
  - to protect database can be accessed only by Lambdas
  - to protect lambdas are accessible via API gateways
  - to enable public subnet is accessible on internet
- Create Sample NODEJS Lambda
- Setup API gateways
- Enable IAM role and policy attachment for Lambda executions

#### To Run the project
##### Setup following Environment variables
- `` aws_access_key_id``
- ``aws_secret_access_key``
- ``export TF_VAR_db_password=<<DB_PASSWORD>>``
#### Run following commands
<b>Variables will be read from <code>terraform.tfvars</code>
- ''terraform init``
- ``terraform plan`` or ``terraform plan -var-file terraform.tfvars``
- ``terraform apply`` or ``terraform apply -var-file terraform.tfvars``
  - <i>Please make sure database password is provided as Environment variable</i>
- <i> To Destroy Infrastructure</i> ``terraform destroy`` or ``terraform destroy -var-file terraform.tfvars``

#### For Testing the Infrastructure setup using kitchen-terraform(WIP)
- Install Ruby
- ``gem install bundler``
- ``bundle install``
- ``kitchen test``
  - For debugging ``rspec`` command can be executed directly ``rspec -c -f documentation --default-path <<replace_with_project_dir>>  -P test/integration/default/controls/test_setup.rb``
