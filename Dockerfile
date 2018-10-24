FROM debian:stretch-slim
LABEL maintainer="z.cius <zr.cius@gmail.com>"

RUN groupadd -r postgres --gid=999 && useradd -r -g postgres --uid=999 postgres

RUN sed -i 's/deb.debian.org/mirrors.ustc.edu.cn/g' /etc/apt/sources.list && \
    sed -i 's|security.debian.org/debian-security|mirrors.ustc.edu.cn/debian-security|g' /etc/apt/sources.list && \
    apt-get update && apt-get install -y --no-install-recommends gnupg dirmngr ca-certificates wget sudo locales && \
    localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8 && \
    rm -rf /var/lib/apt/lists/*

ARG PG_MAJOR=10

ENV LANG=en_US.utf8 \
    PG_MAJOR=${PG_MAJOR} \
    PG_HOME_DIR=/var/lib/postgresql

RUN gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "B97B0AFCAA1A47F044F244A07FCC7D46ACCC4CF8" && \
    gpg --export "B97B0AFCAA1A47F044F244A07FCC7D46ACCC4CF8" > /etc/apt/trusted.gpg.d/postgres.gpg && \
    echo 'deb http://apt.postgresql.org/pub/repos/apt/ stretch-pgdg main' > /etc/apt/sources.list.d/pgdg.list && \
    apt-get update && apt-get install -y --no-install-recommends \
      postgresql-${PG_MAJOR} \
      postgresql-client-${PG_MAJOR} \
      postgresql-contrib-${PG_MAJOR} && \
    rm -rf /var/lib/apt/lists/*

VOLUME ${PG_HOME_DIR}
WORKDIR ${PG_HOME_DIR}

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 5432
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
