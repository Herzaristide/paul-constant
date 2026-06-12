{ ... }:

{
  programs.chromium = {
    enable = true;
    extensions = [
      { id = "fcoeoabgfenejglbffodgkkbkcdhcgfn"; }
      { id = "ddkjiahejlhfcafbddmgiahcphecmpfh"; }
      { id = "effdbpeggelllpfkjppbokhmmiinhlmg"; }
    ];
  };

  # ManagedBookmarks: home-manager n'expose pas `extraOpts`, donc on écrit
  # directement le fichier de policy par-utilisateur.
  xdg.configFile."chromium/policies/managed/preferences.json".text = builtins.toJSON {
    TranslateEnabled = false;
    WebAppInstallForceList = [
      {
        url = "https://claude.ai/new";
        default_launch_container = "window";
        create_desktop_shortcut = true;
      }
    ];
  };

  xdg.configFile."chromium/policies/managed/bookmarks.json".text = builtins.toJSON {
    ManagedBookmarks = [
      {
        name = "GitHub";
        url = "https://github.com";
      }
      {
        name = "Claude";
        url = "https://claude.ai";
      }
      {
        name = "Figma";
        url = "https://www.figma.com";
      }
    ];
  };
}
