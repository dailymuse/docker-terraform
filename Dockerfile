FROM hashicorp/terraform:0.12.24

LABEL maintainer="The Muse"

# Install awscli

# See https://github.com/aws/aws-cli/issues/1957 to understand why groff & less are needed
RUN apk add --no-cache python groff less

ENV AWS_CLI_VERSION 1.18.45

RUN set -eux && \
    apk add --no-cache --virtual py-deps \
      py-pip \
      && \
    pip install awscli==$AWS_CLI_VERSION && \
    apk del py-deps && \
    aws --version


# Install terragrunt

ENV TERRAGRUNT_VERSION 0.23.10

RUN set -eux && \
    wget -O /usr/bin/terragrunt \
      https://github.com/gruntwork-io/terragrunt/releases/download/v${TERRAGRUNT_VERSION}/terragrunt_linux_amd64 && \
    chmod +x /usr/bin/terragrunt && \
    terragrunt --version

# Plugin setup
RUN mkdir -p $HOME/.terraform.d/plugins

# Install Kafka provider

ENV KAFKA_PROVIDER_VERSION 0.2.4

RUN set -eux && \
    mkdir -p /tmp/kafka && \
    wget -O /tmp/kafka/provider.tar.gz \
      https://github.com/Mongey/terraform-provider-kafka/releases/download/v${KAFKA_PROVIDER_VERSION}/terraform-provider-kafka_${KAFKA_PROVIDER_VERSION}_linux_amd64.tar.gz && \
    tar xzf /tmp/kafka/provider.tar.gz -C $HOME/.terraform.d/plugins && \
    rm -rf /tmp/kafka

# Change entrypoint to shell, since terraform is already in PATH. No reason
# to limit ourselves to terraform commands.

ENTRYPOINT ["/bin/sh", "-c"]
CMD ["terraform", "--version"]
