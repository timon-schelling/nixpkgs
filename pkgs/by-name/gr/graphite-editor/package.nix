{
  lib,
  stdenv,
  graphite-editor-with-placeholder-icons,
}:

let
  graphite = graphite-editor-with-placeholder-icons;
  icons = graphite.resources.overrideAttrs (_: {
    npmBuildScript = "build-desktop-icons";
  });
  resources = stdenv.mkDerivation {
    pname = "graphite-editor-resources";
    inherit (graphite) version;
    phases = [ "installPhase" ];
    installPhase = ''
      mkdir -p $out
      cp -r ${graphite.resources}/* $out
      chmod -R u+w $out
      cp -rf ${icons}/* $out
    '';
  };
in graphite.overrideAttrs (_: {
  pname = "graphite-editor";
  inherit resources;
  meta.license = lib.licenses.unfreeRedistributable;
})
  # All of Graphite's code is licensed under Apache-2.0.
  # However, this package also contains Graphite's default icons that are owned by the Graphite LLC.
  # Distributing them with Graphite build from a official commit without major modifications will be specifically allowed.
  # Written permission from Graphite LLC will be provided.

  # We would like to mark this package just as Apache-2.0 and would be happy to do any possible changes upstream to achieve that, except changing ownership of the icons.
  # Fetching the icons on first startup is a possible solution, but feels suboptimal.

  # I think we are in a similar situation like firefox (and there branding).
