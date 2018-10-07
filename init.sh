#!/bin/bash

# export environment variables from env.conf
while IFS= read -r line; do
    export "$line"
done < /usr/local/etc/consul/env.conf

# get physical IP address
IP=$(/sbin/ip -f inet -o addr show $NET_INTERFACE | cut -d\  -f 7 | cut -d/ -f 1)

# run Consul as her role
if [ $CONSUL_ROLE = "server" ]; then
  if [ $CONSUL_IS_INIT_SERVER = 1 ]; then
    echo "Consul is running as a server (init)"
    /usr/local/bin/consul agent \
    -advertise $IP \
    -bind 0.0.0.0 \
    -bootstrap-expect 1 \
    -client 0.0.0.0 \
    -datacenter $CONSUL_DATACENTER \
    -data-dir "/tmp/consul" \
    -server \
    -ui
  else
    echo "Consul is running as a server (join)"
    /usr/local/bin/consul agent \
    -advertise $IP \
    -bind 0.0.0.0 \
    -bootstrap-expect 1 \
    -client 0.0.0.0 \
    -datacenter $CONSUL_DATACENTER \
    -data-dir "/tmp/consul" \
    -server \
    -join $CONSUL_INIT_SERVER_IP
  fi
else
  echo "Consul is running as a client"
  /usr/local/bin/consul agent \
  -advertise $IP \
  -bind 0.0.0.0 \
  -client 0.0.0.0 \
  -datacenter $CONSUL_DATACENTER \
  -data-dir "/tmp/consul" \
  -join $CONSUL_INIT_SERVER_IP
fi
