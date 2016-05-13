FROM quay.io/hellofresh/hf-baseimage
MAINTAINER Adham Helal <aa@hellofresh.com>

ENV DEBIAN_FRONTEND=noninteractive

# Install python openssh and curl for test-kitchen
RUN apt-get update && \
    apt-get install --no-install-recommends -y software-properties-common python python-setuptools git

# ENV for ansible setup
ENV SETUP_INSTALL_RUBY              "yes"
ENV SETUP_RUBY_CUSTOM_REPO_INSTALL  "yes"
ENV SETUP_RUBY_VERSION              "ruby2.1"

RUN echo "%superuser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
RUN groupadd superuser
RUN useradd ansible -m -G superuser

COPY ./python_requirements.txt /home/ansible/python_requirements.txt
COPY ./setup.sh /home/ansible/setup.sh

# Install ansible
USER ansible
ENV USER ansible
RUN bash -x /home/ansible/setup.sh
USER root

# Install bundler
RUN /usr/bin/gem install bundler

# Add Concurse resource
ADD http://stedolan.github.io/jq/download/linux64/jq /usr/local/bin/jq
COPY bin/check  /opt/resource/check
COPY bin/in     /opt/resource/in
COPY bin/out    /opt/resource/out
COPY bin/helper /opt/resource/helper

# Add JQ to parse JSON easier
RUN chmod +x /usr/local/bin/jq /opt/resource/out /opt/resource/in /opt/resource/check

# Update to security package
RUN apt-get update && apt-get -y -o Dpkg::Options::="--force-confdef" \
    dist-upgrade

# Cleanup APT.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
