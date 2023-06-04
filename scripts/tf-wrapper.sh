#!/bin/bash

# Copyright 2021 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -e

action=$1
base_dir=$2
project_id=$3
policysource=$4
tmp_plan="${base_dir}/tmp_plan"

## Terraform apply for single environment.
tf_apply() {
  local path=$1

  if [ -d "${path}" ]; then
    cd "${path}" || exit
    terraform apply -input=false -auto-approve "${tmp_plan}/plan_output.tfplan" || exit 1
    cd "${base_dir}" || exit
  else
    echo "ERROR:  '${path}' does not exist"
    exit 1
  fi
}

## terraform init for single environment.
tf_init() {
  local path=$1

  if [ -d "${path}" ]; then
    cd "${path}" || exit
    terraform init || exit 11
    cd "${base_dir}" || exit
  else
    echo "ERROR:  '${path}' does not exist"
    exit 1
  fi
}

## terraform plan for single environment.
tf_plan() {
  local path=$1

  if [ ! -d "${tmp_plan}" ]; then
    mkdir "${tmp_plan}" || exit
  fi
  if [ -d "${path}" ]; then
    cd "${path}" || exit
    terraform plan -input=false -out "${tmp_plan}/plan_output.tfplan" || exit 21
    cd "${base_dir}" || exit
  else
    echo "ERROR:  '${path}' does not exist"
    exit 1
  fi
}

## terraform show for single environment.
tf_show() {
  local path=$1

  if [ -d "${path}" ]; then
    cd "${path}" || exit
    terraform show "${tmp_plan}/plan_output.tfplan" || exit 41
    cd "${base_dir}" || exit
  else
    echo "ERROR:  '${path}' does not exist"
    exit 1
  fi
}

## terraform validate for single environment.
tf_validate() {
  local path=$1
  local policy_file_path=$2

  if [ -z "$policy_file_path" ]; then
    echo "no policy repo found! Check the argument provided for policysource to this script."
    echo "https://github.com/GoogleCloudPlatform/terraform-validator/blob/main/docs/policy_library.md"
  else
    if [ -d "${path}" ]; then
      cd "${path}" || exit
      terraform show -json "${tmp_plan}/plan_output.tfplan" > "plan_output.json" || exit 32
      gcloud beta terraform vet "plan_output.json" --policy-library="${policy_file_path}" --project="${project_id}" || exit 33
      cd "${base_dir}" || exit
    else
      echo "ERROR:  '${path}' does not exist"
      exit 1
    fi
  fi
}

case "$action" in
  apply )
    tf_apply "${base_dir}"
    ;;
  init )
    tf_init "${base_dir}" 
    ;;
  plan )
    tf_plan "${base_dir}" 
    ;;
  show )
    tf_show "${base_dir}" 
    ;;
  validate )
    tf_validate "${base_dir}" "${policysource}"
    ;;
  * )
    echo "unknown option: '${1}'"
    exit 99
    ;;
esac
