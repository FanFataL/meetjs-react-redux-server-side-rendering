#!/bin/sh

# Convert environment variables in the conf to fixed entries
# http://stackoverflow.com/questions/21056450/how-to-inject-environment-variables-in-varnish-configuration
for name in SERVER_PORT_3000_TCP_ADDR SERVER_PORT_3000_TCP_PORT
do
    eval value=\$$name
    sed -i "s|\${${name}}|${value}|g" /etc/varnish/default.vcl
done

# Start varnish and log
varnishd -f /etc/varnish/default.vcl -s malloc,100M -a 0.0.0.0:${VARNISH_PORT}
echo "Varnish running"
varnishlog -c -m 'RxURL:^/$'
