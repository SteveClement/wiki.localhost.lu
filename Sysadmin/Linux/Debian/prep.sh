sudo apt install wine
sudo apt install libgnutls30:i386 libldap-2.4-2:i386 libgpg-error0:i386 libsqlite3-0:i386
sudo add-apt-repository ppa:lutris-team/lutris
sudo apt install lutris
wget -O /tmp/starcraft2-lutris.json https://lutris.net/api/installers/starcraft-ii-battlenet?format=json
lutris -i /tmp/starcraft2-lutris.json 
sudo apt install steam-installer

[[ ! -e "~/dotfiles" ]] && ln -s ~/truecrypt1/dotfiles
[[ ! -L "~/.ssh" ]] && rm -ri ~/.ssh && ln -s ~/dotfiles/.ssh
chmod 700 ~/.ssh
chmod 600 ~/.ssh/*
[[ ! -L "~/.gnupg" ]] && rm -ri ~/.gnupg && ln -s ~/dotfiles/.gnupg
chmod 700 ~/.gnupg
chmod 700 ~/.gnupg/*

sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
rm ~/.zshrc
[[ ! -L "~/.zshrc" ]] && ln -s ~/dotfiles/.zshrc ~/
[[ ! -e "~/.msmtp" ]] && ln -s ~/dotfiles/.msmtp ~/
[[ ! -e "~/.cargo" ]] && ln -s ~/dotfiles/.cargo ~/
[[ ! -e "~/.misp" ]] && ln -s ~/dotfiles/.misp ~/
[[ ! -e "~/bin" ]] && ln -s ~/truecrypt1/bin ~/
[[ ! -e "~/.gitconfig" ]] && ln -s ~/dotfiles/.gitconfig ~/
[[ ! -e "~/.gitignore" ]] && ln -s ~/dotfiles/.gitignore ~/
#[[ ! -e "~/.gitignore_global" ]] && ln -s ~/dotfiles/.gitignore_global ~/
[[ ! -e "~/.gitmux.conf" ]] && ln -s ~/dotfiles/.gitmux.conf ~/
[[ ! -e "~/.dir_colors" ]] && ln -s ~/dotfiles/.dir_colors ~/
[[ ! -e "~/.offlineimaprc" ]] && ln -s ~/dotfiles/.offlineimaprc ~/
[[ ! -e "~/.mutt" ]] && ln -s ~/dotfiles/.mutt ~/
[[ ! -e "~/.muttilsrc" ]] && ln -s ~/dotfiles/.muttilsrc ~/
[[ ! -e "~/.tmux" ]] && ln -s ~/dotfiles/.tmux ~/
[[ ! -e "~/.tmux.conf" ]] && ln -s ~/.tmux/tmux.conf ~/.tmux.conf
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
# prefix + I -> Install plugs
[[ ! -e "~/wallpaper" ]] && ln -s ~/truecrypt1/wallpaper ~/

[[ ! -L "~/.config" ]] && mv ~/.config ~/.config-date && ln -s ~/dotfiles/.config
sudo cp ~/bin/virtualenvwrapper.sh /usr/local/bin/virtualenvwrapper.sh

sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
nvim +'PlugInstall' +qa --headless


setxkbmap -rules "evdev" -model "pc105" -option "terminate:ctrl_alt_bksp,lv3:rwin_switch,grp:shifts_toggle,caps:ctrl_modifier,altwin:swap_lalt_lwin"




