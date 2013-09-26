<?php

# Tell WordPress/PHP to get client IP address from X-Forwarded-For HTTP header set by Varnish
# http://ocaoimh.ie/2011/08/09/speed-up-wordpress-with-apache-and-varnish/
if ( isset( $_SERVER[ "HTTP_X_FORWARDED_FOR" ] ) ) {
	$_SERVER[ 'REMOTE_ADDR' ] = $_SERVER[ "HTTP_X_FORWARDED_FOR" ];
}

# Set cookie domain so that cookies aren't sent with static content
# Only works if static content is served from a different domain
define( 'COOKIE_DOMAIN', '.example.com' );

# Disable post revisions
define( 'WP_POST_REVISIONS', false );

# Set autosave interval
# define( 'AUTOSAVE_INTERVAL', 160 );

# Increase PHP memory limit
# define( 'WP_MEMORY_LIMIT', '64M' );

# Enable Multisite
# define( 'WP_ALLOW_MULTISITE', true );

# Set Akismet API Key Network-wide (WordPress Multisite)
# define('WPCOM_API_KEY','your-key');
