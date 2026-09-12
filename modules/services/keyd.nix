{
  services.keyd = {
    enable = true;
    keyboards = {
      default = {
        ids = [ "*" ];
        settings = {
          main = {
            capslock = "leftcontrol";
            grave = "esc";
            esc = "layer(nav)";
          };
          nav = {
            h = "left";
            j = "down";
            k = "up";
            l = "right";
            u = "home";
            o = "end";
            i = "pageup";
            comma = "pagedown";
          };
        };
      };
    };
  };
}
