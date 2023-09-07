{
  "suggest.noselect" = true;
  "codeLens.enable" = false;
  "languageserver" = {
    "ocaml" = {
      "command" = "opam";
      "args" = [ "exec" "--" "ocamllsp" ];
      "filetypes" = [ "ocaml" "reason" ];
    };
    "ipl" = {
      "command" = "ipl-server";
      "args" = [ ];
      "filetypes" = [ "ipl" ];
    };
    "haskell" = {
      "command" = "haskell-language-server";
      "args" = [ "--lsp" ];
      "rootPatterns" = [ "*.cabal" "stack.yaml" "cabal.project" "package.yaml" "hie.yaml" ];
      "filetypes" = [ "haskell" "lhaskell" ];
    };
  };
  "rust-analyzer.checkOnSave.command" = "clippy";
}
