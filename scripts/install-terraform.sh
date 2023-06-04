#!/bin/bash

set -e

terraform_version=$1

install_terraform() {
  echo "*************** Install Terraform *******************"
  echo "      Terraform Version: '${terraform_version}'"
  echo "**************************************************************"
  echo
  
  if [ -z "${terraform_version}" ]; then
      echo "ERROR: terraform_version not provided"
      exit 1
  fi

  apt-get update && apt-get install -y gnupg software-properties-common wget apt-transport-https ca-certificates gnupg2 coreutils curl git
  wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
  echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list
  apt update
  apt-get install -y terraform="${terraform_version}"
  terraform --version
  apt-get install google-cloud-sdk-terraform-tools
}

install_terraform