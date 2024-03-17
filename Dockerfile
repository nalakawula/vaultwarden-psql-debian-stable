FROM debian:stable

ARG vaultwarden_version

# These files can become huge, gigabytes
# See: https://github.com/sagemathinc/cocalc/issues/2287
RUN rm /var/log/faillog /var/log/lastlog

RUN apt update && apt -y install \
    build-essential git libpq-dev libssl-dev pkg-config curl

RUN curl --proto '=https' --tlsv1.2 -sSf -o /tmp/rustup.sh https://sh.rustup.rs
RUN sh /tmp/rustup.sh -y

RUN mkdir -p /app
RUN git clone -b $vaultwarden_version --depth=1 --recurse-submodules -j2 \
    https://github.com/dani-garcia/vaultwarden /app

WORKDIR /app

RUN /root/.cargo/bin/cargo clean
RUN /root/.cargo/bin/cargo build --release --features postgresql
