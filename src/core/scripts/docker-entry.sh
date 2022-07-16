#!/bin/sh

WEBPHP_FIRST_TIME_SCRIPT=/webphp/custom/scripts/first-run.sh
WEBPHP_FIRST_TIME_FLAG_FILE=/webphp/custom/configs/first-run-complete.txt

if [[ ! -z $HOST_IS_LINUX ]]; then
    # Add host.docker.internal dns
    # https://github.com/docker/for-linux/issues/264#issuecomment-530743956
    ip -4 route list match 0/0 | awk '{print $3" host.docker.internal"}' >> /etc/hosts
fi

echo ""
echo "WebPHP => Clearing log files if exist ortherwise touch them.. "
echo ""

# Check if this is first time running the container and if so trigger first run scripts.
if [[ ! -f "$WEBPHP_FIRST_TIME_FLAG_FILE" ]]; then
    
    # Execute first time script.
    echo "First time => Running ${WEBPHP_FIRST_TIME_SCRIPT} script"
    echo ""
    sh $WEBPHP_FIRST_TIME_SCRIPT
    echo ""

    # Add a flag file to let this script know the already executed the first_time_run script.
    touch $WEBPHP_FIRST_TIME_FLAG_FILE

    echo "First time => First time setup complete"
    echo ""
fi

echo ""
echo ""
echo -e "Korfex - 🏳️‍🌈 Made with ❤️ & pacience, you can finally use your container now :D"
echo ""
echo ""

nginx -g 'daemon off;'
