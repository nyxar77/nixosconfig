{...}: {
  services.httpd = {
    enable = true;
    enablePHP = true;
    virtualHosts = {
      "beta.progresso.com" = {
        # addSSL = true;
        documentRoot = "/srv/http/progresso";
        extraConfig = ''
          <Directory "/srv/http/progresso">
            Require all granted
            AllowOverride All
          </Directory>
        '';
      };
    };
  };
}
/*
   configFile = pkgs.writeText "httpd.conf" ''

  ServerRoot /nix/store/as5ccnmclzzbxcr5mhd8c2ky43k85gjl-apache-httpd-2.4.65
  ServerName nixos
  DefaultRuntimeDir /run/httpd/runtime

  PidFile /run/httpd/httpd.pid

  # mod_cgid requires this.
  ScriptSock /run/httpd/cgisock


  <IfModule prefork.c>
      MaxClients           150
      MaxRequestsPerChild  0
  </IfModule>

  Listen *:80 http

  User wwwrun
  Group wwwrun

  LoadModule authn_core_module /nix/store/as5ccnmclzzbxcr5mhd8c2ky43k85gjl-apache-httpd-2.4.65/modules/mod_authn_core.so
  LoadModule authz_core_module /nix/store/as5ccnmclzzbxcr5mhd8c2ky43k85gjl-apache-httpd-2.4.65/modules/mod_authz_core.so
  LoadModule log_config_module /nix/store/as5ccnmclzzbxcr5mhd8c2ky43k85gjl-apache-httpd-2.4.65/modules/mod_log_config.so
  LoadModule mime_module /nix/store/as5ccnmclzzbxcr5mhd8c2ky43k85gjl-apache-httpd-2.4.65/modules/mod_mime.so
  LoadModule autoindex_module /nix/store/as5ccnmclzzbxcr5mhd8c2ky43k85gjl-apache-httpd-2.4.65/modules/mod_autoindex.so
  LoadModule negotiation_module /nix/store/as5ccnmclzzbxcr5mhd8c2ky43k85gjl-apache-httpd-2.4.65/modules/mod_negotiation.so
  LoadModule dir_module /nix/store/as5ccnmclzzbxcr5mhd8c2ky43k85gjl-apache-httpd-2.4.65/modules/mod_dir.so
  LoadModule alias_module /nix/store/as5ccnmclzzbxcr5mhd8c2ky43k85gjl-apache-httpd-2.4.65/modules/mod_alias.so
  LoadModule rewrite_module /nix/store/as5ccnmclzzbxcr5mhd8c2ky43k85gjl-apache-httpd-2.4.65/modules/mod_rewrite.so
  LoadModule unixd_module /nix/store/as5ccnmclzzbxcr5mhd8c2ky43k85gjl-apache-httpd-2.4.65/modules/mod_unixd.so
  LoadModule slotmem_shm_module /nix/store/as5ccnmclzzbxcr5mhd8c2ky43k85gjl-apache-httpd-2.4.65/modules/mod_slotmem_shm.so
  LoadModule socache_shmcb_module /nix/store/as5ccnmclzzbxcr5mhd8c2ky43k85gjl-apache-httpd-2.4.65/modules/mod_socache_shmcb.so
  LoadModule mpm_event_module /nix/store/as5ccnmclzzbxcr5mhd8c2ky43k85gjl-apache-httpd-2.4.65/modules/mod_mpm_event.so
  LoadModule cgid_module /nix/store/as5ccnmclzzbxcr5mhd8c2ky43k85gjl-apache-httpd-2.4.65/modules/mod_cgid.so
  LoadModule http2_module /nix/store/as5ccnmclzzbxcr5mhd8c2ky43k85gjl-apache-httpd-2.4.65/modules/mod_http2.so
  LoadModule php_module /nix/store/n79i2pimxwfwn4anrvw29kkvdfrx39i5-php-with-extensions-8.4.12/modules/libphp.so
  LoadModule auth_basic_module /nix/store/as5ccnmclzzbxcr5mhd8c2ky43k85gjl-apache-httpd-2.4.65/modules/mod_auth_basic.so
  LoadModule auth_digest_module /nix/store/as5ccnmclzzbxcr5mhd8c2ky43k85gjl-apache-httpd-2.4.65/modules/mod_auth_digest.so
  LoadModule authn_file_module /nix/store/as5ccnmclzzbxcr5mhd8c2ky43k85gjl-apache-httpd-2.4.65/modules/mod_authn_file.so
  LoadModule authn_dbm_module /nix/store/as5ccnmclzzbxcr5mhd8c2ky43k85gjl-apache-httpd-2.4.65/modules/mod_authn_dbm.so
  LoadModule authn_anon_module /nix/store/as5ccnmclzzbxcr5mhd8c2ky43k85gjl-apache-httpd-2.4.65/modules/mod_authn_anon.so
  LoadModule authz_user_module /nix/store/as5ccnmclzzbxcr5mhd8c2ky43k85gjl-apache-httpd-2.4.65/modules/mod_authz_user.so
  LoadModule authz_groupfile_module /nix/store/as5ccnmclzzbxcr5mhd8c2ky43k85gjl-apache-httpd-2.4.65/modules/mod_authz_groupfile.so
  LoadModule authz_host_module /nix/store/as5ccnmclzzbxcr5mhd8c2ky43k85gjl-apache-httpd-2.4.65/modules/mod_authz_host.so
  LoadModule ext_filter_module /nix/store/as5ccnmclzzbxcr5mhd8c2ky43k85gjl-apache-httpd-2.4.65/modules/mod_ext_filter.so
  LoadModule include_module /nix/store/as5ccnmclzzbxcr5mhd8c2ky43k85gjl-apache-httpd-2.4.65/modules/mod_include.so
  LoadModule env_module /nix/store/as5ccnmclzzbxcr5mhd8c2ky43k85gjl-apache-httpd-2.4.65/modules/mod_env.so
  LoadModule mime_magic_module /nix/store/as5ccnmclzzbxcr5mhd8c2ky43k85gjl-apache-httpd-2.4.65/modules/mod_mime_magic.so
  LoadModule cern_meta_module /nix/store/as5ccnmclzzbxcr5mhd8c2ky43k85gjl-apache-httpd-2.4.65/modules/mod_cern_meta.so
  LoadModule expires_module /nix/store/as5ccnmclzzbxcr5mhd8c2ky43k85gjl-apache-httpd-2.4.65/modules/mod_expires.so
  LoadModule headers_module /nix/store/as5ccnmclzzbxcr5mhd8c2ky43k85gjl-apache-httpd-2.4.65/modules/mod_headers.so
  LoadModule usertrack_module /nix/store/as5ccnmclzzbxcr5mhd8c2ky43k85gjl-apache-httpd-2.4.65/modules/mod_usertrack.so
  LoadModule setenvif_module /nix/store/as5ccnmclzzbxcr5mhd8c2ky43k85gjl-apache-httpd-2.4.65/modules/mod_setenvif.so
  LoadModule dav_module /nix/store/as5ccnmclzzbxcr5mhd8c2ky43k85gjl-apache-httpd-2.4.65/modules/mod_dav.so
  LoadModule status_module /nix/store/as5ccnmclzzbxcr5mhd8c2ky43k85gjl-apache-httpd-2.4.65/modules/mod_status.so
  LoadModule asis_module /nix/store/as5ccnmclzzbxcr5mhd8c2ky43k85gjl-apache-httpd-2.4.65/modules/mod_asis.so
  LoadModule info_module /nix/store/as5ccnmclzzbxcr5mhd8c2ky43k85gjl-apache-httpd-2.4.65/modules/mod_info.so
  LoadModule dav_fs_module /nix/store/as5ccnmclzzbxcr5mhd8c2ky43k85gjl-apache-httpd-2.4.65/modules/mod_dav_fs.so
  LoadModule vhost_alias_module /nix/store/as5ccnmclzzbxcr5mhd8c2ky43k85gjl-apache-httpd-2.4.65/modules/mod_vhost_alias.so
  LoadModule imagemap_module /nix/store/as5ccnmclzzbxcr5mhd8c2ky43k85gjl-apache-httpd-2.4.65/modules/mod_imagemap.so
  LoadModule actions_module /nix/store/as5ccnmclzzbxcr5mhd8c2ky43k85gjl-apache-httpd-2.4.65/modules/mod_actions.so
  LoadModule speling_module /nix/store/as5ccnmclzzbxcr5mhd8c2ky43k85gjl-apache-httpd-2.4.65/modules/mod_speling.so
  LoadModule proxy_module /nix/store/as5ccnmclzzbxcr5mhd8c2ky43k85gjl-apache-httpd-2.4.65/modules/mod_proxy.so
  LoadModule proxy_http_module /nix/store/as5ccnmclzzbxcr5mhd8c2ky43k85gjl-apache-httpd-2.4.65/modules/mod_proxy_http.so
  LoadModule cache_module /nix/store/as5ccnmclzzbxcr5mhd8c2ky43k85gjl-apache-httpd-2.4.65/modules/mod_cache.so
  LoadModule cache_disk_module /nix/store/as5ccnmclzzbxcr5mhd8c2ky43k85gjl-apache-httpd-2.4.65/modules/mod_cache_disk.so
  LoadModule access_compat_module /nix/store/as5ccnmclzzbxcr5mhd8c2ky43k85gjl-apache-httpd-2.4.65/modules/mod_access_compat.so

  AddHandler type-map var

  <Files ~ "^\.ht">
      Require all denied
  </Files>

  TypesConfig /nix/store/as5ccnmclzzbxcr5mhd8c2ky43k85gjl-apache-httpd-2.4.65/conf/mime.types

  AddType application/x-x509-ca-cert .crt
  AddType application/x-pkcs7-crl    .crl
  AddType application/x-httpd-php    .php .phtml

  <IfModule mod_mime_magic.c>
      MIMEMagicFile /nix/store/as5ccnmclzzbxcr5mhd8c2ky43k85gjl-apache-httpd-2.4.65/conf/magic
  </IfModule>

  ErrorLog /var/log/httpd/error.log

  LogLevel notice

  LogFormat "%h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\"" combined
  LogFormat "%h %l %u %t \"%r\" %>s %b" common
  LogFormat "%{Referer}i -> %U" referer
  LogFormat "%{User-agent}i" agent

  CustomLog /var/log/httpd/access.log common

  <IfModule mod_setenvif.c>
      BrowserMatch "Mozilla/2" nokeepalive
      BrowserMatch "MSIE 4\.0b2;" nokeepalive downgrade-1.0 force-response-1.0
      BrowserMatch "RealPlayer 4\.0" force-response-1.0
      BrowserMatch "Java/1\.0" force-response-1.0
      BrowserMatch "JDK/1\.0" force-response-1.0
      BrowserMatch "Microsoft Data Access Internet Publishing Provider" redirect-carefully
      BrowserMatch "^WebDrive" redirect-carefully
      BrowserMatch "^WebDAVFS/1.[012]" redirect-carefully
      BrowserMatch "^gnome-vfs" redirect-carefully
  </IfModule>


  Include /nix/store/as5ccnmclzzbxcr5mhd8c2ky43k85gjl-apache-httpd-2.4.65/conf/extra/httpd-default.conf
  Include /nix/store/as5ccnmclzzbxcr5mhd8c2ky43k85gjl-apache-httpd-2.4.65/conf/extra/httpd-autoindex.conf
  Include /nix/store/as5ccnmclzzbxcr5mhd8c2ky43k85gjl-apache-httpd-2.4.65/conf/extra/httpd-multilang-errordoc.conf
  Include /nix/store/as5ccnmclzzbxcr5mhd8c2ky43k85gjl-apache-httpd-2.4.65/conf/extra/httpd-languages.conf

  TraceEnable off

  <IfModule mod_ssl.c>
      SSLSessionCache shmcb:/run/httpd/ssl_scache(512000)

      Mutex posixsem

      SSLRandomSeed startup builtin
      SSLRandomSeed connect builtin

      SSLProtocol All -SSLv2 -SSLv3 -TLSv1 -TLSv1.1
      SSLCipherSuite HIGH:!aNULL:!MD5:!EXP
      SSLHonorCipherOrder on
  </IfModule>




  # Fascist default - deny access to everything.
  <Directory />
      Options FollowSymLinks
      AllowOverride None
      Require all denied
  </Directory>

  <Directory "/srv/http">
      Options Indexes FollowSymLinks
      AllowOverride All
      Require all granted
  </Directory>


  # But do allow access to files in the store so that we don't have
  # to generate <Directory> clauses for every generated file that we
  # want to serve.
  <Directory /nix/store>
      Require all granted
  </Directory>


  <VirtualHost *:80>
      ServerName localhost


      <IfModule mod_ssl.c>
          SSLEngine off
      </IfModule>

      ErrorLog /var/log/httpd/error-localhost.log
  CustomLog /var/log/httpd/access-localhost.log common




  DocumentRoot /srv/http

  <Files "*.json">
    Header set Access-Control-Allow-Origin "*"
  </Files>

  <Directory "/nix/store/as5ccnmclzzbxcr5mhd8c2ky43k85gjl-apache-httpd-2.4.65/htdocs">
      Options Indexes FollowSymLinks
      AllowOverride None
      Require all granted
  </Directory>



  </VirtualHost>
'';
*/

