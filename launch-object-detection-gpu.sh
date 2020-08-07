#!/bin/bash
docker run \
  --gpus all \
  --privileged \
  -v ${PWD}/workspace:/workspace \
  -v ${PWD}/environment:/workspace/environment \
  -p 49001:9001 \
  -p 45901:5901 \
  -p 40080:80 \
  -p 46006:6006 \
  --name object-detection-gpu shenlanxueyuan/object-detection-gpu:latest