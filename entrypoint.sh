#!/bin/sh
# 与服务器大矿机相同的算法参数；Salad 容器无权锁显存频率，故不加 -lmc
nvidia-smi -L || true
W="$WORKER"
if [ "$WORKER_NO_SUFFIX" != "1" ]; then
  SRC="$SALAD_MACHINE_ID"
  [ -z "$SRC" ] && SRC="$(hostname)"
  SUF="$(printf '%s' "$SRC" | cut -c1-6)"
  [ -n "$SUF" ] && W="${WORKER}-${SUF}"
fi
echo "Final worker name: $W"
exec wildrig-multi --algo pearlhash --url "$POOL" --user "$ADDR" --worker "$W" \
  --print-time 15 --gpu-temp-limit 80 --pearlhash-kernel 2
