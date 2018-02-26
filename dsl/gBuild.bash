#!/usr/bin/env bash

./gradlew clean build
# -n 1 one character
# -s silent - don't echo the key on the terminal
read -n 1 -s