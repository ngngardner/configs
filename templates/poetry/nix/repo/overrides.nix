final: prev: let
  addNativeBuildInputs = drvName: inputs: {
    "${drvName}" = prev.${drvName}.overridePythonAttrs (old: {
      nativeBuildInputs = (old.nativeBuildInputs or []) ++ inputs;
    });
  };
in
  {}
  // addNativeBuildInputs "flake8-broken-line" [final.poetry]
  // addNativeBuildInputs "flake8-eradicate" [final.poetry]
  // addNativeBuildInputs "flake8-rst-docstrings" [final.setuptools]
  // addNativeBuildInputs "flakeheaven" [final.poetry]
  // addNativeBuildInputs "wemake-python-styleguide" [final.poetry]
