/*
This file holds configuration data for repo dotfiles.

Q: Why not just put the put the file there?

A: (1) dotfile proliferation
   (2) have all the things in one place / fromat
   (3) potentially share / re-use configuration data - keeping it in sync
*/
{
  inputs,
  cell,
}: let
  mkVscodeSettings = {
    output,
    python ? inputs.nixpkgs.python310,
  }: {
    packages = [
      inputs.nixpkgs.treefmt
    ];
    data = {
      "emeraldwalk.runonsave" = {
        autoClearConsole = true;
        commands = [
          {
            match = ".*";
            cmd = "${inputs.nixpkgs.treefmt}/bin/treefmt \${file}";
          }
        ];
      };
      "files.exclude" = {
        "**/.bin" = true;
        "**/.cache" = true;
        "**/.data" = true;
        "**/.direnv" = true;
        "**/.config" = true;
        "**/.local" = true;
        "**/.run" = true;
        "**/.ruff_cache" = true;
        "**/.poetry_cache" = true;
        "**/.flakeheaven_cache" = true;
      };
      "nixEnvSelector.nixFile" = "\${workspaceRoot}/flake.nix";
      "python.defaultInterpreterPath" = "${python}/bin/python";
    };
    output = output;
    format = "json";
  };
in {
  vscode = {
    settings = mkVscodeSettings {
      output = ".vscode/settings.json";
      python = "${cell.packages.env}";
    };
    drainDebug = {
      data = {
        version = "0.2.0";
        configurations = [
          {
            name = "drain: Main";
            type = "python";
            request = "launch";
            program = "\${workspaceFolder}/drain/__main__.py";
            console = "integratedTerminal";
            justMyCode = false;
          }
        ];
      };
      output = ".vscode/launch.json";
    };
    extensions = {
      data = {
        recommendations = [
          "emeraldwalk.runonsave"
          "arrterian.nix-env-selector"
          "jnoortheen.nix-ide"
          "tamasfe.even-better-toml"
          "editorconfig.editorconfig"
        ];
      };
      output = ".vscode/extensions.json";
      format = "json";
      packages = [];
    };
  };

  # Tool Homepage: https://editorconfig.org/
  editorconfig = {
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
      "*.py" = {
        indent_size = 4;
      };
      "justfile" = {
        indent_size = 4;
      };
    };
  };

  # Tool Homepage: https://numtide.github.io/treefmt/
  treefmt = {
    packages = [
      inputs.nixpkgs.alejandra
      inputs.nixpkgs.nodePackages.prettier
      inputs.nixpkgs.nodePackages.prettier-plugin-toml
      inputs.nixpkgs.python310Packages.autopep8
      inputs.nixpkgs.ruff
      inputs.nixpkgs.topiary
    ];
    data = {
      formatter = {
        alejandra = {
          command = "${inputs.nixpkgs.alejandra}/bin/alejandra";
          includes = ["*.nix"];
        };
        prettier = {
          command = "${inputs.nixpkgs.nodePackages.prettier}/bin/prettier";
          options = ["--write"];
          includes = [
            "*.css"
            "*.html"
            "*.js"
            "*.json"
            "*.jsx"
            "*.md"
            "*.mdx"
            "*.scss"
            "*.ts"
            "*.yaml"
          ];
        };
        autopep8 = {
          command = "${inputs.nixpkgs.python310Packages.autopep8}/bin/autopep8";
          options = ["--in-place" "--aggressive" "--max-line-length" "88"];
          includes = ["*.py"];
        };
        ruff = {
          command = "${inputs.nixpkgs.ruff}/bin/ruff";
          includes = ["*.py"];
        };
        topiary = {
          command = "${inputs.nixpkgs.topiary}/bin/topiary";
          options = ["--in-place" "-f"];
          includes = ["*.toml"];
        };
      };
    };
  };

  # Tool Homepage: https://github.com/evilmartians/lefthook
  lefthook = {
    packages = [
      inputs.nixpkgs.just
      inputs.nixpkgs.lefthook
      inputs.nixpkgs.pylyzer
      inputs.nixpkgs.treefmt
    ];
    data = {
      commit-msg = {
        commands = {
          conform = {
            # allow WIP, fixup!/squash! commits locally
            run = ''
              [[ "$(head -n 1 {1})" =~ ^WIP(:.*)?$|^wip(:.*)?$|fixup\!.*|squash\!.* ]] ||
              conform enforce --commit-msg-file {1}'';
            skip = ["merge" "rebase"];
          };
        };
      };
      pre-commit = {
        commands = {
          treefmt = {
            run = "just lint {staged_files}";
            skip = ["merge" "rebase"];
          };
        };
      };
    };
  };

  # Tool Homepage: https://rust-lang.github.io/mdBook/
  mdbook = {
    # add preprocessor packages here
    packages = [
      inputs.nixpkgs.mdbook-linkcheck
    ];
    data = {
      # Configuration Reference: https://rust-lang.github.io/mdBook/format/configuration/index.html
      book = {
        language = "en";
        multilingual = false;
        title = "CONFIGURE-ME";
        src = "docs";
      };
      build.build-dir = "docs/build";
      preprocessor = {};
      output = {
        html = {};
        # Tool Homepage: https://github.com/Michael-F-Bryan/mdbook-linkcheck
        linkcheck = {};
      };
    };
    output = "book.toml";
    hook.mode = "copy"; # let CI pick it up outside of devshell
  };

  # Tool Homepage: https://github.com/siderolabs/conform
  conform = {
    data = {
      commit = {
        header = {length = 89;};
        conventional = {
          types = [
            "build"
            "chore"
            "ci"
            "config"
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
  };
}
