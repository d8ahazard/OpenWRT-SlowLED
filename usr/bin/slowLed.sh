#!/bin/sh

# Set default values for LED configuration
RED_FADE_DELAY=0       # in milliseconds
RED_FADE_IN_TIME=5000  # in milliseconds
RED_HOLD_TIME=0        # in milliseconds
RED_FADE_OUT_TIME=5000 # in milliseconds
RED_MAX_BRIGHTNESS=128

GREEN_FADE_DELAY=0       # in milliseconds
GREEN_FADE_IN_TIME=5000  # in milliseconds
GREEN_HOLD_TIME=0        # in milliseconds
GREEN_FADE_OUT_TIME=5000 # in milliseconds
GREEN_MAX_BRIGHTNESS=128

BLUE_FADE_DELAY=0       # in milliseconds
BLUE_FADE_IN_TIME=5000  # in milliseconds
BLUE_HOLD_TIME=0        # in milliseconds
BLUE_FADE_OUT_TIME=5000 # in milliseconds
BLUE_MAX_BRIGHTNESS=128

if [ -f "/etc/slowled.conf" ]; then
  LED_CONFIG=$(cat /etc/slowled.conf)

  RED_FADE_DELAY=$(echo "$LED_CONFIG" | grep -o 'red_fade_in_delay=[^,]*' | cut -d= -f2)
  RED_FADE_IN_TIME=$(echo "$LED_CONFIG" | grep -o 'red_fade_in_time=[^,]*' | cut -d= -f2)
  RED_HOLD_TIME=$(echo "$LED_CONFIG" | grep -o 'red_fade_hold_time=[^,]*' | cut -d= -f2)
  RED_FADE_OUT_TIME=$(echo "$LED_CONFIG" | grep -o 'red_fade_out_time=[^,]*' | cut -d= -f2)
  RED_MAX_BRIGHTNESS=$(echo "$LED_CONFIG" | grep -o 'red_max_brightness=[^,]*' | cut -d= -f2)

  GREEN_FADE_DELAY=$(echo "$LED_CONFIG" | grep -o 'green_fade_in_delay=[^,]*' | cut -d= -f2)
  GREEN_FADE_IN_TIME=$(echo "$LED_CONFIG" | grep -o 'green_fade_in_time=[^,]*' | cut -d= -f2)
  GREEN_HOLD_TIME=$(echo "$LED_CONFIG" | grep -o 'green_fade_hold_time=[^,]*' | cut -d= -f2)
  GREEN_FADE_OUT_TIME=$(echo "$LED_CONFIG" | grep -o 'green_fade_out_time=[^,]*' | cut -d= -f2)
  GREEN_MAX_BRIGHTNESS=$(echo "$LED_CONFIG" | grep -o 'green_max_brightness=[^,]*' | cut -d= -f2)

  BLUE_FADE_DELAY=$(echo "$LED_CONFIG" | grep -o 'blue_fade_in_delay=[^,]*' | cut -d= -f2)
  BLUE_FADE_IN_TIME=$(echo "$LED_CONFIG" | grep -o 'blue_fade_in_time=[^,]*' | cut -d= -f2)
  BLUE_HOLD_TIME=$(echo "$LED_CONFIG" | grep -o 'blue_fade_hold_time=[^,]*' | cut -d= -f2)
  BLUE_FADE_OUT_TIME=$(echo "$LED_CONFIG" | grep -o 'blue_fade_out_time=[^,]*' | cut -d= -f2)
  BLUE_MAX_BRIGHTNESS=$(echo "$LED_CONFIG" | grep -o 'blue_max_brightness=[^,]*' | cut -d= -f2)
fi

echo "RED_FADE_DELAY: $RED_FADE_DELAY"
echo "RED_FADE_IN_TIME: $RED_FADE_IN_TIME"
echo "RED_HOLD_TIME: $RED_HOLD_TIME"
echo "RED_FADE_OUT_TIME: $RED_FADE_OUT_TIME"
echo "RED_MAX_BRIGHTNESS: $RED_MAX_BRIGHTNESS"

echo "GREEN_FADE_DELAY: $GREEN_FADE_DELAY"
echo "GREEN_FADE_IN_TIME: $GREEN_FADE_IN_TIME"
echo "GREEN_HOLD_TIME: $GREEN_HOLD_TIME"
echo "GREEN_FADE_OUT_TIME: $GREEN_FADE_OUT_TIME"
echo "GREEN_MAX_BRIGHTNESS: $GREEN_MAX_BRIGHTNESS"

echo "BLUE_FADE_DELAY: $BLUE_FADE_DELAY"
echo "BLUE_FADE_IN_TIME: $BLUE_FADE_IN_TIME"
echo "BLUE_HOLD_TIME: $BLUE_HOLD_TIME"
echo "BLUE_FADE_OUT_TIME: $BLUE_FADE_OUT_TIME"
echo "BLUE_MAX_BRIGHTNESS: $BLUE_MAX_BRIGHTNESS"


# Set initial brightness to 0
echo 0 >/sys/class/leds/LED0_Red/brightness
echo 0 >/sys/class/leds/LED0_Green/brightness
echo 0 >/sys/class/leds/LED0_Blue/brightness

RED_LAST_CHANGE_TIME=0
GREEN_LAST_CHANGE_TIME=0
BLUE_LAST_CHANGE_TIME=0

# Start the while loop to continuously update the LEDs
# Get the current time in seconds
CURRENT_TIME=$(date +%s)

# Determine state of red LED
if [ $RED_LAST_CHANGE_TIME -le $RED_FADE_DELAY ]; then
  # LED is delayed, set brightness to 0
  echo 0 >/sys/class/leds/LED0_Red/brightness
