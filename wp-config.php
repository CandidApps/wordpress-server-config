<?php

# Tell WordPress/PHP to get client IP address from X-Forwarded-For HTTP header set by Varnish
# http://ocaoimh.ie/2011/08/09/speed-up-wordpress-with-apache-and-varnish/
if ( isset( $_SERVER[ "HTTP_X_FORWARDED_FOR" ] ) ) {
	$_SERVER[ 'REMOTE_ADDR' ] = $_SERVER[ "HTTP_X_FORWARDED_FOR" ];
}

# Set cookie domain
define( 'COOKIE_DOMAIN', '.example.com' );

# Disable post revisions
define( 'WP_POST_REVISIONS', false );

# Set autosave interval
# define( 'AUTOSAVE_INTERVAL', 160 );

# Increase PHP memory limit
# define( 'WP_MEMORY_LIMIT', '64M' );
