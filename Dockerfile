FROM code-dal1.penguintech.group:5050/ptg/standards/docker-ansible-image:stable
LABEL company="Penguin Tech Group LLC"
LABEL org.opencontainers.image.authors="info@penguintech.group"
LABEL license="GNU AGPL3"

# GET THE FILES WHERE WE NEED THEM!
COPY . /opt/manager/
WORKDIR /opt/manager

# UPDATE as needed
RUN apt update && apt dist-upgrade -y && apt auto-remove -y && apt clean -y

# PUT YER ARGS in here
ARG APP_TITLE="Trino Gateway" # Change this to actual title for Default
ARG TRINO_LINK="https://github.com/lyft/presto-gateway/archive/refs/heads/master.zip"
ARG TRINO_ARC_VERSION="presto-gateway-master.zip"
ARG TRINO_VERSION="presto-gateway-master"

# BUILD IT!
RUN ansible-playbook build.yml -c local

# PUT YER ENVS in here
# ENV FOO="BAR"
# PUT YER ENVS in here
ENV DATABASE_TYPE="mariadb"
ENV DATABASE_NAME="prestogateway"
ENV DATABASE_USER="root"
ENV DATABASE_PASSWORD="root123"
ENV DATABASE_HOST="mariadb"
ENV DATABASE_PORT="3306"

# Special var for run-time for the java jar dependcy
ENV DEB_VERSION="1.9.5"

# I'm making some variables for testing purposes.  Not meant to be used in prod.
ENV FOLDER_PATH="/opt/trino-gateway/out_err/"
ENV FILE_OUT="mvn_std_out"
ENV FILE_ERR="mvn_std_err"
ENV FILE_LOOP_TEST=27

# Switch to non-root user
USER ptg-user

# Entrypoint time (aka runtime)
ENTRYPOINT ["/bin/bash","/opt/manager/entrypoint.sh"]
