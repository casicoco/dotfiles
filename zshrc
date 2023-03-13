ZSH=$HOME/.oh-my-zsh

# You can change the theme with another one from https://github.com/robbyrussell/oh-my-zsh/wiki/themes
ZSH_THEME="robbyrussell"

# Useful oh-my-zsh plugins for Le Wagon bootcamps
plugins=(git gitfast last-working-dir common-aliases zsh-syntax-highlighting history-substring-search pyenv zsh-autosuggestions dirhistory)


# (macOS-only) Prevent Homebrew from reporting - https://github.com/Homebrew/brew/blob/master/docs/Analytics.md
export HOMEBREW_NO_ANALYTICS=1

# Disable warning about insecure completion-dependent directories
ZSH_DISABLE_COMPFIX=true

# Actually load Oh-My-Zsh
source "${ZSH}/oh-my-zsh.sh"
unalias rm # No interactive rm by default (brought by plugins/common-aliases)

# Load rbenv if installed (to manage your Ruby versions)
export PATH="${HOME}/.rbenv/bin:${PATH}" # Needed for Linux/WSL
type -a rbenv > /dev/null && eval "$(rbenv init -)"

#Homebrew avant pyenv
eval "$(/opt/homebrew/bin/brew shellenv)"

# Load pyenv (to manage your Python versions)
export PYENV_VIRTUALENV_DISABLE_PROMPT=1
type -a pyenv > /dev/null && eval "$(pyenv init -)" && eval "$(pyenv virtualenv-init -)" && RPROMPT+='[🐍 $(pyenv version-name)]'

# Load nvm (to manage your node versions)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Call `nvm use` automatically in a directory with a `.nvmrc` file
autoload -U add-zsh-hook
load-nvmrc() {
  if nvm -v &> /dev/null; then
    local node_version="$(nvm version)"
    local nvmrc_path="$(nvm_find_nvmrc)"

    if [ -n "$nvmrc_path" ]; then
      local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

      if [ "$nvmrc_node_version" = "N/A" ]; then
        nvm install
      elif [ "$nvmrc_node_version" != "$node_version" ]; then
        nvm use --silent
      fi
    elif [ "$node_version" != "$(nvm version default)" ]; then
      nvm use default --silent
    fi
  fi
}
type -a nvm > /dev/null && add-zsh-hook chpwd load-nvmrc
type -a nvm > /dev/null && load-nvmrc

# Rails and Ruby uses the local `bin` folder to store binstubs.
# So instead of running `bin/rails` like the doc says, just run `rails`
# Same for `./node_modules/.bin` and nodejs
export PATH="./bin:./node_modules/.bin:${PATH}:/usr/local/sbin"

# Store your own aliases in the ~/.aliases file and load the here.
[[ -f "$HOME/.aliases" ]] && source "$HOME/.aliases"

# Encoding stuff for the terminal
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

export BUNDLER_EDITOR=code

#MYSQL
export PATH=${PATH}:/usr/local/mysql/bin/

#DIRENV
eval "$(direnv hook zsh)"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc' ]; then . '/opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc' ]; then . '/opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc'; fi

export GOOGLE_APPLICATION_CREDENTIALS=/Users/lauredegrave/code/casicoco/gcp/teachingforlewagon-cdc9b54a7438.json

disk-usage () {
	echo "Hello $1 ! \nClean XCODE -> xcode-clean\nClean DOCKER -> docker-clean";
  tput setaf 2;  echo "Xcode caches : It’s safe to delete because Xcode can recreate its caches";  tput sgr0
  du -sh -c ~/Library/Caches/com.apple.dt.Xcode;
  tput setaf 2;  echo "Derived data : Cache for Build. It’s safe to empty it.";  tput sgr0
  du -sh -c ~/Library/Developer/Xcode/DerivedData;
  tput setaf 2;  echo "Xcode Archives : Build history. It’s safe to empty it.";  tput sgr0
  du -sh -c ~/Library/Developer/Xcode/Archives;
  tput setaf 2;  echo "Simulator : Delete only unavailable.";  tput sgr0
  du -sh -c  ~/Library/Developer/CoreSimulator;
  tput setaf 2;  echo "\nDocker :";  tput sgr0
  docker system df;
  tput setaf 2;  echo "\nCache :";  tput sgr0
  du -sh -c ~/Library/Caches/;
  du -sh -c /Library/Caches/;
  du -sh -c /Système/Library/Caches/ ;
  tput setaf 2;  echo "\Gradle caches :";  tput sgr0
  du -sh /Users/lauredegrave/.gradle/caches;
  tput setaf 2;  echo "\Pyenv :";  tput sgr0
  du -sh /Users/lauredegrave/.pyenv/versions/3.10.6/envs/;
}

xcode-clean () {
  rm -rf ~/Library/Caches/com.apple.dt.Xcode;
  rm -rf ~/Library/Developer/Xcode/DerivedData;
  rm -rf ~/Library/Developer/Xcode/Archives;
  xcrun simctl delete unavailable;
}

docker-clean () {
  docker system prune --all --force --volumes;
}

pod-clean () {
  du -sh -c "${HOME}/Library/Caches/CocoaPods";
  if read -q "delete? To delete Press Y/y :"; then
    rm -rf "${HOME}/Library/Caches/CocoaPods" && echo '''
  You should then delete the Pods folder and the Podfile.lock
  rm -rf Pods && rm -rf Podfile.lock
  Then Reinstall pods: pod update'''
  else
    echo " not 'Y' or 'y'. Exiting..."
  fi
}
