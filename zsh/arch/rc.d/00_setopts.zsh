## glob
setopt GLOB_DOTS	# include dot files
setopt EXTENDED_GLOB	# it can use (.) pattern for file


## history
HISTFILE=~/.zsh_history       # set path for history file
SAVEHIST=1000                 # Number of history lines to save (to file)
HISTSIZE=1000                 # Number of history lines to remember per session (memory)
# Options for deduplication and search of history
setopt INC_APPEND_HISTORY     # Append to history file each time a command is executed
setopt HIST_IGNORE_ALL_DUPS   # Do not save all duplicate commands to history
setopt HIST_REDUCE_BLANKS     # Reduce multiple spaces to a single space and save
setopt HIST_NO_STORE          # Do not store history commands themselves, such as history, !, etc., in the history.
setopt HIST_SAVE_NO_DUPS      # Do not save duplicate commands when saving to the history file.
setopt HIST_EXPIRE_DUPS_FIRST # Delete oldest duplicate history first
