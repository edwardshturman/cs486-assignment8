# CS 486 Assignment 8

Implementation details and instructions for using Terraform with Packer

> [!NOTE]
> These instructions have been tested on Mac. Please seek alternative installation methods for your operating system if need be.

## Prerequisites

- The **Packer CLI**
- The **Terraform CLI**

You can install these with [Homebrew](https://brew.sh):

```zsh
brew tap hashicorp/tap
brew install hashicorp/tap/packer
brew install hashicorp/tap/terraform
```

## Setup

Get started by cloning this repo on your machine:

```zsh
git clone https://github.com/edwardshturman/cs486-assignment8.git cs486-assignment8-edwardshturman
cd cs486-assignment8-edwardshturman
```

### Required variables

#### AWS credentials

You'll need to configure your AWS credentials before Packer or Terraform can provision infrastructure. Specifically, you must provide the `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` variables. This can be done by:

- Exporting to your environment:

  ```zsh
  export AWS_ACCESS_KEY_ID="<your AWS access key ID>"
  export AWS_SECRET_ACCESS_KEY="<your AWS secret access key>"
  ```

- Using a shared credentials file:

  ```zsh
  echo "[default]" >> ~/.aws/credentials
  echo "aws_access_key_id = <your AWS access key ID>" >> ~/.aws/credentials
  echo "aws_secret_access_key = <your AWS secret access key>" >> ~/.aws/credentials
  ```

- A few other methods, but the above two are most convenient. When in doubt, see [the examples from the Packer docs](https://developer.hashicorp.com/packer/integrations/hashicorp/amazon#environment-variables).

#### `allow_ssh_ip`

By setting this Terraform variable, your IP will be whitelisted in the bastion host's incoming connection rules.

Set `allow_ssh_ip` to your public IPv4:

```zsh
echo "allow_ssh_ip = \"$(curl -s ifconfig.me)\"" >> terraform.tfvars
```

#### `public_key`

You can specify the public RSA key from a keypair to be linked to the bastion host, so that you can SSH into it.

Make a new keypair and copy the public key:

```zsh
ssh-keygen -t rsa -b 2048 -m PEM -f bastion-key
echo "public_key = \"$(cat bastion-key.pub)\"" >> terraform.tfvars
```

## Building an image with Packer

```zsh
packer init
packer build
```

Take note of the AMI from the output. Add it to the Terraform variables for use in the next step:

```zsh
echo "ami = <ami>" >> terraform.tfvars
```

## Creating infrastructure with Terraform

We're all good to go to launch six EC2 instances using our AMI created with Packer and a bastion host.

```zsh
terraform init
terraform build
```

You should now see seven running instances in `us-west-1`.

![Screenshot of AWS EC2 Instances in the Console](assets/instances.png)