elif [ $RED_LAST_CHANGE_TIME -le $(expr $RED_FADE_DELAY + $RED_FADE_IN_TIME) ]; then
  # LED is fading in
  percent_done=$(expr \( $RED_LAST_CHANGE_TIME - $RED_FADE_DELAY \) \* 100 / $RED_FADE_IN_TIME)
  brightness=$(expr $RED_MAX_BRIGHTNESS \* $percent_done / 100)
  echo $brightness >/sys/class/leds/LED0_Red/brightness
elif [ $RED_LAST_CHANGE_TIME -le $(expr $RED_FADE_DELAY + $RED_FADE_IN_TIME + $RED_HOLD_TIME) ]; then
  # LED is holding at max brightness
  echo $RED_MAX_BRIGHTNESS >/sys/class/leds/LED0_Red/brightness
elif [ $RED_LAST_CHANGE_TIME -le $(expr $RED_FADE_DELAY + $RED_FADE_IN_TIME + $RED_HOLD_TIME + $RED_FADE_OUT_TIME) ]; then
  # LED is fading out
  percent_done=$(expr \( $RED_LAST_CHANGE_TIME - $RED_FADE_DELAY - $RED_FADE_IN_TIME - $RED_HOLD_TIME \) \* 100 / $RED_FADE_OUT_TIME)
  brightness=$(expr $RED_MAX_BRIGHTNESS - \( $RED_MAX_BRIGHTNESS \* $percent_done / 100 \))
  echo $brightness >/sys/class/leds/LED0_Red/brightness
else
  # Reset timer and start over
  RED_LAST_CHANGE_TIME=0
fi

# Determine state of green LED
if [ $GREEN_LAST_CHANGE_TIME -le $GREEN_FADE_DELAY ]; then
  # LED is delayed, set brightness to 0
  echo 0 >/sys/class/leds/LED0_Green/brightness
elif [ $GREEN_LAST_CHANGE_TIME -le $(expr $GREEN_FADE_DELAY + $GREEN_FADE_IN_TIME) ]; then
  # LED is fading in
  percent_done=$(expr \( $GREEN_LAST_CHANGE_TIME - $GREEN_FADE_DELAY \) \* 100 / $GREEN_FADE_IN_TIME)
  brightness=$(expr $GREEN_MAX_BRIGHTNESS \* $percent_done / 100)
  echo $brightness >/sys/class/leds/LED0_Green/brightness
elif [ $GREEN_LAST_CHANGE_TIME -le $(expr $GREEN_FADE_DELAY + $GREEN_FADE_IN_TIME + $GREEN_HOLD_TIME) ]; then
  # LED is holding at max brightness
  echo $GREEN_MAX_BRIGHTNESS >/sys/class/leds/LED0_Green/brightness
elif [ $GREEN_LAST_CHANGE_TIME -le $(expr $GREEN_FADE_DELAY + $GREEN_FADE_IN_TIME + $GREEN_HOLD_TIME + $GREEN_FADE_OUT_TIME) ]; then
  # LED is fading out
  percent_done=$(expr \( $GREEN_LAST_CHANGE_TIME - $GREEN_FADE_DELAY - $GREEN_FADE_IN_TIME - $GREEN_HOLD_TIME \) \* 100 / $GREEN_FADE_OUT_TIME)
  brightness=$(expr $GREEN_MAX_BRIGHTNESS - \( $GREEN_MAX_BRIGHTNESS \* $percent_done / 100 \))
  echo $brightness >/sys/class/leds/LED0_Green/brightness
else
  # Reset timer and start over
  GREEN_LAST_CHANGE_TIME=0
fi

# Determine state of blue LED
if [ $BLUE_LAST_CHANGE_TIME -le $BLUE_FADE_DELAY ]; then
  # LED is delayed, set brightness to 0
  echo 0 >/sys/class/leds/LED0_Blue/brightness
elif [ $BLUE_LAST_CHANGE_TIME -le $(expr $BLUE_FADE_DELAY + $BLUE_FADE_IN_TIME) ]; then
  # LED is fading in
  percent_done=$(expr \( $BLUE_LAST_CHANGE_TIME - $BLUE_FADE_DELAY \) \* 100 / $BLUE_FADE_IN_TIME)
  brightness=$(expr $BLUE_MAX_BRIGHTNESS \* $percent_done / 100)
  echo $brightness >/sys/class/leds/LED0_Blue/brightness
elif [ $BLUE_LAST_CHANGE_TIME -le $(expr $BLUE_FADE_DELAY + $BLUE_FADE_IN_TIME + $BLUE_HOLD_TIME) ]; then
  # LED is holding at max brightness
  echo $BLUE_MAX_BRIGHTNESS >/sys/class/leds/LED0_Blue/brightness
elif [ $BLUE_LAST_CHANGE_TIME -le $(expr $BLUE_FADE_DELAY + $BLUE_FADE_IN_TIME + $BLUE_HOLD_TIME + $BLUE_FADE_OUT_TIME) ]; then
  # LED is fading out
  percent_done=$(expr \( $BLUE_LAST_CHANGE_TIME - $BLUE_FADE_DELAY - $BLUE_FADE_IN_TIME - $BLUE_HOLD_TIME \) \* 100 / $BLUE_FADE_OUT_TIME)
  brightness=$(expr $BLUE_MAX_BRIGHTNESS - \( $BLUE_MAX_BRIGHTNESS \* $percent_done / 100 \))
  echo $brightness >$BLUE_PATH/brightness
else
  # Reset timer and start over
  BLUE_LAST_CHANGE_TIME=0
fi
