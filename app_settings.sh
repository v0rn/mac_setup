#!/bin/sh

calculator() {
	# Menu options
	## View > Show Thousands Separators: True
	defaults write com.apple.calculator SeparatorsDefaultsKey -bool true

	## Window > Show Paper Tape: True
	defaults write com.apple.calculator PaperTapeVisibleDefaultsKey -bool true
}


finder() {
	# Finder Preferences
	## General > Show these items on the desktop
	defaults write com.apple.finder ShowMountedServersOnDesktop -bool true

	## General > New Finder windows show: user home
	defaults write com.apple.finder NewWindowTarget -string 'PfHm'
	defaults write com.apple.finder NewWindowTargetPath -string "file://$HOME"

	## Advanced > Show all filename extensions: True
	defaults write -g AppleShowAllExtensions -bool true

	## Advanced > Show warning before changing an extension: False
	defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

	## Advanced > Show warning before removing from iCloud Drive
	defaults write com.apple.finder FXEnableRemoveFromICloudDriveWarning -bool false

	## Advanced > Show warning before emptying the Trash: False
	defaults write com.apple.finder WarnOnEmptyTrash -bool false

	## Advanced > Keep folders on top: In windows when sorting by name: True
	defaults write com.apple.finder _FXSortFoldersFirst -bool true

	## Advanced > Keep folders on top: On Desktop: True
	defaults write com.apple.finder _FXSortFoldersFirstOnDesktop -bool true

	## Advanced > When performing a search: Search the Current Folder
	defaults write com.apple.finder FXDefaultSearchScope -string 'SCcf'

	# View menu options
	## Applies to window regardless of view
	defaults write com.apple.finder ShowPathbar -bool true

	## Show Tab Bar: True
	defaults write com.apple.finder NSWindowTabbingShoudShowTabBarKey-com.apple.finder.TBrowserWindow -bool true

	## For icon and list views only; column view is set as part of ColumnViewOptions
	defaults write com.apple.finder ShowPreviewPane -bool false  # default
	defaults write com.apple.finder ShowSidebar -bool true  # default
	defaults write com.apple.finder ShowStatusBar -bool true

	# Other
	## Show absolute path as window title
	## Commented out as path bar is clearer and allows copy/paste
	#defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

	## Disable all animations
	defaults write com.apple.finder DisableAllAnimations -bool true

	## Expand info pane sections
	### Get Info window sections:
	### MetaData: 'More Info'
	### Name: 'Name & Extension'
	### Privileges: 'Sharing & Permissions'
	defaults write com.apple.finder FXInfoPanesExpanded -dict \
		General -bool true \
		MetaData -bool false \
		Name -bool false \
		Comments -bool false \
		OpenWith -bool false \
		Preview -bool false \
		Privileges -bool true

	## Default to column view
	defaults write com.apple.finder FXPreferredViewStyle -string 'clmv'
	defaults write com.apple.finder SearchRecentsSavedViewStyle -string 'clmv'  # Recents

	## Collapse Tags section in sidebar
	defaults write com.apple.finder SidebarTagsSctionDisclosedState -bool false

	## Disable .DS_Store file creation on network and USB volumes
	defaults write com.apple.desktopservices DSDontWriteNetworkStores true
	defaults write com.apple.desktopservices DSDontWriteUSBStores true
}


launchbar() {
	# Preferences
	## General > Open Location > Prefer secure URL schemes: True
	defaults write at.obdev.LaunchBar OpenLocationPreferSecureSchemes -bool true

	## General > Open Location > Automatically prefix hostname with 'www': False
	defaults write at.obdev.LaunchBar OpenLocationPrependWWW -bool false

	## Appearance > Theme: Dark
	defaults write at.obdev.LaunchBar Theme -string 'at.obdev.LaunchBar.theme.Dark'

	## Shortcuts > Keyboard Shortcuts > Search in Spotlight: False
	defaults write at.obdev.LaunchBar SpotlightHotKeyEnabled -bool false

	## Shortcuts > Modifier Taps > Instant Send: Double Command
	defaults write at.obdev.LaunchBar ModifierTapInstantSend -int 21

	## Shortcuts > Browsing > Instant Info Browsing: True
	defaults write at.obdev.LaunchBar InstantInfoBrowsing -bool true

	## Actions > Preferred Terminal application: iTerm
	defaults write at.obdev.LaunchBar PreferredTerminal -int 1

	## Actions > Create emails with: Microsoft Outlook
	defaults write at.obdev.LaunchBar EmailHandler -string 'com.microsoft.Outlook'

	## Advanced > Show Dock Icon: False
	defaults write at.obdev.LaunchBar ShowDockIcon -bool false

	# Other
	## Set user defaults version (otherwise theme needs to be set manually)
	defaults write at.obdev.LaunchBar UserDefaultsVersion -int 6

	## Skip welcome screen
	defaults write at.obdev.LaunchBar WelcomeWindowVersion -int 2
}


