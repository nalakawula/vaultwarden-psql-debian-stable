FROM debian:stable

# These files can become huge, gigabytes
# See: https://github.com/sagemathinc/cocalc/issues/2287
RUN rm /var/log/faillog /var/log/lastlog

# Update and install dependencies
RUN apt update && apt -y install \
    build-essential git libpq-dev libssl-dev pkg-config curl && \
    curl --proto '=https' --tlsv1.2 -sSf -o /tmp/rustup.sh https://sh.rustup.rs && \
    sh /tmp/rustup.sh -y && \
    mkdir -p /app

WORKDIR /app

# Clone the repository and build Vaultwarden
ARG vaultwarden_version
RUN git clone -b ${vaultwarden_version} --depth=1 --recurse-submodules -j2 \
    https://github.com/dani-garcia/vaultwarden /app && \
    /root/.cargo/bin/cargo clean && \
    /root/.cargo/bin/cargo build --release --features postgresql
