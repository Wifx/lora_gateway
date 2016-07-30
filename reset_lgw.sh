#!/bin/sh

# This script performs the following actions for the LORIX One:
#       - export/unpexort GPIOA1 used to reset the SX1301 chip
#
# Usage examples:
#       ./reset_lgw.sh stop
#       ./reset_lgw.sh start

# The reset pin of SX1301 is wired with GPIOA1
SX1301_RST_PIN=1
SX1301_RST_PIN_PATH=/sys/class/gpio/pioA1

WAIT_GPIO() {
    sleep 0.1
}

iot_sk_init() {
    # setup GPIOA1
    echo $SX1301_RST_PIN > /sys/class/gpio/export; WAIT_GPIO

    # set GPIOA1 as output
    echo "out" > $SX1301_RST_PIN_PATH/direction; WAIT_GPIO

    # write output for SX1301 reset
    echo "1" > $SX1301_RST_PIN_PATH/value; WAIT_GPIO
    echo "0" > $SX1301_RST_PIN_PATH/value; WAIT_GPIO
}

iot_sk_term() {
    # cleanup GPIOA1
    if [ -d $SX1301_RST_PIN_PATH ]
    then
        # set GPIOA1 as input (then do a reset with the external pull-up)
        echo "in" > $SX1301_RST_PIN_PATH/direction; WAIT_GPIO

	# unexport GPIOA1
        echo $SX1301_RST_PIN > /sys/class/gpio/unexport; WAIT_GPIO
    fi
}

case "$1" in
    start)
    iot_sk_term
    iot_sk_init
    ;;
    stop)
    iot_sk_term
    ;;
    *)
    echo "Usage: $0 {start|stop}"
    exit 1
    ;;
esac

exit 0
