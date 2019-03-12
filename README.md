# Terraform-Ansible-TFE

> This is one solution around using the Ansible Host file, and using localhost.  The key design constraints have the following features:
>
  - Hostfile Groups typically drive execution towards specific playbooks
  - Those playbooks are fetched from a VCS or Artifact Repo (e.g Nexus, Artifactory, etc...)
  - The artifact to fetch is assigned to a variable in the CI/CD pipeline
  - That variable is assigned to Terraform Enterprise via TFE REST API call
  - Terraform's [Remove-Exec](https://www.terraform.io/docs/provisioners/remote-exec.html) is used to execute the playbook(s) on the instance being provisioned

## Configuration
> Two variables need to be created in the Workspace - Variables page
  - key_name This is the actual name of the PEM key in EC2 - Key Pairs page
  - key_contents  Assuming you downloaded the key_name and placed it in your .ssh folder, this is the actual contents.  Mark this secure, as it is a private key
>

## Environment
> Three Environment variables need to be created in the Workspace, essentially from your ~/.aws/credentials file in the Variables page, Environment Section.  Be sure to mark your Key and secret "sensitive" in the UI
  - AWS_DEFAULT_REGION The region name, e.g. us-west-2
  - AWS_ACCESS_KEY_ID  from ~/.aws/credentials, the Key ID value
  - AWS_SECRET_ACCESS_KEY from ~/.aws/credentials, Secret Key Value
>