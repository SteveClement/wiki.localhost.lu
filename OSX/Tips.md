= Essentials =

 * --(Truecrypt)-- [[https://pure-privacy.org/projects/|TrueCrypt forks]]
 * [[http://brew.sh/|Homebrew]]
  * ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" ([[https://www.macports.org/|Mac Ports]])
 * [[https://github.com/caskroom/homebrew-cask|brew Cask]]
  * brew install caskroom/cask/brew-cask
 * Cask packages
  * brew cask install iterm2 karabiner google-chrome mactex texshop firefox thunderbird xquartz little-snitch gpgtools kaleidoscope keka virtualbox libreoffice macupdate-desktop evernote osxfuse 0xed shiftit adafruit-arduino
 * Homebrew packages
  * brew install wget htop-osx tmux irssi zsh rbenv nmap ext2fuse ext4fuse csshx exiftool dos2unix findutils gnu-tar hunspell lynx ngrep p7zip mercurial ssh-copy-id imagemagick unrar redis rmate
  * brew install --with-libotr bitlbee
  * brew tap SteveClement/devel
  * brew install --with-sidebar-patch --with-trash-patch --with-s-lang --with-pgp-combined-crypt-hook-patch mutt-patched
  * brew install urlview contacts offlineimap notmuch msmtp imapfilter findutils dialog elinks
 * chsh -s /bin/zsh
 * gem install tmuxinator
 * Potentially casked
  * 1password
  * 4k-youtube-to-mp3
  * a-better-finder-rename
  * ableton-live-suite
  * adobe-cc*
  * audacity
  * [[https://getfirefox.com|Firefox]]
  * [[https://getthunderbird.com|Thunderbird]]
  * [[http://ethanschoonover.com/solarized|Solarized iTerm2]]
  * [[http://xquartz.macosforge.org/|Xquartz]]
  * [[https://tug.org/mactex/|MacTeX]]
  * [[http://pages.uoregon.edu/koch/texshop/installing.html|TeXShop]]
  * [[https://www.obdev.at/products/littlesnitch/index.html|Little Snitch]]
  * [[https://gpgtools.org|GPGTools]]
  * [[https://github.com/fikovnik/ShiftIt/releases|ShiftIt]]
  * [[https://www.iterm2.com/|iTerm]]
  * [[http://www.kekaosx.com/en/|Keka]]
  * [[https://www.google.com/chrome/|Chrome]]
  * [[http://www.kaleidoscopeapp.com/|Kaleidoscope]]
  * [[https://virtualbox.org|Virtualbox]]
  * [[https://www.libreoffice.org/download|LibreOffice]]
  * [[http://www.macupdate.com/desktop|MacUpdate]]
  * [[https://pqrs.org/osx/karabiner/|Karabiner]]
   * [[https://github.com/pauloconnor/das_keyboard|dasKeyboard mapping]]
 * Fonts
  * [[https://github.com/adobe-fonts/source-code-pro/releases/tag/1.017R|Source Code Pro]]
  * [[https://github.com/powerline/fonts/tree/master/InconsolataDz|Inconsolata-Dz]]
 * [[http://synergy-project.org/|Synergy]]
 * [[https://itunes.apple.com/en/app/xcode/id497799835?mt=12|Xcode]]
 * [[https://spellchecker.lu|Spellchecker.lu]]
 * --(FlashPlayer)--
 * [[OSX mutt]]
 * [[https://itunes.apple.com/us/app/regexrx/id498370702?mt=12|RegExRX]]
 * [[https://github.com/zdia/gorilla/wiki|PasswordGorilla]] or [[http://pwsafe.info/mac/|pwSafe]]
 * --(AppFresh)--
 * [[https://www.sublimetext.com/3|Sublime Text 3]]
  * [[https://packagecontrol.io/installation#st3|Package Control]]
  * ColorPicker
  * Solarized (braver)
  * LatexTools
  * Language French
  * GitGutter
  * MarkdownEditing
  * LiveReload
  * WordCount

== Development ==

 * brew install android-sdk go jq phantomjs python3 mercurial 

=== pygame ===
 * brew install sdl sdl_image sdl_mixer sdl_ttf portmidi
 * brew tap homebrew/headonly
 * brew install --HEAD smpeg

==== Fixing packages ====

{{{
export PKG_S="sdl sdl_image sdl_mixer sdl_ttf smpeg portmidi"
for PKG in `echo ${PKG_S}`; do
   brew rm ${PKG}
   brew rm $(join <(brew leaves) <(brew deps ${PKG}))
done 
}}}

= Potentially obsolete =
== Mac Ports ==

 * port install pidgin pidgin-otr
  * brew install pidgin

== Tier 2 ==
 * [[http://ww2.unime.it/flr/tftpserver|tftpserver]]
  * brew cask install tftpserver
