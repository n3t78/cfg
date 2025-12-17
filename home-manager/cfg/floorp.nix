{
  config,
  pkgs,
  ...
}: {
  programs.floorp = {
    enable = true;
    package = pkgs.floorp-bin;

    profiles.n3to = {
      id = 0;
      name = "n3to";
      isDefault = true;
      path = "n3to";

      containersForce = true;

      containers = {
        dev = {
          id = 1;
          name = "dev";
          color = "blue";
          icon = "briefcase";
        };

        stream = {
          id = 2;
          name = "stream";
          color = "green";
          icon = "circle";
        };

        finance = {
          id = 3;
          name = "finance";
          color = "yellow";
          icon = "dollar";
        };
      };
    };
  };
}
