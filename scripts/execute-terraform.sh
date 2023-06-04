#!/bin/bash

set -e

base_dir=$1
tf_working_dir=$2
branch_name=$3
branch_name_apply=$4
bootstrap_project_id=$5
policy_library_folder=$6

execute_terraform() {
    echo "*************** Executing Terraform *******************"
    echo "      Base directory:              '${base_dir}' "
    echo "      Terraform working directory: '${tf_working_dir}' "
    echo "      Branch name:                 '${branch_name}' "
    echo "      Branch name apply:           '${branch_name_apply}' "
    echo "      Bootstrap project ID:        '${bootstrap_project_id}' "
    echo "      Policy library folder:       '${policy_library_folder}' "
    echo "**************************************************************"
    echo

    if [ -z "${base_dir}" ]; then
        echo "ERROR: base_dir not provided"
        exit 1
    fi

    if [ -z "${tf_working_dir}" ]; then
        echo "ERROR: tf_working_dir not provided"
        exit 1
    fi

    if [ -z "${branch_name}" ]; then
        echo "ERROR: branch_name not provided"
        exit 1
    fi

    if [ -z "${bootstrap_project_id}" ]; then
        echo "ERROR: bootstrap_project_id not provided"
        exit 1
    fi

    if [ -z "${policy_library_folder}" ]; then
        echo "ERROR: policy_library_folder not provided"
        exit 1
    fi

    # Check if the tf_working_dir has a main.tf
    # if a main tf is present execute it
    # if it is not execute terraform in the subfolders instead
    if [ -f "${tf_working_dir}/main.tf" ]; then
      local folders

      folders=("${tf_working_dir}")

      loop_dirs_and_execute "${folders[@]}"
    else
      local folders

      folders=$(find "${tf_working_dir}" -mindepth 1 -maxdepth 1 -type d)

      loop_dirs_and_execute "${folders[@]}"
    fi
}

loop_dirs_and_execute() {
    local folders=$@

    for target_directory in $folders
    do
        echo "**************************************************************"
        echo "          Terraform init for '${target_directory}'"
        echo "**************************************************************"
        /bin/bash "${base_dir}/scripts/tf-wrapper.sh" init "${target_directory}" "${bootstrap_project_id}" || exit 1
        echo
    done

    for target_directory in $folders
    do
        echo "**************************************************************"
        echo "          Terraform plan for '${target_directory}'"
        echo "**************************************************************"
        /bin/bash "${base_dir}/scripts/tf-wrapper.sh" plan "${target_directory}" "${bootstrap_project_id}" || exit 1
        echo
    done

    for target_directory in $folders
    do
        echo "**************************************************************"
        echo "          Terraform validate for '${target_directory}'"
        echo "       Using Policy Library Folder: '${policy_library_folder}'"
        echo "**************************************************************"
        /bin/bash "${base_dir}/scripts/tf-wrapper.sh" validate "${target_directory}" "${bootstrap_project_id}" "${policy_library_folder}" || exit 1
        echo
    done

    if [[ ${branch_name} == ${branch_name_apply} ]]; then
      for target_directory in $folders
        do
          echo "**************************************************************"
          echo "          Terraform apply for '${target_directory}'"
          echo "**************************************************************"
          /bin/bash "${base_dir}/scripts/tf-wrapper.sh" apply "${target_directory}" "${bootstrap_project_id}" || exit 1
          echo
        done
    fi
}

execute_terraform || exit 1