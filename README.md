# docker-proxy-server

Docker用のProxyサーバー  
Mailhogも含まれています。

## First Step

JP: 初回立ち上げ時にネットワークの作成が必要なため、下記セットアップコマンドを必ず実行してください。  
EN: Be sure to execute the following setup command because you need to create a network at the first launch.

ネットワーク名`shared`が作成されます。

```bash
// First Setup 初回時のみ実行してください。
$ make setup
```

## Commands

```bash
// Docker contaienr Run
$ make run

// Docker container Down
$ make down

// Docker container Restart
$ make restart
```

## SSLを使用する場合

SSLを利用する場合は、`docker-compose.d/certs/`ディレクトリ内に、ドメイン名[.crt, .key]ファイルを入れて下さい。  
証明書を作成する場合は、Macであれば[mkcert](https://github.com/FiloSottile/mkcert)で作成すると楽です。  
`mkcert example.com localhost 127.0.0.1 192.168.1.2`

ワイルドカード付きの場合  
`mkcert "*.example.com" localhost 127.0.0.1 192.168.1.2`

mkcertで出力されたファイルの拡張子をそれぞれ変更してください。

Windowsはごめん、分からない。

## docker-compose.yml

```yml
version: '3'
services:
  proxy:
    image: jwilder/nginx-proxy
    container_name: proxy
    privileged: true
    ports:
      - '80:80'
      - '443:443'
    volumes:
      - ./docker-compose.d/certs:/etc/nginx/certs:rw
      - /etc/nginx/vhost.d
      - /usr/share/nginx/html
      - /var/run/docker.sock:/tmp/docker.sock:ro
      - ./server.conf:/etc/nginx/conf.d/server.conf
    restart: always

  mailhog:
    image: mailhog/mailhog
    container_name: mailhog
    privileged: true
    ports:
      - "8025:8025"
      - "1025:1025"
    restart: always

networks:
  default:
    external:
      name: shared
```