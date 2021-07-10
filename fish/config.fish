starship init fish | source
direnv hook fish | source

# Disable greeting
set fish_greeting

# function fish_greeting
  # command neofetch
# end

fish_vi_key_bindings
# fish_default_key_bindings

# doom emacs
# set PATH $PATH:~/.emacs.d/bin
fish_add_path ~/.emacs.d/bin

# Pet
function prev
  set line (echo $history[1])
  pet new $line
end

if type rg &> /dev/null
  export FZF_DEFAULT_COMMAND='rg --files'
  export FZF_DEFAULT_OPTS='-m --height 50% --border'
end

# set fish_ambiguous_width 1
# set fish_emoji_width 1
set fish_right_prompt
