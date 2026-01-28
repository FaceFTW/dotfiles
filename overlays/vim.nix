############################################
# Vim Config
############################################
final: prev: with prev; {
  vimCustom =
    (vim-full.override {
      features = "normal";
      guiSupport = false;
      waylandSupport = false;
      luaSupport = false;
      pythonSupport = false;
      rubySupport = false;
      cscopeSupport = false;
      netbeansSupport = false;
    }).customize
      {
        vimrcConfig.customRC =
          builtins.replaceStrings [ "let g:skip_plug_load = 0" ] [ "let g:skip_plug_load = 1" ]
            (builtins.unsafeDiscardStringContext (builtins.readFile "${./../config/.vimrc}"));

        vimrcConfig.packages.myVimPackges = {
          start = [
            vimPlugins.vim-fugitive
            vimPlugins.vim-polyglot
            vimPlugins.fzf-vim
            vimPlugins.neoformat
            vimPlugins.ale
            vimPlugins.vim-startify
            vimPlugins.lightline-vim
            vimPlugins.undotree
            vimPlugins.vim-peekaboo
            vimPlugins.delimitMate
          ];
        };
      };
}