preview() {
	# Menu options
	## View > Show Tab Bar: True
	defaults write com.apple.Preview NSWindowTabbingShoudShowTabBarKey-PVWindow-PVWindowController-PVWindowController-VT-FS -bool true

	## View > Hide Sidebar: True
	defaults write com.apple.Preview PVSidebarViewModeForNewDocuments -int 0
}


safari() {
	safari_plist="$HOME/Library/Containers/com.apple.Safari/Data/Library/Preferences/com.apple.Safari.plist"

	# Start Safari to create fresh plist, required for toolbar configuration
	open /Applications/Safari.app/ && sleep 10 && pkill -x Safari

	# Preferences
	## General > New windows/tabs open with: Empty Page
	defaults write com.apple.Safari NewWindowBehavior -int 1
	defaults write com.apple.Safari NewTabBehavior -int 1

	## General > Open "safe" files after downloading: False
	defaults write com.apple.Safari AutoOpenSafeDownloads -bool false

	## General > Remove download list items: When Safari quits
	defaults write com.apple.Safari DownloadsClearingPolicy -int 1

	## Search > Enable Quick Website search
	defaults write com.apple.Safari WebsiteSpecificSearchEnabled -bool false

	# Menu options
	## View > Show Tab Bar: True
	defaults write com.apple.Safari AlwaysShowTabBar -bool true

	## View > Show status bar: True
	defaults write com.apple.Safari ShowOverlayStatusBar -bool true

	# Other
	## Toolbar:
	### Clear toolbar array
	/usr/libexec/PlistBuddy -c 'Delete :"NSToolbar Configuration BrowserToolbarIdentifier-v2":"TB Item Identifiers"' "$safari_plist" > /dev/null 2>&1
	/usr/libexec/PlistBuddy -c 'Add :"NSToolbar Configuration BrowserToolbarIdentifier-v2":"TB Item Identifiers" array' "$safari_plist"

	### Add toolbar items:
	# Back/Forward, Sidebar, Flexible Space, Address and Search, Ghostery Lite, Flexible Space, Share
	/usr/libexec/PlistBuddy -c 'Add :"NSToolbar Configuration BrowserToolbarIdentifier-v2":"TB Item Identifiers": string BackForwardToolbarIdentifier' "$safari_plist"
	/usr/libexec/PlistBuddy -c 'Add :"NSToolbar Configuration BrowserToolbarIdentifier-v2":"TB Item Identifiers": string SidebarToolbarIdentifier' "$safari_plist"
	/usr/libexec/PlistBuddy -c 'Add :"NSToolbar Configuration BrowserToolbarIdentifier-v2":"TB Item Identifiers": string NSToolbarFlexibleSpaceItem' "$safari_plist"
	/usr/libexec/PlistBuddy -c 'Add :"NSToolbar Configuration BrowserToolbarIdentifier-v2":"TB Item Identifiers": string InputFieldsToolbarIdentifier' "$safari_plist"
	/usr/libexec/PlistBuddy -c 'Add :"NSToolbar Configuration BrowserToolbarIdentifier-v2":"TB Item Identifiers": string "com.ghostery.lite.safariExtension (HPY23A294X) Button"' "$safari_plist"
	/usr/libexec/PlistBuddy -c 'Add :"NSToolbar Configuration BrowserToolbarIdentifier-v2":"TB Item Identifiers": string NSToolbarFlexibleSpaceItem' "$safari_plist"
	/usr/libexec/PlistBuddy -c 'Add :"NSToolbar Configuration BrowserToolbarIdentifier-v2":"TB Item Identifiers": string ShareToolbarIdentifier' "$safari_plist"
}


skim() {
	# Menu options
	## View > Show Tab Bar: True
	defaults write net.sourceforge.skim-app.skim NSWindowTabbingShoudShowTabBarKey-SKMainWindow-SKMainWindowController-SKMainWindowController-VT-FS -bool true

	## View > Show Contents Pane: False
	defaults write net.sourceforge.skim-app.skim SKLeftSidePaneWidth -float 0

	## View > Show Notes Pane: False
	defaults write net.sourceforge.skim-app.skim SKRightSidePaneWidth -float 0
}


vagrant_manager() {
	# Preferences
	## Terminal Preference: iTerm/iTerm2
	defaults write lanayo.Vagrant-Manager terminalPreference -string 'iTerm'

	## Terminal Editor Preference: vim
	defaults write lanayo.Vagrant-Manager terminalEditorPreference -string 'vim'

	## Auto-close task window: True
	defaults write lanayo.Vagrant-Manager autoCloseTaskWindows -bool true

	## Send anonymous profile data: False
	defaults write lanayo.Vagrant-Manager sendProfileData -bool false
}


main() {
	finder
	launchbar
	preview
	safari
	skim
	vagrant_manager
}

main

# vim: set filetype=bash foldmethod=syntax:
