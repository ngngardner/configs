final: prev:

{
  pyjulia = prev.callPackage ./python/pyjulia { };
  pylatex = prev.callPackage ./python/pylatex { };
}
