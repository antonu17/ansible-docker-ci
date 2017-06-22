FROM alpine

COPY ./files/python_requirements.txt /opt/python_requirements.txt
COPY ./files/VERSION /
COPY ./files/VERSION_NAME /
COPY ./files/Gemfile /opt/Gemfile
COPY ./files/syntax-checks.py /usr/local/bin/syntax-checks.py

# perl
RUN apk add --update \
    ruby \
    git \
    openssh-client \
    ruby-json \
    ruby-io-console && \
    apk --no-cache add python \
                     py-pip \
                     openssl \
                     jq \
                     curl \
                     ca-certificates && \
    apk --no-cache add --virtual \
                     build-dependencies \
                     python-dev \
                     libffi-dev \
                     openssl-dev \
                     build-base &&\
    \
    chmod +x /usr/local/bin/syntax-checks.py && \
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

