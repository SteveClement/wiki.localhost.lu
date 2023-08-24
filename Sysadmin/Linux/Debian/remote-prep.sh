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

usage () {
  echo "remote-prep.sh <REMOTE_SERVER> <TYPE_OF_PREP> <PROXY_USE> <SKIP_PREP>"
  echo "Available proxies: conostix"
  exit 0
}

# Simple debug function with message
# Make sure no alias exists
[[ $(type -t debug) == "alias" ]] && unalias debug
debug () {
  echo -e "${RED}Next step:${NC} ${GREEN}$1${NC}" > /dev/tty
  if [[ ! -z ${DEBUG} ]]; then
    NO_PROGRESS=1
    echo -e "${RED}Debug Mode${NC}, press ${LBLUE}enter${NC} to continue..." > /dev/tty
    exec 3>&1
    read
  else
    # [Set up conditional redirection](https://stackoverflow.com/questions/8756535/conditional-redirection-in-bash)
    #exec 3>&1 &>/dev/null
    :
  fi
}

if [[ ! -z "${PROXY}" ]]; then
    if [[ ${PROXY} == "conostix" ]]; then
      export http_proxy="http://proxy.lc1.conostix.com:3128"
      export HTTP_PROXY="http://proxy.lc1.conostix.com:3128"
      export https_proxy="https://proxy.lc1.conostix.com:3128"
      export HTTPS_PROXY="https://proxy.lc1.conostix.com:3128"
    fi
fi
if [[ -z $1 ]]; then
    usage
fi

if [[ "$(ssh -q -o BatchMode=yes -o ConnectTimeout=3 $REMOTE exit ; echo $?)" != "0" ]]; then
    echo "Connection failed, key maybe not installed, running ssh-copy-id"
    ssh-copy-id ${REMOTE}
fi

if [[ "$(ssh -q -o BatchMode=yes -o ConnectTimeout=3 $REMOTE exit ; echo $?)" != "0" ]]; then
    echo "Connection still failed, investigate manually:"
    echo "ssh ${REMOTE}"
    exit 255
fi

PROXY_EXPORT="export https_proxy=$https_proxy"

alias R_SSH="ssh -q -t -t $REMOTE"

debug "Fetching remote user"
REMOTE_USER=$(R_SSH "whoami|sed 's/\r//g'")
debug "Fetching remote home"
REMOTE_HOME=$(R_SSH "pwd|sed 's/\r//g'")
debug "Fetching remote shell"
REMOTE_SHELL=$(R_SSH "env |grep SHELL| grep 'zsh\|bash'")
if [[ -z $REMOTE_SHELL ]]; then
    echo "Please install bash"
    exit 255
fi
debug "Checking for uconv"
REMOTE_UCONV=$(R_SSH "which uconv")
if [[ -z $REMOTE_UCONV ]]; then
    echo "Please install icu-devtools (uconv)"
    exit 255
fi
# Probably uconv is not standard on minimal Debian
# Something is broken on Debian minimal
# the scon
debug "Checking remote OS"
REMOTE_OS=$(R_SSH "uname -s| uconv| tr -d \r")
REMOTE_OS=$(R_SSH uname -s| tr -d '\r')

if [[ -z ${REMOTE_USER} ]]; then
    echo "Cannot determine user failed, abort"
    exit 255
fi

debug "Checking for sudo"
R_SSH_SUDO=$(R_SSH sudo -V > /dev/null; echo $?)
if [[ "${R_SSH_SUDO}" != "0" && "${REMOTE_OS}" != "OpenBSD" ]]; then
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

debug "Checking if remote host is prepped"
if [[ "${PREP}" == "skip" ]]; then
    echo "Even if prepped we still install"
else
    PREPPED=$(R_SSH cat .remote_prep ; echo $?)
fi

if [[ "${PREPPED}" == "0" ]]; then
    echo "This machine is already prepped, by caution, we bail!"
    exit 255
fi

###### Functions ######

mkdirs () {
   R_SSH mkdir -p .config/nvim
   R_SSH mkdir -p .config/bat/themes
   R_SSH mkdir -p .tmux
   R_SSH mkdir -p .dir_colors
   R_SSH mkdir -p bin
}

