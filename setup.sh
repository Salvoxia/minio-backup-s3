#!/usr/bin/env sh

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


# Create mc aliases
./mc alias set source "${MC_SOURCE_EP_HOST}" "${MC_SOURCE_EP_ACCESS_KEY}" "${MC_SOURCE_EP_SECRET_KEY}"
./mc alias set destination "${MC_DEST_EP_HOST}" "${MC_DEST_EP_ACCESS_KEY}" "${MC_DEST_EP_SECRET_KEY}"

if [ ! -z "${CRON_EXPRESSION}" ]; then
    # Reset crontab
    crontab -r
    echo "${CRON_EXPRESSION} /run.sh > /proc/1/fd/1 2>/proc/1/fd/2" | crontab -
    # Make environment variables accessible to cron
    printenv > /etc/environment
    crond -f
else
  /run.sh
fi



