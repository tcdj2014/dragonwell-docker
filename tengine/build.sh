#!/bin/bash

function readTag() {
    echo "请输入tag 例如0.01"
    read tag
    if [ -z "$tag" ]; then
        echo "tag未输入，默认值0.02"
        tag="0.02"
    fi
}
readTag
echo $tag
docker build -t tangxm1314/ttx:tengine.$tag .
docker push tangxm1314/ttx:tengine.$tag
docker tag tangxm1314/ttx:tengine.$tag tangxm1314/ttx:tengine.latest
docker push tangxm1314/ttx:tengine.latest