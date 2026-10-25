# Salad PRL miner image (WildRig 0.51.8)
FROM ubuntu:22.04
ARG WR_VER=0.51.8
ARG WR_SHA256=43f4071c743c922f2febf4b8ea44fc9f93dff668f5ffafcc24903dfd78f63771
ENV NVIDIA_VISIBLE_DEVICES=all NVIDIA_DRIVER_CAPABILITIES=compute,utility
RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates curl tini \
 && rm -rf /var/lib/apt/lists/* \
 && curl -fsSL -o /tmp/wr.tgz https://github.com/andru-kun/wildrig-multi/releases/download/${WR_VER}/wildrig-multi-linux-${WR_VER}.tar.gz \
 && echo "${WR_SHA256}  /tmp/wr.tgz" | sha256sum -c - \
 && mkdir -p /opt/wildrig && tar -xzf /tmp/wr.tgz -C /opt/wildrig --strip-components=0 && rm /tmp/wr.tgz \
 && WR=$(find /opt/wildrig -name wildrig-multi -type f | head -1) && ln -sf "$WR" /usr/local/bin/wildrig-multi && chmod +x "$WR"
# 地址是公开收款地址，不是私钥；可在 Salad 环境变量里覆盖
ENV ADDR=prl1pn0mkfzlurh4y667drjn2mph6zncjx7k5wjsv3qcr4f3jxpyv0w2q9udq0d \
    POOL=stratum+tcp://pool.pearlhash.xyz:9000 \
    WORKER=salad-1
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/usr/bin/tini","--","/entrypoint.sh"]
