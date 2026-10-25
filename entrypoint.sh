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
echo "PEARL_KERNEL=${PEARL_KERNEL:-2} EXTRA_ARGS=${EXTRA_ARGS}"
WRBIN="$(readlink -f /usr/local/bin/wildrig-multi)"
echo "== ldd $WRBIN"; ldd "$WRBIN" 2>&1
echo "== /etc/OpenCL/vendors"; ls -l /etc/OpenCL/vendors 2>&1; cat /etc/OpenCL/vendors/*.icd 2>&1
if [ ! -x "$WRBIN" ] || ldd "$WRBIN" 2>&1 | grep -q "not found"; then
  echo "FATAL: wildrig missing or unresolved libs; sleeping 60s before exit"; sleep 60; exit 127
fi
wildrig-multi --algo pearlhash --url "$POOL" --user "$ADDR" --worker "$W" \
  --print-time 15 --gpu-temp-limit 80 --pearlhash-kernel "${PEARL_KERNEL:-2}" $EXTRA_ARGS
RC=$?
echo "wildrig exited rc=$RC; sleeping 60s before exit"; sleep 60; exit $RC
