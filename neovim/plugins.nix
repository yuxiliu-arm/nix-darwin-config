{ pkgs, ... }:
with pkgs.vimPlugins; [
  vim-easymotion
  vim-fugitive
  vim-repeat
  vim-surround
  tcomment_vim
  vim-nix

  # ui
  vim-airline
  {
    plugin = vim-airline-themes;
    config = ''
      let g:airline_theme = 'deus'
      let g:airline_powerline_fonts = 1
    '';
  }
  {
    plugin = molokai;
    config = ''
      syntax enable
      colorscheme molokai
      hi diffAdded ctermfg=46  cterm=NONE guifg=#2BFF2B gui=NONE
      hi diffRemoved ctermfg=196 cterm=NONE guifg=#FF2B2B gui=NONE
      set termguicolors
    '';
  }

  # dev general
  {
    plugin = syntastic;
    config = ''
      " live update loc list
      let g:syntastic_always_populate_loc_list = 1
      " don't auto open, but auto close when empty
      let g:syntastic_auto_loc_list = 2
      let g:syntastic_check_on_open = 1
      let g:syntastic_check_on_wq = 0
    '';
  }
  {
    plugin = auto-pairs;
    config = ''
      let g:AutoPairs = {'(':')', '[':']', '{':'}', '"':'"', "`":"`", '```':'```', '"""':'"""'}
    '';
  }
  {
    plugin = neoformat;
    config = ''
      let g:neoformat_nix_nixpkgsfmt = {
                  \ 'exe': 'nixpkgs-fmt',
                  \ 'stdin': 1,
                  \ }
      let g:neoformat_enabled_nix = ['nixpkgsfmt']

      function SetIndent(enable)
          " Enable alignment
          let b:neoformat_basic_format_align = a:enable
          " Enable tab to spaces conversion
          let b:neoformat_basic_format_retab = a:enable
          " Enable trimmming of trailing whitespace
          let b:neoformat_basic_format_trim = a:enable
      endfunction

      augroup noformat
          autocmd!
          " disable basic formatting
          autocmd FileType markdown call SetIndent(0)
      augroup END
      augroup fmt
          autocmd!
          autocmd FileType cuda,c,cpp,haskell,nix,cabal,python,ocaml,reason,rust
              \ autocmd BufWritePre <buffer> silent! Neoformat |
              \ call SetIndent(1)
      augroup END
    '';
  }

  # lsp
  nvim-lspconfig
  {
    plugin = fzf-vim;
    config = ''
      nnoremap <C-p> :Rg<CR>
      nnoremap <C-l> :Files<Space>
    '';
  }

  # auto complete
  cmp-nvim-lsp
  cmp-buffer
  cmp-path
  cmp-cmdline
  nvim-cmp
  cmp-vsnip
  vim-vsnip

  # Coq
  Coqtail
  {
    plugin = pkgs.vimUtils.buildVimPluginFrom2Nix
      {
        name = "coq-lsp-nvim";
        src = pkgs.fetchFromGitHub {
          owner = "tomtomjhj";
          repo = "coq-lsp.nvim";
          rev = "9235e78cba8e40675b834bc5c1d6d5187bf9973d";
          hash = "sha256-0i6HHNkJ0KXN3/uI0fwOEYyNgeKC0Wms5/r0+Es60mY=";
        };
      };
    config = ''
      " Don't load Coqtail
      let g:loaded_coqtail = 1
      let g:coqtail#supported = 0

      " Setup coq-lsp.nvim
      lua require'coq-lsp'.setup()
    '';
  }
]
