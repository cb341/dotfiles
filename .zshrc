export ZSH="$HOME/.oh-my-zsh"

DISABLE_AUTO_UPDATE="true"
DISABLE_MAGIC_FUNCTIONS="true"
DISABLE_COMPFIX="true"
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE="20"
ZSH_AUTOSUGGEST_USE_ASYNC=1

autoload -Uz compinit
if [ "$(date +'%j')" != "$(stat -f '%Sm' -t '%j' ~/.zcompdump 2>/dev/null)" ]; then
    compinit
else
    compinit -C
fi

set -o vi

 # https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
 ZSH_THEME="robbyrussell"

 plugins=(
   bundler
   fzf
   git
   brew
   bun
   you-should-use
   zsh-vi-mode
   fast-syntax-highlighting
   rust
   # zsh-autocomplete
   # zsh_codex
 )

 source $HOME/.import-secrets.sh
 source $ZSH/oh-my-zsh.sh
 source $HOME/.cargo/env
 source "$HOME/.cargo/env"

 [[ -f local_zsh ]] && source local_zsh

 DISABLE_AUTO_TITLE="true"

 export LANG=en_US.UTF-8
 export EDITOR=nvim
 export THOR_MERGE="nvim -d $2 $1"
 export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES

 [ -f /opt/homebrew/etc/profile.d/autojump.sh ] && . /opt/homebrew/etc/profile.d/autojump.sh

 export BUN_INSTALL="$HOME/.bun"
 export PATH="$BUN_INSTALL/bin:$PATH"
 export PATH="$HOME/bin:$PATH"
 export PATH="/opt/homebrew/opt/mysql@8.4/bin:$PATH"
 export PATH="/Applications/Sublime Text.app/Contents/SharedSupport/bin:$PATH"
 export PATH=$HOME/development/flutter/bin:$PATH
 export PATH=$HOME/cmdline-tools/bin:$PATH
 # export LDFLAGS="-L/opt/homebrew/opt/mysql@8.4/lib"
 # export CPPFLAGS="-I/opt/homebrew/opt/mysql@8.4/include"
 export PKG_CONFIG_PATH="/opt/homebrew/opt/mysql@8.4/lib/pkgconfig"

 # mysql stuff
export LDFLAGS="-L/opt/homebrew/opt/openssl@3/lib"
export CPPFLAGS="-I/opt/homebrew/opt/openssl@3/include"
export LIBRARY_PATH=$LIBRARY_PATH:$(brew --prefix zstd)/lib/

 alias l='ls -1A'
 alias v="nvim"
 alias go='~/scripts/open-repo-in-browser.ts'

 alias myip="ipconfig getifaddr en0"
 alias pubip="curl ifconfig.me"
 alias gg="lazygit"
 alias bra="bundle exec rubocop -A"
 alias bsf="bundle exec standardrb --fix"
 alias ctags="`brew --prefix`/bin/ctags"
 alias o="open"
 # alias c="cursor"
 alias c="code"
 alias grr='gradle run'

 # config
 alias cnvim="cd ~/.config/nvim && $EDITOR init.lua"
 alias vimrc="$EDITOR ~/.vimrc"
 alias zshrc="$EDITOR ~/.zshrc"
 alias bashrc="$EDITOR ~/.bashrc"
 alias ohmyzsh="$EDITOR ~/.oh-my-zsh"
 alias clg="$EDITOR ~/Library/Application\ Support/lazygit/config.yml"
 alias cgit="$EDITOR ~/.gitconfig"
 alias zj="zellij"
 alias zjc="v ~/.config/zellij/config.kdl"
 alias zjlc="v ~/.config/zellij/layouts/my_layout.kdl"
 alias gac="git add . && git commit --verbose"
 alias prc="v /Users/dani/prompts/README.md"
 alias fr='find . | rg '
 alias ff='hyfetch -C ~/.config/hyfetch/hyfetch.json'
 alias cvu='~/scripts/simplecov_parser.rb -u'
 alias vo='v $(fzf)'

 # Created by `pipx` on 2024-12-12 09:25:29
 export PATH="$PATH:/Users/dani/.local/bin"

 set_terminal_title() {
   git_branch=$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/')
   repo_name=$(basename "$(git rev-parse --show-toplevel 2> /dev/null)")
   echo -ne "\e]1;${repo_name} - ${git_branch}\a"
 }
 export PROMPT_COMMAND="$PROMPT_COMMAND; set_terminal_title"
 precmd() { set_terminal_title }


 alias y='yazi'

 alias jr='javac -d bin src/**/*.java; java -cp bin ch.zhaw.prog1.farm.Farm'
 alias gs='git status --porcelain=v1'
 alias gsm='git status --porcelain | awk '\''{ print $2 }'\'''
 jsf() {
   find . -name "*.java" | fzf --preview 'echo {}' | xargs java
 }

 alias fg='ls -1 | rg'
 alias bc='bin/check'
 alias br='bin/run'
 alias bcu='bin/check_unit_tests'
 alias bd='bin/dev'
 alias rails_tree="tree -I 'storage|log|tmp|node_modules|.git|public/system|public/uploads' -L 5 | bat"
 alias rails_tree_minimal=" tree -I 'db|bin|assets|config|views|storage|log|tmp|node_modules|public|.git|public/system|public/uploads' -L 5 | bat"

 export SSH_AUTH_SOCK=~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/dani/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/dani/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/dani/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/dani/google-cloud-sdk/completion.zsh.inc'; fi

