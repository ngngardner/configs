{
  pkgs,
  system,
  nixago-exts,
}: let
  mkVscodeSettings = {output}: {
    data = {
      "emeraldwalk.runonsave" = {
        commands = [
          {
            match = ".*";
            cmd = "${pkgs.treefmt}/bin/treefmt \${file}";
          }
        ];
      };
      "files.exclude" = {
        ".cache" = true;
        ".direnv" = true;
        ".config" = true;
        ".local" = true;
        ".run" = true;
        ".ruff_cache" = true;
        # ".editorconfig" = true;
      };
      "nixEnvSelector.nixFile" = "\${workspaceRoot}/flake.nix";
      "nix.enableLanguageServer" = true; # Enable LSP.
      "nix.serverPath" = "nil"; # The path to the LSP server executable.
    };
    output = output;
    format = "json";
  };

  # Tool Homepage: https://editorconfig.org/
  editorconfig = {
    format = "toml";
    output = ".editorconfig";
    data = {
      root = true;
      "*" = {
        end_of_line = "lf";
        insert_final_newline = true;
        trim_trailing_whitespace = true;
        charset = "utf-8";
        indent_style = "space";
        indent_size = 2;
      };
      "*.md" = {
        max_line_length = "off";
        trim_trailing_whitespace = false;
      };
    };
  };

  # Tool Homepage: https://numtide.github.io/treefmt/
  treefmt = {
    output = "treefmt.toml";
    data = {
      formatter = {
        alejandra = {
          command = "${pkgs.alejandra}/bin/alejandra";
          includes = ["*.nix"];
        };
        prettier = {
          command = "${pkgs.nodePackages.prettier}/bin/prettier";
          options = ["--write"];
          includes = [
            "*.css"
            "*.html"
            "*.jsx"
            "*.mdx"
            "*.scss"
            "*.yaml"
          ];
        };
        topiary = {
          command = "${pkgs.topiary}/bin/topiary";
          options = ["--in-place" "--input-file"];
          includes = [
            "*.json"
            "*.toml"
          ];
        };
      };
    };
  };

  # Tool Homepage: https://github.com/siderolabs/conform
  conform = {
    commit = {
      header = {length = 89;};
      conventional = {
        types = [
          "build"
          "chore"
          "ci"
          "docs"
          "feat"
          "fix"
          "perf"
          "refactor"
          "style"
          "test"
        ];
        scopes = [
          "deps"
          "engine"
          "hook"
          "core"
          "flake"
          "request"
        ];
      };
    };
  };

  # Tool Homepage: https://github.com/evilmartians/lefthook
  lefthook = {
    commit-msg = {
      commands = {
        conform = {
          run = "${pkgs.conform}/bin/conform enforce --commit-msg-file {1}";
        };
      };
    };
    pre-commit = {
      commands = {
        treefmt = {
          run = "${pkgs.treefmt}/bin/treefmt --fail-on-change {staged_files}";
          glob = "*.nix";
        };
      };
    };
  };

  repoSettings = mkVscodeSettings {output = ".vscode/settings.json";};
in [
  editorconfig
  (nixago-exts.conform.${system} conform)
  (nixago-exts.lefthook.${system} lefthook)

  repoSettings
  treefmt
]
