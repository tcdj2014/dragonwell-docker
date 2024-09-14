```shell
git tag -d v0.2 \
&& git push origin --delete tag v0.2 \
&& git tag -a v0.2 -m "8.20.21" \
&& git push origin v0.2
```

```shell
git tag -d v0.1
git push origin --delete tag v0.1
```

```shell
git tag -d v0.1 \
&& git push origin --delete tag v0.1 \
&& git tag -a v0.1 -m "初始化" \
&& git push origin v0.1
```

```shell
docker build -t dragonwell8:latest .
```

```shell
docker build -t registry-vpc.cn-hangzhou.aliyuncs.com/ttx/dragonwell8:8u382-b01 .
docker push registry-vpc.cn-hangzhou.aliyuncs.com/ttx/dragonwell8:8u382-b01
```