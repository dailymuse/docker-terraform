FROM hashicorp/terraform:0.12.5

LABEL maintainer="The Muse"

# See https://github.com/aws/aws-cli/issues/1957 to understand why groff & less are needed
RUN apk add --no-cache python groff less

ENV AWS_CLI_VERSION 1.16.206

RUN apk add --no-cache --virtual py-deps \
      py-pip \
      && \
    pip install awscli==$AWS_CLI_VERSION && \
    apk del py-deps

# Change entrypoint to shell, since terraform is already in PATH. No reason
# to limit ourselves to terraform commands.

ENTRYPOINT ["/bin/sh", "-c"]
