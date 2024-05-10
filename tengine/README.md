```shell
docker build -t tangxm1314/ttx:tengine.0.01 .
docker push tangxm1314/ttx:tengine.0.01
docker tag tangxm1314/ttx:tengine.0.01 tangxm1314/ttx:tengine.latest
docker push tangxm1314/ttx:tengine.latest
```

```shell
docker build -t registry-vpc.cn-hangzhou.aliyuncs.com/ttx/dragonwell8:8u382-b01 .
docker push registry-vpc.cn-hangzhou.aliyuncs.com/ttx/dragonwell8:8u382-b01
```

```shell
echo "Tt7711769790."|docker login --username=tangxm1314 hub.docker.com  --password-stdin
docker logout hub.docker.com
```