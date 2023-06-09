### X11 or Wayland

```
echo $XDG_SESSION_TYPE
```

### Rotate Framebuffer Console (fbcon)

You can rotate your virtual framebuffers using fbcon. 0 through 3 to represent the various rotations:

0 - Normal rotation
1 - Rotate clockwise
2 - Rotate upside down
3 - Rotate counter-clockwise
These can be set from the command line by putting a value into the correct system file. Rotate the current framebuffer:

```
echo 3 | sudo tee /sys/class/graphics/fbcon/rotate
```

Rotate all virtual framebuffers:

```
echo 3 | sudo tee /sys/class/graphics/fbcon/rotate_all
```



### chroot to fix OS

```
cd /
mount -t ext3 /dev/sda1 /mnt
mount -t proc proc /mnt/proc
mount -t sysfs sys /mnt/sys
mount -o bind /dev /mnt/dev
mount -o bind /dev/pts /mnt/dev/pts
chroot /mnt
# magick
```



### Forwarding gpg-agent

[Source](https://wiki.gnupg.org/AgentForwarding)

gpgconf --list-dir agent-extra-socket
gpgconf --list-dir agent-socket

To your /.ssh/config you can add:
Host gpgtunnel
HostName server.domain 
RemoteForward <socket_on_remote_box>  <extra_socket_on_local_box>


If you can modify the servers settings you should put:

StreamLocalBindUnlink yes


### Remote dev setup

#### Packages

sudo apt install zsh zsh-syntax-highlighting zplug neovim tmux

#### Direcotries

~/.zsh*
~/.nvim
~/.gitconfig
~/.dircolors
~/.tmux
~/bin



# Set path if required
#export PATH=$GOPATH/bin:/usr/local/go/bin:$PATH

# Aliases
alias ls='ls --color=auto'
alias ll='ls -lah --color=auto'
alias grep='grep --color=auto'
alias ec="$EDITOR $HOME/.zshrc" # edit .zshrc
alias sc="source $HOME/.zshrc"  # reload zsh configuration

# Set up the prompt - if you load Theme with zplugin as in this example, this will be overriden by the Theme. If you comment out the Theme in zplugins, this will be loaded.
autoload -Uz promptinit
promptinit
prompt adam1            # see Zsh Prompt Theme below

# Use vi keybindings even if our EDITOR is set to vi
bindkey -e

setopt histignorealldups sharehistory

# Keep 5000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=5000
SAVEHIST=5000
HISTFILE=~/.zsh_history

# Use modern completion system
autoload -Uz compinit
compinit

# zplug - manage plugins
source /usr/share/zplug/init.zsh
zplug "plugins/git", from:oh-my-zsh
zplug "plugins/sudo", from:oh-my-zsh
zplug "plugins/command-not-found", from:oh-my-zsh
zplug "zsh-users/zsh-syntax-highlighting"
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-history-substring-search"
zplug "zsh-users/zsh-completions"
zplug "junegunn/fzf"
zplug "themes/robbyrussell", from:oh-my-zsh, as:theme   # Theme

# zplug - install/load new plugins when zsh is started or reloaded
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi
zplug load --verbose
