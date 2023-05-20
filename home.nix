{pkgs, ...}: let
  username = "noah";
  homedir = "/home/noah";
in {
  home = {
    packages = with pkgs; [
      # tooling
      alejandra
      direnv
      nil
      ripgrep
      treefmt
      conform

      # for non-nix projects
      rtx

      # langs
      julia-bin
    ];

    username = username;
    homeDirectory = homedir;
    stateVersion = "22.11";
  };

  programs = {
    home-manager.enable = true;
    bat.enable = true;
    starship.enable = true;
    bash = {
      enable = true;
      initExtra = ''
        . "/home/noah/.nix-profile/etc/profile.d/nix.sh"
        # eval "$(rtx activate bash)"

        if which direnv &> /dev/null; then
          eval "$(direnv hook $SHELL)"

          _direnv_hook() {
            eval "$(
              (
                (
                  direnv export "$SHELL" 3>&1 1>&2 2>&3 3>&- |
                    egrep -v -e '^direnv: (loading|export|unloading)'
                ) 3>&1 1>&2 2>&3 3>&-
              )
            )"
          };
        fi
      '';
    };
    direnv = {
      enable = true;
      nix-direnv.enable = true;
      stdlib = ''
        use_rtx() {
          direnv_load rtx direnv exec
        }

        layout_poetry() {
          PYPROJECT_TOML="''${PYPROJECT_TOML:-pyproject.toml}"
          if [[ ! -f "$PYPROJECT_TOML" ]]; then
            log_status "No pyproject.toml found. Executing \`poetry init\` to create a \`$PYPROJECT_TOML\` first."
            poetry init
          fi

          VIRTUAL_ENV=$(poetry env info --path 2>/dev/null ; true)

          if [[ -z $VIRTUAL_ENV || ! -d $VIRTUAL_ENV ]]; then
            log_status "No virtual environment exists. Executing \`poetry install\` to create one."
            poetry install
            VIRTUAL_ENV=$(poetry env info --path)
          fi

          PATH_add "$VIRTUAL_ENV/bin"
          export POETRY_ACTIVE=1
          export VIRTUAL_ENV
        }

        auto_poetry() {
          watch_file poetry.lock
          local poetry_hash=$(cat poetry.lock | md5sum | cut -d' ' -f1)
          local poetry_hash_file=".poetry_cache"

          if [[ ! -f "$poetry_hash_file" || "$(cat $poetry_hash_file)" != "$poetry_hash" ]]; then
            log_status "poetry.lock has changed. Executing \`poetry install\` to update the virtual environment."
            poetry install
            echo "$poetry_hash" > "$poetry_hash_file"
          fi
        }
      '';
    };
  };
}
