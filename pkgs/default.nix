final: prev:

{
  pyjulia = prev.callPackage ./python/pyjulia { };
  pylatex = prev.callPackage ./python/pylatex { };

  gowrap = prev.callPackage ./go/gowrap { };
}
