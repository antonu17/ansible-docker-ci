FROM alpine

RUN apk add --update \
  ruby \
  perl \
  jq \
  git \
  openssh-client \
  ruby-json \
  ruby-io-console 
RUN gem install octokit httpclient --no-rdoc --no-ri

RUN echo "===> Adding Python runtime..."  && \
    apk --update add python py-pip openssl ca-certificates    && \
    apk --update add --virtual build-dependencies \
                python-dev libffi-dev openssl-dev build-base  && \
    pip install --upgrade pip cffi                            && \
    \
    \
    echo "===> Installing Ansible..."  && \
    pip install ansible                && \
    \
    \
    echo "===> Removing package list..."  && \
    apk del build-dependencies            && \
    rm -rf /var/cache/apk/*

COPY ./python_requirements.txt /opt/python_requirements.txt
RUN pip install -r /opt/python_requirements.txt

#  Ruby
COPY ./Gemfile_requirments.txt /opt/Gemfile_requirments.txt
RUN /usr/bin/gem install --no-ri --no-rdoc -g /opt/Gemfile_requirments.txt

