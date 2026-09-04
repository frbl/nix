{
  programs.alacritty = {
    enable = true;
    settings = {
      colors = {
          primary = {
          foreground = "0xffffff";
        };
      };
      window.padding = { x = 5; y = 5; };
      font = {
        size = 12.0;
        normal = {
          family = "monospace";
          #family = "Fira Code";
          #family = "DejaVu Sans Mono Nerd Font";
          style = "Retina";
          #family = "Source Code Pro";
        };
      };
    };
  };
}
