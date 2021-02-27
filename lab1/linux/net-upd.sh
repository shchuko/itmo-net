#!/bin/bash
function setEnv {
	DEV="enp0s3"
	CONF_IP="172.16.10.50"
	CONF_MASK_SUFFIX="16"
	CONF_GATEWAY="172.16.0.1"
	CONF_DNS="172.16.255.254"
}

function setStatic {
	ip address flush dev "$DEV"
	ip address add "$CONF_IP/$CONF_MASK_SUFFIX" dev "$DEV"
	ip route add default via "$CONF_GATEWAY" dev "$DEV"
	echo "nameserver $CONF_DNS" > /etc/resolv.conf
}

function setDhcp {
	ip address flush dev "$DEV"
	dhclient "$DEV"
}

function netUpdDialog {
	read -p "Choose config [dhcp/static]: " ANSWER

	case "$ANSWER" in
	static) setStatic
		;;
	dhcp) setDhcp
		;;
	*) echo "Wrong input!"
		;;
	esac
}

setEnv
netUpdDialog

