## [github](https://github.com/Aloxaf/fzf-tab.git)
# use fzf for completion, flags / directory / files
#
# -- Usage
# <Tab> in command line : show fzf results
# 						  if the suffix is started after '-', it shows flags
# <C-Space> in fzf : select multiple items
# </> in fzf : continuous sub-directory search if it is folder.
#
#
# -- Important
# 1) fzf is installed
# 2) fzf-tab needs to be loaded after compinit , before zsh-autosuggestions
# 3) completions should be configured before compinit

## fzf-tab configuration
source "$ZDOTDIR/plugins/fzf-tab/fzf-tab.plugin.zsh"
