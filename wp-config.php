<?php

# Tell WordPress/PHP to get client IP address from
# X-Forwarded-For HTTP header set by Varnish
#
# SOURCES:
# http://systemsarchitect.net/boost-wordpress-performance-with-varnish-cache/
# http://ocaoimh.ie/2011/08/09/speed-up-wordpress-with-apache-and-varnish/
if ( isset( $_SERVER[ "HTTP_X_FORWARDED_FOR" ] ) ) {
	$_SERVER[ 'REMOTE_ADDR' ] = $_SERVER[ "HTTP_X_FORWARDED_FOR" ];
}
