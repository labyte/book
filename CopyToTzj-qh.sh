#!/bin/bash

# 定义目录路径
SOUR_DIR="/book"
DEST_DIR="\\192.168.0.111\home\www"

# 删除旧目录
if [ -d "$DEST_DIR" ]; then
    echo "Deleting $DEST_DIR"
    rm -rf "$DEST_DIR"
else
    echo "$DEST_DIR does not exist."
fi

# 复制新目录到目标目录
if [ -d "$SOUR_DIR" ]; then
    echo "Copying $SOUR_DIR to $DEST_DIR"
    cp -r "$SOUR_DIR" "$DEST_DIR"
else
    echo "$SOUR_DIR does not exist."
fi

echo "Script completed."
