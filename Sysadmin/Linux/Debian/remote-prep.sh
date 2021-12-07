#!/bin/bash
#

shopt -s expand_aliases
REMOTE=$1

if [[ "$(ssh -q -o ConnectTimeout=3 $REMOTE exit ; echo $?)" != "0" ]]; then
    echo "Connection failed, abort"
    exit 255
fi

alias R_SSH="ssh -q -t $REMOTE"

REMOTE_USER=$(R_SSH whoami)
echo "..........................................."
echo "Installing for remote user ${REMOTE_USER}"
echo "..........................................."
sleep 3

R_SSH sudo apt install etckeeper -y
R_SSH sudo apt update
R_SSH sudo apt dist-upgrade
R_SSH sudo apt install command-not-found zsh zsh-syntax-highlighting tmux mlocate trash-cli tmuxinator htop ncdu bat gawk npm fzf coreutils net-tools neovim flake8 -y

# .ssh config?
# .gnupg forwarding for signing commits

R_SSH mkdir -p ~/.config/nvim
R_SSH mkdir -p ~/.config/bat/themes
R_SSH mkdir -p ~/.tmux
R_SSH mkdir -p ~/.dir_colors
R_SSH mkdir ~/bin
R_SSH wget -O ~/.config/bat/themes/OneHalfDark.tmTheme https://raw.githubusercontent.com/sonph/onehalf/master/sublimetext/OneHalfDark.tmTheme
R_SSH batcat cache -b

R_SSH sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
R_SSH rm ~/.zshrc
R_SSH rm ~/.tmux.conf
scp -q ~/bin/prettyping ${REMOTE}:~/bin//
scp -q ~/bin/diff-so-fancy ${REMOTE}:~/bin
scp -q ~/dotfiles/termite.terminfo ${REMOTE}:/tmp/
R_SSH tic -x /tmp/termite.terminfo
R_SSH sudo tic -x /tmp/termite.terminfo
scp -q ~/dotfiles/.zshrc-remote ${REMOTE}:.zshrc
scp -q ~/dotfiles/.dir_colors/dircolors ${REMOTE}:.dir_colors/
scp -q ~/dotfiles/.gitconfig-remote ${REMOTE}:.gitconfig
scp -q ~/dotfiles/.gitignore_global ${REMOTE}:.gitignore_global
scp -q ~/dotfiles/.config/nvim/init.vim ${REMOTE}:~/.config/nvim/
scp -q ~/.tmux/tmux.conf ${REMOTE}:~/.tmux/tmux.conf
scp -q ~/.tmux/tmux.remote.conf ${REMOTE}:~/.tmux/tmux.remote.conf
R_SSH ln -s ~/.tmux/tmux.conf ~/.tmux.conf
R_SSH git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
# prefix + I -> Install plugs
R_SSH curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
R_SSH nvim +'PlugInstall' +qa --headless
