FROM alpine

COPY ./files/python_requirements.txt /opt/python_requirements.txt
COPY ./files/VERSION /
COPY ./files/VERSION_NAME /
COPY ./files/Gemfile /opt/Gemfile
COPY ./files/Gemfile.lock /opt/Gemfile.lock

# perl 
RUN apk add --update \
    ruby \
    git \
    openssh-client \
    ruby-json \
    ruby-io-console && \
    apk --update add python \
                     py-pip \
                     openssl \
                     jq \
                     ca-certificates && \
    apk --update add --virtual \
                     build-dependencies \
                     python-dev \ 
                     libffi-dev \
                     openssl-dev \
                     build-base &&\
    \
    echo "===> Installing Ansible and python ..."  && \ 
    mkdir /tmp/python && \
    pip install --upgrade --build /tmp/python pip && \
    pip install --upgrade --build /tmp/python -r /opt/python_requirements.txt && \
    \
    \
    echo "===> Installing Ruby stuff ..."  && \
    /usr/bin/gem install --no-ri --no-rdoc bundler && \
    echo "gem: --no-ri --no-rdoc" > ~/.gemrc && \
    cd /opt/ &&\
    bundle install --path /root/bundler_gems  --clean --no-cache  &&\
    \
    \
    echo "===> Removing package list..."  && \
    apk del build-dependencies\
            python-dev \ 
            libffi-dev \
            openssl-dev \
            build-base && \
    rm -rf /var/cache/apk/* &&\
    rm -rf /root/.cache/ &&\
    rm -rf /tmp/python

