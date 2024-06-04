#! /bin/sh

set -e

# Validate SOURCE environment variables
if [ -z "${MC_SOURCE_EP_HOST}" ]; then
  echo "Error: You did not set the MC_SOURCE_EP_HOST environment variable."
  exit 1
fi
if [ -z "${MC_SOURCE_EP_ACCESS_KEY}" ]; then
  echo "Error: You did not set the MC_SOURCE_EP_ACCESS_KEY environment variable."
  exit 1
fi
if [ -z "${MC_SOURCE_EP_SECRET_KEY}" ]; then
  echo "Error: You did not set the MC_SOURCE_EP_SECRET_KEY environment variable."
  exit 1
fi

# Validate DESTINATION environment variables
if [ -z "${MC_DEST_EP_HOST}" ]; then
  echo "Error: You did not set the MC_DEST_EP_HOST environment variable."
  exit 1
fi
if [ -z "${MC_DEST_EP_ACCESS_KEY}" ]; then
  echo "Error: You did not set the MC_DEST_EP_ACCESS_KEY environment variable."
  exit 1
fi
if [ -z "${MC_DEST_EP_SECRET_KEY}" ]; then
  echo "Error: You did not set the MC_DEST_EP_SECRET_KEY environment variable."
  exit 1
fi

# MC arguments
# --insecure
MC_ARGS=""
if [ ${MC_INSECURE} -eq 1 ]; then
  MC_ARGS="--insecure $MC_ARGS"
fi

# MC mirror arguments
# --overwrite
MC_ARGS="$MC_ARGS mirror"
if [ ${MC_MIRROR_OVERWRITE} -eq 1 ]; then
  MC_ARGS="$MC_ARGS --overwrite"
fi
MC_ARGS="$MC_ARGS source destination"

# Create mc aliases
./mc alias set source "${MC_SOURCE_EP_HOST}" "${MC_SOURCE_EP_ACCESS_KEY}" "${MC_SOURCE_EP_SECRET_KEY}"
./mc alias set destination "${MC_DEST_EP_HOST}" "${MC_DEST_EP_ACCESS_KEY}" "${MC_DEST_EP_SECRET_KEY}"


echo "Mirroring buckets from ${MC_SOURCE_EP_HOST} to ${MC_DEST_EP_HOST}..."
echo $MC_ARGS | xargs ./mc

if [ $? != 0 ]; then
  >&2 echo "Error in migarating files from ${MC_SOURCE_EP_HOST} to ${MC_DEST_EP_HOST}!"
  exit 1
fi