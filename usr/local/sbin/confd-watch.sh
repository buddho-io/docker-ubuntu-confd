#!/bin/sh

# Creates initial config with Confd and sets up Confd monitoring

#/ Usage: confd-watch -e <etcd> -c <config> 
#/   -c <config>, --conf=<config> confd config file
#/   -e <ectd>, --etcd=<ectd>     ectd ip:port pair
#/   -h, --help                   show help

set -e

usage() {
	grep "^#/" "$0" | cut -c"4-" >&2
    exit "$1"
}

while [ "$#" -gt 0 ]
do
	case "$1" in
		-c|--conf) CONF="$2" shift 2;;
		-c*) CONF="$(echo "$1" | cut -c"3-")" shift;;
		--conf=*) CONF="$(echo "$1" | cut -c"8-")" shift;;
		-e|--etcd) ETCD="$2" shift 2;;
		-e*) ETCD="$(echo "$1" | cut -c"3-")" shift;;
		-h|--help) usage 0;;
		--etcd=*) ECTD="$(echo "$1" | cut -c"8-")" shift;;
		-*) echo "# [confd-watch] unknown switch: $1" >&2;;
		*) break;;
done

echo "[confd-watch] using ectd node: $ETCD."

# Try to make initial configuration every 5 seconds until successful
until /usr/local/sbin/confd -onetime -node $ETCD -config-file $CONF; do
    echo "[confd-watch] waiting for confd to create initial configuration."
    sleep 5
done

# Put a continual polling `confd` process into the background to watch
# for changes every 10 seconds
/usr/local/sbin/confd -interval 10 -node $ETCD -config-file $CONF &
echo "[confd-watch] confd is now monitoring etcd for changes..."

