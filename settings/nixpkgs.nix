{
  nixpkgs = {
    config = {
      allowUnfree = true;
    };
    overlays = [
      (final: prev: {
        nnn = prev.nnn.override {
          withNerdIcons = true;
        };
      })
    ];
  };
}
