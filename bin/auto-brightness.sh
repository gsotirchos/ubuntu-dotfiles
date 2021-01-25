#!/bin/bash

light_sensor="/sys/devices/platform/applesmc.768/light"
previous_new_brightness=0
cnt=0

while true; do
    # get measurement from ambient light sensor
    light_measurement="$(cat "${light_sensor}")"
    light_measurement="${light_measurement#(}"
    light_measurement="${light_measurement%,*}"  # 0~255
    new_brightness=$((light_measurement/14*5 + 10))  # 10~100
    #echo "new brightness: ${new_brightness}"
    #echo "previous new brightness: ${previous_new_brightness}"

    # get current brightness level
    current_brightness="$(xbacklight -get)"
    current_brightness="${current_brightness%.*}" # 0~100
    #echo "current brightness: ${current_brightness}"

    # if new brightness level is different from current
    if (((new_brightness - current_brightness)/10)); then
        # if this new brithtness level is the same as previously
        if ! (((new_brightness - previous_new_brightness)/10)); then
            # if this has been happening for 4 seconds
            if [[ ${cnt} == 4 ]]; then
                # adjust screen brightness
                xbacklight -set "${new_brightness}"
                previous_new_brightness=0
                cnt=0
                continue
            fi
        fi
        # remember this new brightness
        previous_new_brightness="${new_brightness}"
        cnt=$((cnt + 1))
    else
        # reset counter
        previous_new_brightness=0
        cnt=0
    fi
    #echo "counter: ${cnt}"

    sleep 1
done