rms () {
    R_SSH rm .zshrc
    R_SSH rm .tmux.conf
}

scps () {
    scp -q ~/bin/prettyping ${REMOTE}:bin/
    scp -q ~/bin/diff-so-fancy ${REMOTE}:bin/
    scp -q ~/dotfiles/.dir_colors/dircolors ${REMOTE}:.dir_colors/
    scp -q ~/dotfiles/.zshrc-remote ${REMOTE}:.zshrc
    scp -q ~/dotfiles/.gitconfig-remote ${REMOTE}:.gitconfig
    scp -q ~/dotfiles/.gitignore_global ${REMOTE}:.gitignore_global
    scp -q ~/dotfiles/.lessfilter ${REMOTE}:.lessfilter
    scp -q ~/dotfiles/.selected_editor ${REMOTE}:.selected_editor
    scp -q ~/dotfiles/.config/nvim/init.vim ${REMOTE}:.config/nvim/
    scp -q ~/.tmux/tmux.conf ${REMOTE}:.tmux/tmux.conf
    scp -q ~/.tmux/tmux.remote.conf ${REMOTE}:.tmux/tmux.remote.conf
}

OpenBSD () {
   mkdirs
   rms
   scps
   R_SSH "ln -s .tmux/tmux.conf .tmux.conf"
   exit
}


echo "..........................................."
echo "Installing for remote user ${REMOTE_USER}"
echo "..........................................."
sleep 3

[[ "${REMOTE_OS}" == "OpenBSD" ]] && OpenBSD

if [[ "${INST_TYPE}" == "server" ]]; then
    [[ -z ${PREP} ]] && R_SSH "sudo apt update && sudo apt install etckeeper -y && sudo apt install nala -y ; sudo apt install command-not-found zsh zsh-syntax-highlighting tmux mlocate trash-cli tmuxinator htop ncdu gawk fzf coreutils net-tools neovim curl bat -y && sudo update-alternatives --set editor /usr/bin/nvim"
else
    [[ -z ${PREP} ]] && R_SSH "sudo apt update && sudo apt install etckeeper -y && sudo apt install nala -y ; sudo apt dist-upgrade && sudo apt autoremove && sudo apt install command-not-found zsh zsh-syntax-highlighting tmux mlocate trash-cli tmuxinator htop ncdu gawk npm fzf coreutils net-tools neovim flake8 python3-pygments curl bat -y && sudo update-alternatives --set editor /usr/bin/nvim"
fi

# .ssh config?
# .gnupg forwarding for signing commits

debug "Makeing remote dirs"
mkdirs
debug "Cleaning remote host of previous files"
rms

debug "Fetching bat theme on remote host"
R_SSH "$PROXY_EXPORT ; wget -O .config/bat/themes/OneHalfDark.tmTheme https://raw.githubusercontent.com/sonph/onehalf/master/sublimetext/OneHalfDark.tmTheme"

debug "Checking if batcat is on remote host"
[[ -e $(which bat) ]] && R_SSH "bat cache -b"
[[ -e $(which batcat) ]] && R_SSH "batcat cache -b"

debug "Checking if oh-my-zshr is on remote host"
OH_MY=$(R_SSH "[[ -e .oh-my-zsh ]] && echo true")
if [[ ! -z ${OH_MY} ]]; then
    R_SSH "ZSH=.oh-my-zsh zsh -f .oh-my-zsh/tools/upgrade.sh --interactive"
else
    R_SSH sh -c "$($PROXY_EXPORT ; curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
fi

debug "Copying files to remote host"
scps

R_SSH "ln -s .tmux/tmux.conf .tmux.conf"
TPM=$(R_SSH "[[ -e tmux/plugins/tpm ]] && echo true")
if [[ -z ${TPM} ]]; then
    R_SSH "$PROXY_EXPORT ; git clone https://github.com/tmux-plugins/tpm tmux/plugins/tpm"
fi
debug "Installing nvim Plugs on remote host"
# prefix + I -> Install plugs
R_SSH "$PROXY_EXPORT ;curl -fLo .local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
R_SSH "nvim +'PlugInstall' +qa --headless"


R_SSH touch .remote_prep
echo ""
echo "------------------------"
echo "${REMOTE} is now prepped"
