#!/bin/bash

set -e

domain=$1
bootstrap_sa_email=$2

bootstrap(){
  echo "***************************************************************"
  echo "********* Bootstrapping Landing Zone for '$domain' ************"
  echo "***************************************************************"

  echo "***************************************************************"
  echo "************************ Set up gcloud ************************"
  echo "***************************************************************"
  
  gcloud auth application-default login

  echo "***************************************************************"
  echo "***** Impersonate Service Account '$bootstrap_sa_email' *******"
  echo "***************************************************************"
  
  export GOOGLE_IMPERSONATE_SERVICE_ACCOUNT=$bootstrap_sa_email

  echo "***************************************************************"
  echo "************** Set the domain '$domain' ***********************"
  echo "***************************************************************"
  
  cd .. # root folder
  for i in `find -name '*.tfvars' -o -name '*.tf'`; do sed -i "s/DOMAIN_REPLACE/${domain}/" $i; done
  cd gcp-bootstrap

  echo "***************************************************************"
  echo "********** Deploying Bootstrap module using Terraform *********"
  echo "***************************************************************"
  
  terraform init
  terraform plan
  terraform apply
  
  echo "***************************************************************"
  echo "************** Capturing outputs from Terraform ***************"
  echo "***************************************************************"
  
  # Capture outputs
  export gcs_bucket_tfstate=$(terraform output -raw gcs_bucket_tfstate)

  export git_repository_type=$(terraform output -raw git_repository_type)

  export seed_project_id=$(terraform output -raw seed_project_id)
  export workload_identity_pool_provider_resource_name=$(terraform output -raw workload_identity_pool_provider_resource_name)
  export bootstrap_step_terraform_service_account_email=$(terraform output -raw bootstrap_step_terraform_service_account_email)
  export organization_step_terraform_service_account_email=$(terraform output -raw organization_step_terraform_service_account_email)
  export environment_step_terraform_service_account_email=$(terraform output -raw environment_step_terraform_service_account_email)
  export networks_step_terraform_service_account_email=$(terraform output -raw networks_step_terraform_service_account_email)
  export projects_step_terraform_service_account_email=$(terraform output -raw projects_step_terraform_service_account_email)

  echo "***************************************************************"
  echo "**************** Updating state bucket values *****************"
  echo "***************************************************************"
  
  [[ ! -f backend.tf ]] && cp backend.template backend.tf

  cd .. # root folder
  # Update state buckets
  for i in `find -name 'backend.tf' -o -name '*.tfvars'`; do sed -i "s/REMOTE_STATE_BUCKET/${gcs_bucket_tfstate}/" $i; done

  echo "***************************************************************"
  echo "******************** Creating CI/CD file **********************"
  echo "***************************************************************"
  cd gcp-bootstrap
  
  # Generate CI/CD file from template
  case ${git_repository_type} in
    GITHUB)
      export pipeline_file=.github/workflows/terraform.yml
      mkdir -p .github/workflows
      cp cicd/GITHUB.yml ${pipeline_file}
      ;;   
    GITLAB)
      export pipeline_file=.gitlab-ci.yml
      cp cicd/GITLAB.yml ${pipeline_file}
      ;;
    BITBUCKET)
      export pipeline_file=bitbucket-pipelines.yml
      cp cicd/BITBUCKET.yml ${pipeline_file}
      ;; 
    *)
      echo "CI/CD file for Git repository type '${git_repository_type}' not defined" && exit 1
      ;;
  esac

  sed -i "s,BOOTSTRAP_PROJECT_ID_REPLACE,${seed_project_id},g" ${pipeline_file}
  sed -i "s,WORKLOAD_IDENTITY_PROVIDER_ID_REPLACE,${workload_identity_pool_provider_resource_name},g" ${pipeline_file}
  sed -i "s,TF_BOOTSTRAP_SERVICE_ACCOUNT_REPLACE,${bootstrap_step_terraform_service_account_email},g" ${pipeline_file}
  sed -i "s,TF_ORG_SERVICE_ACCOUNT_REPLACE,${organization_step_terraform_service_account_email},g" ${pipeline_file}
  sed -i "s,TF_ENVIRONMENTS_SERVICE_ACCOUNT_REPLACE,${environment_step_terraform_service_account_email},g" ${pipeline_file}
  sed -i "s,TF_NETWORKS_SERVICE_ACCOUNT_REPLACE,${networks_step_terraform_service_account_email},g" ${pipeline_file}
  sed -i "s,TF_PROJECTS_SERVICE_ACCOUNT_REPLACE,${projects_step_terraform_service_account_email},g" ${pipeline_file}

  echo "***************************************************************"
  echo "****** Validating deployment and moving TF state to GCP *******"
  echo "***************************************************************"
  
  terraform init
  terraform plan
}

bootstrap
