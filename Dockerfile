from alpine:3.9
from docker:18.06.3-ce-dind

ARG VCS_REF
ARG BUILD_DATE

# Metadata
LABEL org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.name="helm-kubectl" \
      org.label-schema.url="https://hub.docker.com/r/dtzar/helm-kubectl/" \
      org.label-schema.vcs-url="https://github.com/dtzar/helm-kubectl" \
      org.label-schema.build-date=$BUILD_DATE


ENV KUBE_LATEST_VERSION="v1.14.3"
ENV HELM_VERSION="v2.14.1"

RUN apk add --no-cache ca-certificates bash git openssh curl \
    && wget -q https://storage.googleapis.com/kubernetes-release/release/${KUBE_LATEST_VERSION}/bin/linux/amd64/kubectl -O /usr/local/bin/kubectl \
    && chmod +x /usr/local/bin/kubectl \
    && wget -q https://storage.googleapis.com/kubernetes-helm/helm-${HELM_VERSION}-linux-amd64.tar.gz -O - | tar -xzO linux-amd64/helm > /usr/local/bin/helm \
    && chmod +x /usr/local/bin/helm

WORKDIR /config

CMD bash

RUN apk add --no-cache python py2-pip git
RUN pip install --no-cache-dir docker-compose==1.16.0
RUN echo "Install AWS" && \
    apk add --no-cache bash build-base ca-certificates curl gettext git libffi-dev linux-headers make musl-dev openldap-dev openssh-client python3 py-pip python3-dev rsync tzdata && \
    pip3 install --upgrade pip && \
    pip3 install awscli boto3 'PyYAML<=3.13,>=3.10' aws-sam-cli docker-compose --upgrade && \
    echo "Done install AWS" && \
    echo "Cleaning files!" && \
    rm -rf /tmp/* /var/cache/apk/* && \
    docker --version && \
    docker-compose --version && \
    aws --version && \
    sam --version && \
    echo "Done!"
