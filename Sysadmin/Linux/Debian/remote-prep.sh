#!/bin/bash

## Add user:
# useradd -m -G adm,cdrom,sudo,dip,plugdev,lxd -s /bin/bash steve
# passwd steve
# ssh-copy-id foo
# For docker foo: sudo adduser steve docker

shopt -s expand_aliases
REMOTE=$1
INST_TYPE=$2
PROXY=$3
PREP=$4

ARCHI=$(uname -m)

if [[ "$(ssh -q -o BatchMode=yes -o ConnectTimeout=3 $REMOTE exit ; echo $?)" != "0" ]]; then
    echo "Connection failed, key maybe not installed, running ssh-copy-id"
    ssh-copy-id ${REMOTE}
fi

if [[ "$(ssh -q -o BatchMode=yes -o ConnectTimeout=3 $REMOTE exit ; echo $?)" != "0" ]]; then
    echo "Connection still failed, investigate manually:"
    echo "ssh ${REMOTE}"
    exit 255
fi

if [[ "${PROXY}" == "proxy" ]]; then
    export http_proxy="http://proxy.lc1.conostix.com:3128"
    export HTTP_PROXY="http://proxy.lc1.conostix.com:3128"
    export https_proxy="https://proxy.lc1.conostix.com:3128"
    export HTTPS_PROXY="https://proxy.lc1.conostix.com:3128"
fi

PROXY_EXPORT="export https_proxy=$https_proxy"

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

if [[ "${PREP}" == "skip" ]]; then
    echo "Even if prepped we still install"
else
    PREPPED=$(R_SSH cat .remote_prep ; echo $?)
fi

if [[ "${PREPPED}" == "0" ]]; then
    echo "This machine is already prepped, by caution, we bail!"
    exit 255
fi

echo "..........................................."
echo "Installing for remote user ${REMOTE_USER}"
echo "..........................................."
sleep 3

if [[ "${INST_TYPE}" == "server" ]]; then
    [[ -z ${PREP} ]] && R_SSH "sudo apt update && sudo apt install etckeeper -y && sudo apt install command-not-found zsh zsh-syntax-highlighting tmux mlocate trash-cli tmuxinator htop ncdu gawk fzf coreutils net-tools neovim curl -y"
else
    [[ -z ${PREP} ]] && R_SSH "sudo apt update && sudo apt install etckeeper -y && sudo apt dist-upgrade && sudo apt autoremove && sudo apt install command-not-found zsh zsh-syntax-highlighting tmux mlocate trash-cli tmuxinator htop ncdu gawk npm fzf coreutils net-tools neovim flake8 python3-pygments curl -y"
fi

echo "Pulling bat from github as it is unstable in some debian releases"

if [[ $(R_SSH dpkg -l bat-musl 2> /dev/null > /dev/null ;echo $?) != 0 ]]; then
    if [[ "${ARCHI}" == "x86_64" ]]; then
        R_SSH "$PROXY_EXPORT ; wget https://github.com/sharkdp/bat/releases/download/v0.22.1/bat-musl_0.22.1_amd64.deb"
        R_SSH sudo dpkg -i bat-musl_0.22.1_amd64.deb
        R_SSH rm bat-musl_0.22.1_amd64.deb
    fi
    if [[ "${ARCHI}" == "armv7l" ]]; then
        R_SSH "$PROXY_EXPORT ; wget https://github.com/sharkdp/bat/releases/download/v0.22.1/bat_0.22.1_armhf.deb"
        R_SSH sudo dpkg -i bat-musl_0.22.1_armhf.deb
        R_SSH rm bat-musl_0.22.1_armhf.deb
    fi
fi

# .ssh config?
# .gnupg forwarding for signing commits

R_SSH mkdir -p .config/nvim
R_SSH mkdir -p .config/bat/themes
R_SSH mkdir -p .tmux
R_SSH mkdir -p .dir_colors
R_SSH mkdir -p bin
R_SSH "$PROXY_EXPORT ; wget -O .config/bat/themes/OneHalfDark.tmTheme https://raw.githubusercontent.com/sonph/onehalf/master/sublimetext/OneHalfDark.tmTheme"

[[ -e $(which bat) ]] && R_SSH bat cache -b
[[ -e $(which batcat) ]] && R_SSH batcat cache -b

OH_MY=$(R_SSH "[[ -e .oh-my-zsh ]] && echo true")
if [[ ! -z ${OH_MY} ]]; then
    R_SSH "ZSH=.oh-my-zsh zsh -f .oh-my-zsh/tools/upgrade.sh --interactive"
else
    R_SSH sh -c "$($PROXY_EXPORT ; curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
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
    R_SSH "$PROXY_EXPORT ; git clone https://github.com/tmux-plugins/tpm tmux/plugins/tpm"
fi
# prefix + I -> Install plugs
R_SSH "$PROXY_EXPORT ;curl -fLo .local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
R_SSH nvim +'PlugInstall' +qa --headless


R_SSH touch .remote_prep
echo ""
echo "------------------------"
echo "${REMOTE} is now prepped"
