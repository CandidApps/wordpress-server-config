backend default {
  .host = "127.0.0.1";
  .port = "8080";
}

acl purge {
  "localhost";
}


# Called when a request is received
sub vcl_recv {

  # Purge WordPress requests for purge
  if (req.request == "PURGE") {
    if (!client.ip ~ purge) {
      error 405 "Not allowed.";
    }
    ban("req.url ~ ^" + req.url + "$ && req.http.host == " + req.http.host);
    error 200 "Purged.";
  }

  if (req.request != "GET" &&
      req.request != "HEAD" &&
      req.request != "PUT" &&
      req.request != "POST" &&
      req.request != "TRACE" &&
      req.request != "OPTIONS" &&
      req.request != "DELETE") {
    return (pipe);
  }

  if (req.request != "GET" && req.request != "HEAD") {
    return (pass);
  }

  #Requests for login, admin, sign up, preview, password protected posts, admin-ajax or other ajax requests
  if (req.url ~ "(wp-login|wp-admin|wp-signup|wp-comments-post.php|wp-cron.php|admin-ajax.php|xmlrpc.php|preview=true)" || req.http.Cookie ~ "(wp-postpass|wordpress_logged_in|comment_author_)" || req.http.X-Requested-With == "XMLHttpRequest" || req.url ~ "nocache" || req.url ~ "(control.php|wp-comments-post.php|wp-login.php|bb-login.php|bb-reset-password.php|register.php)") {
    return (pass);
  }

  remove req.http.cookie;
  return (lookup);

}


# Remove some unnecessary headers
sub vcl_deliver {
  remove resp.http.Server;
  remove resp.http.X-Powered-By;
  remove resp.http.X-Varnish;
  remove resp.http.Age;
  remove resp.http.Via;
}


# Called after a document has been successfully retrieved from the backend
sub vcl_fetch {

  if (beresp.status == 404 || beresp.status == 503 || beresp.status >= 500) {
    set beresp.ttl = 0m;
    return(hit_for_pass);
  }

  # Requests for login, admin, sign up, preview, password protected posts, admin-ajax or other ajax requests
  if (req.url ~ "(wp-login|wp-admin|wp-signup|wp-comments-post.php|wp-cron.php|admin-ajax.php|xmlrpc.php|preview=true)" || req.http.Cookie ~ "(wp-postpass|wordpress_logged_in|comment_author_)" || req.http.X-Requested-With == "XMLHttpRequest" || req.url ~ "nocache" || req.url ~ "(control.php|wp-comments-post.php|wp-login.php|bb-login.php|bb-reset-password.php|register.php)") {
    return (hit_for_pass);
  }

  # Don't cache .xml files (e.g. sitemap)
  if (req.url ~ "\.(xml)$") {
    set beresp.ttl = 0m;
  }

  # Cache HTML
  # if (req.url ~ "\.(html|htm)$") {
  #   set beresp.ttl = 60m;
  # }

  remove beresp.http.set-cookie;
  set beresp.ttl = 24h;
  return (deliver);

}
