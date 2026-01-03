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
