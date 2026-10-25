#!/bin/sh
# 与服务器大矿机相同的算法参数；Salad 容器无权锁显存频率，故不加 -lmc
nvidia-smi -L || true
exec wildrig-multi --algo pearlhash --url "$POOL" --user "$ADDR" --worker "$WORKER" \
  --print-time 15 --gpu-temp-limit 80 --pearlhash-kernel 2
