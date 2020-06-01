#!/bin/sh
wget --spider --no-verbose  -o wget.log  -e robots=off --wait 0.01 -r -p http://localhost:1313/docs | grep 404