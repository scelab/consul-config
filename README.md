# Config files for Consul on Sota

## 概要
ConsulをサーバマシンとSotaで動かすときのコンフィグ集です。Consulがサービスとして動作するようにできます。

## サーバマシンでの設定（Consul Serverとして設定）

- OS: Ubuntu Server 18.04.1 LTS
- ローカルに`init.sh`と`env.conf`と`consul.service`をダウンロードしておく。

```
$ sudo apt install -y unzip
$ curl -O -L https://releases.hashicorp.com/consul/1.2.3/consul_1.2.3_linux_amd64.zip
$ unzip consul_1.2.3_linux_amd64.zip 
$ sudo mv consul /usr/local/bin/
$ sudo chmod +x /usr/local/bin/consul 
$ sudo mkdir /usr/local/etc/consul
$ sudo mv init.sh /usr/local/etc/consul/
$ sudo chmod +x /usr/local/etc/consul/init.sh
$ sudo mv env.conf /usr/local/etc/consul/
$ # env.confを編集する（後述）
$ sudo mv consul.service /etc/systemd/system/consul.service
$ sudo systemctl daemon-reload
$ sudo systemctl start consul
```

## Sotaでの設定（Consul Clientとして設定）

- ローカルに`init.sh`と`env.conf`と`consul.service`をダウンロードしておく。

```
$ curl -O -L https://releases.hashicorp.com/consul/1.2.3/consul_1.2.3_linux_386.zip
$ unzip consul_1.2.3_linux_386.zip
$ mv consul /usr/local/bin/
$ chmod +x /usr/local/bin/consul 
$ mkdir /usr/local/etc/consul
$ mv init.sh /usr/local/etc/consul/
$ chmod +x /usr/local/etc/consul/init.sh
$ mv env.conf /usr/local/etc/consul/
$ # env.confを編集する（後述）
$ mv consul.service /etc/systemd/system/consul.service
$ systemctl daemon-reload
$ systemctl start consul
```

## env.confの書き方

- NET_INTERFACE
  - ルータから割り当てられたIPアドレスが当たっているインタフェース名を指定する
  - 例：enp1s0、wlan0
- CONSUL_DATACENTER
  - Consulのデータセンター名を指定する
  - 例：dc1（Consulのデフォルト）
- CONSUL_ROLE
  - ConsulをServerで動かすかClientで動かすかを指定する
  - 例：server、client
- CONSUL_IS_INIT_SERVER
  - Consulをはじめてサーバとして起動するかどうかを指定する
  - 最初に起動するサーバ以外はすでに起動しているサーバにjoinする
  - 例：1、0
- CONSUL_INIT_SERVER_IP
  - Joinするサーバ（=最初に起動したサーバ）のIPアドレスを指定する
  - 例：192.168.11.2
