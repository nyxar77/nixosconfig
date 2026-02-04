{...}: {
  services.httpd = {
    enable = true;
    enablePHP = true;
    virtualHosts = {
      "nix.progresso.com" = {
        # addSSL = true;
        documentRoot = "/srv/http/progresso";
        extraConfig = ''
          <Directory "/srv/http/progresso">
            Require all granted
            AllowOverride All
          </Directory>
        '';
      };

      "nix.githubfetcher.com" = {
        # addSSL = true;
        documentRoot = "/srv/http/githubFetcher";
        extraConfig = ''
          <Directory "/srv/http/progresso">
            Require all granted
            AllowOverride All

            <IfModule mod_rewrite.c>
              RewriteEngine On
              RewriteBase /

              # If the request is for an existing file or folder, serve it
              RewriteCond %{REQUEST_FILENAME} -f [OR]
              RewriteCond %{REQUEST_FILENAME} -d
              RewriteRule ^ - [L]

              # Otherwise, send everything to index.html
              RewriteRule ^ index.html [L]
            </IfModule>

          </Directory>
        '';
      };
    };
  };
}
