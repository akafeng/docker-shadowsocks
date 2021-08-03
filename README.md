<p align="center">
    <img src="https://user-images.githubusercontent.com/2666735/50723896-0b22d000-111f-11e9-9ee4-32914e347219.png" width="150" />
</p>

<h1 align="center">Shadowsocks</h1>

<p align="center">A secure socks5 proxy, designed to protect your Internet traffic.</p>

<p align="center">
    <a href="https://hub.docker.com/r/akafeng/shadowsocks">Docker Hub</a> ·
    <a href="https://github.com/shadowsocks/shadowsocks-libev">Project Source</a>
</p>

<p align="center">
    <img src="https://img.shields.io/docker/v/akafeng/shadowsocks?sort=semver" />
    <img src="https://img.shields.io/docker/pulls/akafeng/shadowsocks" />
    <img src="https://img.shields.io/docker/image-size/akafeng/shadowsocks??sort=semver" />
</p>

---

### Environment Variables

| Name | Value |
| --- | ---- |
| TZ | UTC |
| SERVER_ADDR | 0.0.0.0 |
| SERVER_PORT | 8388 |
| PASSWORD | [RANDOM] |
| METHOD | aes-256-gcm |
| TIMEOUT | 300 |
| DNS | 8.8.8.8,8.8.4.4 |
| OBFS | - |
| PLUGIN | - |
| PLUGIN_OBFS | - |

---

### Pull The Image

```bash
$ docker pull akafeng/shadowsocks
```

### Start Container

```bash
$ docker run -d \
  -p 8388:8388 \
  -p 8388:8388/udp \
  --restart always \
  --name=shadowsocks \
  akafeng/shadowsocks
```

### Display Config

```bash
$ docker logs shadowsocks

 [!] Server Port: 8388
 [!] Encryption Method: aes-256-gcm
 [!] Password: TO56uVUvDMGe64Ss
 [!] DNS Server: 8.8.8.8,8.8.4.4
 [+] Enjoy :)

 2020-05-01 00:00:00 INFO: enable TCP no-delay
 2020-05-01 00:00:00 INFO: using tcp fast open
 2020-05-01 00:00:00 INFO: UDP relay enabled
 2020-05-01 00:00:00 INFO: enable TCP no-delay
 2020-05-01 00:00:00 INFO: initializing ciphers... aes-256-gcm
 2020-05-01 00:00:00 INFO: using nameserver: 8.8.8.8,8.8.4.4
 2020-05-01 00:00:00 INFO: tcp server listening at 0.0.0.0:8388
 2020-05-01 00:00:00 INFO: tcp port reuse enabled
 2020-05-01 00:00:00 INFO: udp server listening at 0.0.0.0:8388
 2020-05-01 00:00:00 INFO: udp port reuse enabled
 2020-05-01 00:00:00 INFO: running from root user
```

### With simple-obfs

```bash
$ docker run -d \
  -p 443:8388 \
  -p 443:8388/udp \
  -e OBFS=tls \
  --restart always \
  --name=shadowsocks \
  akafeng/shadowsocks
```

### With v2ray-plugin

```bash
$ docker run -d \
  -p 443:8388 \
  -p 443:8388/udp \
  -e OBFS=ws \
  --restart always \
  --name=shadowsocks \
  akafeng/shadowsocks
```

---

### Thanks

- [@metowolf](http://github.com/metowolf)
