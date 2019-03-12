# Terraform-Ansible-TFE

> This is one solution around using the Ansible Host file, and using localhost.  The key design constraints have the following features:
>
  - Hostfile Groups typically drive execution towards specific playbooks
  - Those playbooks are fetched from a VCS or Artifact Repo (e.g Nexus, Artifactory, etc...)
  - The artifact to fetch is assigned to a variable in the CI/CD pipeline
  - That variable is assigned to Terraform Enterprise via TFE REST API call
  - Terraform's [Remove-Exec](https://www.terraform.io/docs/provisioners/remote-exec.html) is used to execute the playbook(s) on the instance being provisioned
