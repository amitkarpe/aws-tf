# aws-tf

AWS Terraform examples.

## Connection policy

New and updated EC2 examples must use AWS Systems Manager Session Manager.
Do not commit SSH keys or require inbound SSH access. Existing SSH-based
examples are legacy and must be converted to SSM before reuse.
