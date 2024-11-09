#!/bin/bash

SOCAT_PPID=$SOCAT_PPID

uptime_info=$(uptime)

uptime_seconds=$(echo $uptime_info | grep -oP '\d{2}:\d{2}:\d{2}' | cut -d: -f3)

A_result=$((SOCAT_PPID - 5))

sum=$(echo "$A_result + $uptime_seconds" | bc)

modulo=$(echo "$sum % 2" | bc)

if [ $modulo -eq 1 ]; then
    url="http://localhost:10000/index.html"
else
    url="http://localhost:10000/error.html"
fi

response=$(curl -s $url)

echo -ne "HTTP/1.1 200 OK\r\nContent-Type: text/html\r\n\r\n$response"
