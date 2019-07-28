#!/bin/bash

login_items=(
  'Alfred 4'
  Dozer
  WhichSpace
)

install_brew() {
  # Homebrew install command, see https://brew.sh
  /usr/bin/ruby -e "$(
    curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install
  )"

  # Install Mac App Store CLI
  brew install mas
}


install_packages() {
  # Install packages
  brew bundle

  # Add Homebrew Zsh to /etc/shells
  if ! ggrep -qE '^/usr/local/bin/zsh$' /etc/shells; then
    echo '/usr/local/bin/zsh' | sudo gtee -a /etc/shells
  fi

  # Symlink avr-gcc 7 to avr-gcc (QMK)
  brew link --force avr-gcc@8

  # Install LibreOffice Language Pack
  if ! brew cask list | ggrep -q libreoffice-language-pack; then
    open /Applications/LibreOffice.app/ && sleep 10 && pkill soffice
    open "$(brew cask install libreoffice-language-pack | awk -F "'" \
      '/\/usr\/local\/Caskroom\/libreoffice-language-pack\/.*\.app/ {print $2}')"
  fi
}


set_login_items() {
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
#  osascript -e 'tell application "System Events" to make login item at end with properties {name: "Alfred 4", path: "/Applications/Alfred 4.app", hidden: false}' > /dev/null
#  osascript -e 'tell application "System Events" to make login item at end with properties {name: "Dozer", path: "/Applications/Dozer.app", hidden: false}' > /dev/null
#  osascript -e 'tell application "System Events" to make login item at end with properties {name: "WhichSpace", path: "/Applications/WhichSpace.app", hidden: false}' > /dev/null
  for app in "${login_items[@]}"; do
    osascript -e \
      "tell application \"System Events\" to make login item at end with properties {name: \"$app\", path: \"/Applications/$app.app\", hidden: false}" \
      > /dev/null
  done
}


main() {
  cd "$(dirname $0)"  # Change to script's directory

  export HOMEBREW_NO_ANALYTICS=1

  # Install Homebrew and mas
  if ! which brew > /dev/null; then
    install_brew
  fi

  install_packages
  set_login_items
}

main

