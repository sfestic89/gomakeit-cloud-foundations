#!/bin/bash

set -e

service_account=$1
workload_identity_provider_id=$2
oidc_token=$3
project_id=$4
base_dir=$5

impersonate_sa() {
  echo "*************** Impersonate Service Account *******************"
  echo "      Service Account:              '${service_account}' "
  echo "      Workload Identity Provider:   '${workload_identity_provider_id}' "
  echo "      Project ID:                   '${project_id}' "
  echo "      Base directory:               '${base_dir}' "
  echo "**************************************************************"
  echo
  
  if [ -z "${service_account}" ]; then
      echo "ERROR: service_account not provided"
      exit 1
  fi

  if [ -z "${base_dir}" ]; then
      echo "ERROR: base_dir not provided"
      exit 1
  fi

  if [ -z "${oidc_token}" ]; then
      echo "ERROR: oidc_token not provided"
      exit 1
  fi

  if [ -z "${workload_identity_provider_id}" ]; then
      echo "ERROR: workload_identity_provider_id not provided"
      exit 1
  fi

  if [ -z "${project_id}" ]; then
      echo "ERROR: project_id not provided"
      exit 1
  fi

  mkdir -p "${base_dir}/creds"  || exit 1
  echo "${oidc_token}" > "${base_dir}/creds/.ci_job_jwt_file"
  gcloud iam workload-identity-pools create-cred-config "${workload_identity_provider_id}" \
    --service-account="${service_account}" \
    --output-file="${base_dir}/creds/.gcp_temp_cred.json" \
    --credential-source-file="${base_dir}/creds/.ci_job_jwt_file"  || exit 1
  gcloud auth login --cred-file="${base_dir}/creds/.gcp_temp_cred.json"  || exit 1
}

impersonate_sa || exit 1