# Zellij

zellij_tab_name_update() {
    if [[ -n $ZELLIJ ]]; then
        local current_dir=$PWD
        if [[ $current_dir == $HOME ]]; then
            current_dir="~"
        else
            current_dir=${current_dir##*/}
        fi
        command nohup zellij action rename-tab $current_dir >/dev/null 2>&1
    fi
}

zellij_tab_name_update
chpwd_functions+=(zellij_tab_name_update)

eval "$(~/.local/bin/mise activate zsh)"

## [Completion]
## Completion scripts setup. Remove the following line to uninstall
[[ -f /Users/dani/.dart-cli-completion/zsh-config.zsh ]] && . /Users/dani/.dart-cli-completion/zsh-config.zsh || true
## [/Completion]

export PATH="/opt/homebrew/opt/mysql-client@8.4/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

alias parallel='/opt/homebrew/Cellar/parallel/20250722/bin/parallel'

# deploio completion
fpath=(~/.local/share/zsh/site-functions $fpath)
autoload -Uz compinit && compinit
autoload -U _deploio 2>/dev/null
compdef _deploio deploio depl 2>/dev/null

fpath=(~/.config/zsh/completions $fpath)
autoload -U compinit && compinit

nvimfuzzysearch() {
  local sel
  sel=$(
    fzf --ansi --disabled \
        --prompt='rg> ' \
        --header='Type to search. Enter opens in nvim' \
        --bind "change:reload:rg --line-number --no-heading --color=always --smart-case --hidden -g '!.git' {q} || true" \
        --delimiter=':' \
        --preview 'bat --style=plain --color=always {1} --highlight-line {2}' \
        --preview-window='up:60%'
  ) || return

  [ -n "$sel" ] || return
  nvim "+$(cut -d: -f2 <<<"$sel")" "$(cut -d: -f1 <<<"$sel")"
}
alias vf='nvimfuzzysearch'
alias docker-compose='docker compose'
fpath+=/Users/dani/.zfunc

# Load Angular CLI autocompletion.
source <(ng completion script)

alias py='python'

bindkey '^X' create_completion # omzsh codex plugin
export PATH="/opt/homebrew/opt/gradle@8/bin:$PATH"
export PATH="/opt/homebrew/opt/php@8.1/bin:$PATH"
export PATH="/opt/homebrew/opt/php@8.1/sbin:$PATH"
export LDFLAGS="-L/opt/homebrew/opt/php@8.1/lib"
export CPPFLAGS="-I/opt/homebrew/opt/php@8.1/include"
