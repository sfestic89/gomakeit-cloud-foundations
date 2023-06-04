#!/bin/bash

set -e

org_id=$1
email=$2

export PROJECT_ID=prj-bootstrap-dvt-$org_id
export BOOTSTRAP_SA_NAME=sa-bootstrap-temp
export BOOTSTRAP_SA_EMAIL=$BOOTSTRAP_SA_NAME@$PROJECT_ID.iam.gserviceaccount.com

validate_parameters(){
  gcloud organizations describe $org_id || ( echo "Invalid Organization ID or user does not have permissions" && exit 1 )
}

create_resources(){
  gcloud projects describe $PROJECT_ID || gcloud projects create $PROJECT_ID

  gcloud config set project $PROJECT_ID

  gcloud services enable cloudresourcemanager.googleapis.com
  gcloud services enable iam.googleapis.com
  gcloud services enable cloudbilling.googleapis.com
  gcloud services enable cloudidentity.googleapis.com

  gcloud iam service-accounts describe $BOOTSTRAP_SA_EMAIL || gcloud iam service-accounts create $BOOTSTRAP_SA_NAME --display-name="Temporal Bootstrap Service Account" --description="Service account to be impersonated by $email for the first run of the Bootstrap module"

  gcloud iam service-accounts add-iam-policy-binding $BOOTSTRAP_SA_EMAIL --member="user:$email" --role='roles/iam.serviceAccountUser'
  gcloud iam service-accounts add-iam-policy-binding $BOOTSTRAP_SA_EMAIL --member="user:$email" --role='roles/iam.serviceAccountTokenCreator'

  gcloud projects add-iam-policy-binding $PROJECT_ID --member="user:$email" --role='roles/serviceusage.serviceUsageAdmin'

  gcloud organizations add-iam-policy-binding $org_id --member="serviceAccount:$BOOTSTRAP_SA_EMAIL" --role='roles/iam.workloadIdentityPoolAdmin'
  gcloud organizations add-iam-policy-binding $org_id --member="serviceAccount:$BOOTSTRAP_SA_EMAIL" --role='roles/orgpolicy.policyAdmin'
  gcloud organizations add-iam-policy-binding $org_id --member="serviceAccount:$BOOTSTRAP_SA_EMAIL" --role='roles/resourcemanager.folderCreator'
  gcloud organizations add-iam-policy-binding $org_id --member="serviceAccount:$BOOTSTRAP_SA_EMAIL" --role='roles/resourcemanager.organizationAdmin'
  gcloud organizations add-iam-policy-binding $org_id --member="serviceAccount:$BOOTSTRAP_SA_EMAIL" --role='roles/resourcemanager.projectCreator'
  gcloud organizations add-iam-policy-binding $org_id --member="serviceAccount:$BOOTSTRAP_SA_EMAIL" --role='roles/serviceusage.serviceUsageAdmin'
}

validate_parameters && create_resources
