#!/usr/bin/env bash
start=$(date +%s)
/run/fibonacci
end=$(date +%s)
echo "Tiempo $((end - start)) en segundos"
