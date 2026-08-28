FROM debian:bookworm-slim

# Image dibangun dari binary vpn-rest di repo ini, bukan menarik image jadi
# dari Docker Hub — supaya installer tidak bergantung pada pihak lain.

RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates \
    && rm -rf /var/lib/apt/lists/*

COPY vpn-rest /usr/local/bin/vpn-rest
RUN chmod +x /usr/local/bin/vpn-rest

ENV PORT=3005
EXPOSE 3005

ENTRYPOINT ["/usr/local/bin/vpn-rest"]
