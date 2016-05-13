#!/bin/bash
set -e

echo "$USER"
whoami

SETUP_VERSION="master"

## Install Ansible 1.9.4
ANSIBLE_VERSIONS[0]="1.9.4"
INSTALL_TYPE[0]="pip"
PYTHON_REQUIREMENTS[0]="/home/ansible/python_requirements.txt"
ANSIBLE_V1_PATH="${ANSIBLE_VERSIONS[0]}" # v1 link

## Install Ansible 2
ANSIBLE_VERSIONS[1]="2.0.1.0"
INSTALL_TYPE[1]="pip"
PYTHON_REQUIREMENTS[1]="/home/ansible/python_requirements.txt"
ANSIBLE_V2_PATH="${ANSIBLE_VERSIONS[1]}" # v2 link

# Whats the default version
ANSIBLE_DEFAULT_VERSION="ANSIBLE_VERSIONS[1]"

## Create a temp dir
filename=$( echo ${0} | sed 's|/||g' )
my_temp_dir="$(mktemp -dt ${filename}.XXXX)"

## Install ruby version 2.1
export SETUP_INSTALL_RUBY="yes"
export SETUP_RUBY_CUSTOM_REPO_INSTALL="yes"
export SETUP_RUBY_VERSION="ruby2.1"

## Get setup
curl -s https://raw.githubusercontent.com/AutomationWithAnsible/ansible-setup/master/setup.sh -o $my_temp_dir/setup.sh

## Run the setup
. $my_temp_dir/setup.sh

echo "> Change dir to setup \"$SETUP_DIR\""
cd $SETUP_DIR


RUN_COMMAND_AS() {
  if [ "$SETUP_USER" == "$USER" ]; then
    $1
  else
    sudo su $SETUP_USER -c "$1"
  fi
}

# explicitly set ansible to V2
RUN_COMMAND_AS "ansible-version set v2"

exit 0