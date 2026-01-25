{lib}: {
  theme = lib.mkDefault "catppuccin_frappe";
  editor = {
    bufferline = lib.mkDefault "multiple";
    color-modes = lib.mkDefault true;
    auto-pairs = lib.mkDefault false;
    line-number = lib.mkDefault "relative";
    mouse = lib.mkDefault true;
    inline-diagnostics = {cursor-line = lib.mkDefault "hint";};
    cursorline = lib.mkDefault true;
    cursor-shape = {
      insert = lib.mkDefault "bar";
      normal = lib.mkDefault "block";
      select = lib.mkDefault "underline";
    };

    statusline = {
      left = lib.mkDefault ["mode" "spinner" "file-name"];
      right = lib.mkDefault ["diagnostics" "selections" "position" "file-encoding" "file-line-ending" "file-type"];
      separator = lib.mkDefault "│";
    };
  };
}
