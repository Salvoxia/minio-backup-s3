#!/usr/bin/env sh

set -e

# MC arguments
# --insecure
MC_ARGS=""
if [ ! -z "${MC_INSECURE}" ] && [ "${MC_INSECURE}" -eq "1" ]; then
  MC_ARGS="--insecure ${MC_ARGS}"
fi

# MC mirror arguments
# --overwrite
MC_ARGS="${MC_ARGS} mirror"
if [ ! -z ${MC_MIRROR_OVERWRITE} ] && [ "${MC_MIRROR_OVERWRITE}" -eq "1" ]; then
  MC_ARGS="${MC_ARGS} --overwrite"
fi
MC_ARGS="${MC_ARGS} source destination"

echo "Mirroring buckets from ${MC_SOURCE_EP_HOST} to ${MC_DEST_EP_HOST}..."
echo "${MC_ARGS}" | xargs /mc

if [ $? != 0 ]; then
  >&2 echo "Error mirroring files from ${MC_SOURCE_EP_HOST} to ${MC_DEST_EP_HOST}!"
  exit 1
fi