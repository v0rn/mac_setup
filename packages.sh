#!/usr/bin/env zsh

login_items=(
  Dozer
  LaunchBar
)

install_brew() {  # {{{
  # Homebrew install command, see https://brew.sh
  /usr/bin/ruby -e "$(
    curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install
  )" && rehash
}
# }}}


install_packages() {  # {{{
  # Install packages
  brew bundle && rehash

  # Add Homebrew Zsh to /etc/shells
  if ! ggrep -qE '^/usr/local/bin/zsh$' /etc/shells; then
    echo '/usr/local/bin/zsh' | sudo gtee -a /etc/shells
  fi

  # Symlink avr-gcc 7 to avr-gcc (QMK)
  brew link --force avr-gcc@8

  # Install LibreOffice Language Pack
  if ! brew cask list | ggrep -q libreoffice-language-pack; then
    open /Applications/LibreOffice.app/ && sleep 10 && pkill -x soffice
    open "$(brew cask install libreoffice-language-pack | awk -F "'" \
      '/\/usr\/local\/Caskroom\/libreoffice-language-pack\/.*\.app/ {print $2}')"
  fi

  # Install Python 3 packages
  /usr/local/bin/python3 -m pip install -r requirements.txt
}
# }}}


install_launchbar_actions() {  # {{{
  gmkdir -p ~/Library/Application\ Support/LaunchBar/Actions/ &> /dev/null
  cd ~/Library/Application\ Support/LaunchBar/Actions/

  # https://github.com/bswinnerton/launchbar-github
  [[ -d github.lbaction ]] \
    || git clone https://github.com/bswinnerton/launchbar-github github.lbaction

  # https://github.com/v0rn/xkcdpass.lbaction
  [[ -d xkcdpass.lbaction ]] \
    || git clone https://github.com/v0rn/xkcdpass.lbaction xkcdpass.lbaction

  cd -
}
# }}}


set_login_items() {  # {{{
  # Note: AppleScript (not the osascript utility) requires double quotes

  # Login items
  # Clear all existing login items
  IFS=','
  for item in $(osascript -e \
    'tell application "System Events" to get the name of every login item' \
      | gsed 's/, /,/g'
  ); do
    osascript -e "tell application \"System Events\" to delete login item \"$item\""
  done
  unset IFS

  # Add login items
  # Separate osascript calls as you otherwise only get output from the last to
  # run and order seems to change
  for app in "${login_items[@]}"; do
    osascript -e \
      "tell application \"System Events\" to make login item at end with properties {name: \"$app\", path: \"/Applications/$app.app\", hidden: false}" \
      > /dev/null
  done
}
# }}}


cd "$(dirname $0)"  # Change to script's directory

export HOMEBREW_NO_ANALYTICS=1

# Install Homebrew
if ! type -p brew &> /dev/null; then
  install_brew
fi

install_packages
install_launchbar_actions
set_login_items

# vim: set foldmethod=marker:

