#!/bin/bash

light_sensor="/sys/devices/platform/applesmc.768/light"
previous_new_brightness=0
cnt=0

get_new_brightness() {
    # get measurement from ambient light sensor
    light_sensor="$1"
    light_measurement="$(cat "${light_sensor}")"
    light_measurement="${light_measurement#(}"
    light_measurement="${light_measurement%,*}"  # 0~255
    #new_brightness=$((light_measurement/14*5 + 10))  # 10~100

    min="0.1"
    range="$(echo "1 - ${min}" | bc)"
    new_brightness="$(echo\
     "100 + ${range}*100*l((${min}*255/${range} + ${light_measurement})/\
     (255/${range}))/l(10)"\
     | bc -l)"  # 10~100 logarithmic

    echo "$(printf %.$2f $(echo "${new_brightness}"))"
}

get_current_brightness() {
    # get current brightness level
    current_brightness="$(xbacklight -get)"
    current_brightness="${current_brightness%.*}" # 0~100

    echo "${current_brightness}"
}

# run once first
new_brightness="$(get_new_brightness ${light_sensor})"
xbacklight -set "${new_brightness}"

while true; do
    new_brightness="$(get_new_brightness "${light_sensor}")"
    current_brightness="$(get_current_brightness)"
    echo "new brightness: ${new_brightness}"
    echo "current brightness: ${current_brightness}"

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

    echo "previous new brightness: ${previous_new_brightness}"
    echo "counter: ${cnt}"

    sleep 1
done
