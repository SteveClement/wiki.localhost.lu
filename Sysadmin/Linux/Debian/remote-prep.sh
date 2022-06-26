#!/bin/bash

## Add user:
# useradd -m -G adm,cdrom,sudo,dip,plugdev,lxd -s /bin/bash steve
# passwd steve
# ssh-copy-id foo
# For docker foo: sudo adduser steve docker

shopt -s expand_aliases
REMOTE=$1

if [[ "$(ssh -q -o BatchMode=yes -o ConnectTimeout=3 $REMOTE exit ; echo $?)" != "0" ]]; then
    echo "Connection failed, key maybe not installed, running ssh-copy-id"
    ssh-copy-id ${REMOTE}
fi

if [[ "$(ssh -q -o BatchMode=yes -o ConnectTimeout=3 $REMOTE exit ; echo $?)" != "0" ]]; then
    echo "Connection still failed, investigate manually:"
    echo "ssh ${REMOTE}"
    exit 255
fi

alias R_SSH="ssh -q -t -t $REMOTE"

REMOTE_USER=$(R_SSH whoami|sed 's/\r//g')
REMOTE_HOME=$(R_SSH pwd|sed 's/\r//g')
if [[ -z ${REMOTE_USER} ]]; then
    echo "Cannot determine user failed, abort"
    exit 255
fi

R_SSH_SUDO=$(R_SSH sudo -V > /dev/null; echo $?)
if [[ "${R_SSH_SUDO}" != "0" ]]; then
    echo "sudo NOT installed"
    echo -n "root "
    R_SSH "su -c apt\ install\ sudo\ -y"
    SUDO_INST=$(echo $?)
    if [[ "${SUDO_INST}" != "0" ]]; then
        echo "Installing sudo failed, investigate manually."
        exit 255
    fi
    echo -n "root "
    R_SSH su -c "/sbin/usermod\ -a\ -G\ sudo\ ${REMOTE_USER}"
    SUDO_INST=$(echo $?)
    if [[ "${SUDO_INST}" != "0" ]]; then
        echo "Installing sudo failed, investigate manually."
        exit 255
    fi
fi

PREPPED=$(R_SSH cat .remote_prep ; echo $?)

if [[ "${PREPPED}" == "0" ]]; then
    echo "This machine is already prepped, by caution, we bail!"
    exit 255
fi

echo "..........................................."
echo "Installing for remote user ${REMOTE_USER}"
echo "..........................................."
sleep 3

R_SSH "sudo apt update && sudo apt install etckeeper -y && sudo apt dist-upgrade && sudo apt autoremove && sudo apt install command-not-found zsh zsh-syntax-highlighting tmux mlocate trash-cli tmuxinator htop ncdu bat gawk npm fzf coreutils net-tools neovim flake8 python3-pygments curl -y"

# .ssh config?
# .gnupg forwarding for signing commits

R_SSH mkdir -p .config/nvim
R_SSH mkdir -p .config/bat/themes
R_SSH mkdir -p .tmux
R_SSH mkdir -p .dir_colors
R_SSH mkdir -p bin
R_SSH wget -O .config/bat/themes/OneHalfDark.tmTheme https://raw.githubusercontent.com/sonph/onehalf/master/sublimetext/OneHalfDark.tmTheme
R_SSH batcat cache -b

OH_MY=$(R_SSH "[[ -e .oh-my-zsh ]] && echo true")
if [[ ! -z ${OH_MY} ]]; then
    R_SSH "ZSH=.oh-my-zsh zsh -f .oh-my-zsh/tools/upgrade.sh --interactive"
else
    R_SSH sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
fi
R_SSH rm .zshrc
R_SSH rm .tmux.conf
scp -q ~/bin/prettyping ${REMOTE}:bin/
scp -q ~/bin/diff-so-fancy ${REMOTE}:bin/
scp -q ~/dotfiles/termite.terminfo ${REMOTE}:/tmp/
R_SSH tic -x /tmp/termite.terminfo
R_SSH sudo tic -x /tmp/termite.terminfo
scp -q ~/dotfiles/.zshrc-remote ${REMOTE}:.zshrc
scp -q ~/dotfiles/.dir_colors/dircolors ${REMOTE}:.dir_colors/
scp -q ~/dotfiles/.gitconfig-remote ${REMOTE}:.gitconfig
scp -q ~/dotfiles/.lessfilter ${REMOTE}:.lessfilter
scp -q ~/dotfiles/.gitignore_global ${REMOTE}:.gitignore_global
scp -q ~/dotfiles/.config/nvim/init.vim ${REMOTE}:.config/nvim/
scp -q ~/.tmux/tmux.conf ${REMOTE}:.tmux/tmux.conf
scp -q ~/.tmux/tmux.remote.conf ${REMOTE}:.tmux/tmux.remote.conf
R_SSH ln -s .tmux/tmux.conf .tmux.conf
TPM=$(R_SSH "[[ -e tmux/plugins/tpm ]] && echo true")
if [[ -z ${TPM} ]]; then
    R_SSH git clone https://github.com/tmux-plugins/tpm tmux/plugins/tpm
fi
# prefix + I -> Install plugs
R_SSH curl -fLo .local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
R_SSH nvim +'PlugInstall' +qa --headless


R_SSH touch .remote_prep
echo ""
echo "------------------------"
echo "${REMOTE} is now prepped"
