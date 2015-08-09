#!/bin/bash -x
#
# A helper script for ENTRYPOINT.

#!/bin/bash -x
#
# A helper script for ENTRYPOINT.
#

set -e

source /opt/rsnapshot/rsnapshot.sh

cron_rsnapshot_hourly="@hourly"

if [ -n "${CRON_HOURLY}" ]; then
  cron_rsnapshot_hourly=${CRON_HOURLY}
fi

cron_rsnapshot_daily="@daily"

if [ -n "${CRON_DAILY}" ]; then
  cron_rsnapshot_daily=${CRON_DAILY}
fi

cron_rsnapshot_weekly="@weekly"

if [ -n "${CRON_WEEKLY}" ]; then
  cron_rsnapshot_weekly=${CRON_WEEKLY}
fi

cron_rsnapshot_monthly="@monthly"

if [ -n "${CRON_MONTHLY}" ]; then
  cron_rsnapshot_monthly=${CRON_MONTHLY}
fi

crontab <<EOF
${cron_rsnapshot_hourly} rsnapshot hourly
${cron_rsnapshot_daily} rsnapshot daily
${cron_rsnapshot_weekly} rsnapshot weekly
${cron_rsnapshot_monthly} rsnapshot monthly
EOF

crontab -l

log_command=""

if [ -n "${LOG_FILE}" ]; then
  log_command=" 2>&1 | tee -a "${LOG_FILE}
fi

if [ "$1" = 'cron' ]; then
  croncommand="crond -n -x sch"${log_command}
  bash -c "${croncommand}"
fi

exec "$@"
