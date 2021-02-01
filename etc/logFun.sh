#!/usr/bin/env bash

myfun() {
    min="0.1"
    range="$(echo "1 - ${min}" | bc)"
    result="$(echo\
        "100 + ${range}*100*l((${min}*255/${range} + $1)/\
        (255/${range}))/l(10)"\
        | bc -l)"

    echo "$(printf %.$2f $(echo "${result}"))"
}

myfun "$1"
