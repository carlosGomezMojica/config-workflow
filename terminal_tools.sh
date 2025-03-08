#!/bin/bash

# Detectar la distribución
if grep -q 'Pop!_OS' /etc/os-release; then
    DISTRO='popos'
elif grep -q 'Arch Linux' /etc/os-release; then
    DISTRO='arch'
else
    echo "Distribución no soportada."
    exit 1
fi

# Barra de progreso
show_progress() {
    local current=$1
    local total=$2
    local percent=$((current * 100 / total))
    echo -ne "\r["
    for ((i=0; i < percent / 2; i++)); do echo -n "#"; done
    for ((i=percent / 2; i < 50; i++)); do echo -n "-"; done
    echo -n "] $percent%"
}

TOTAL_STEPS=13
CURRENT_STEP=0

# Funciones de instalación
install_popos() {
    sudo apt update && sudo apt install -y "$@"
}

install_arch() {
    sudo pacman -Syu --noconfirm "$@"
}

install_nvim() {
    [ "$DISTRO" = 'popos' ] && install_popos neovim || install_arch neovim
    git clone https://github.com/carlosGomezMojica/starter ~/.config/nvim
    ((CURRENT_STEP++)); show_progress $CURRENT_STEP $TOTAL_STEPS
}

install_zsh() {
    [ "$DISTRO" = 'popos' ] && install_popos zsh || install_arch zsh
    ((CURRENT_STEP++)); show_progress $CURRENT_STEP $TOTAL_STEPS
}

install_oh_my_zsh() {
    RUNZSH=no CHSH=yes KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    sed -i 's/^ZSH_THEME=.*/ZSH_THEME="passion"/' ~/.zshrc

    ZSH_CUSTOM=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}

    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
    git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-history-substring-search.git $ZSH_CUSTOM/plugins/zsh-history-substring-search
    git clone https://github.com/MichaelAquilina/zsh-you-should-use.git $ZSH_CUSTOM/plugins/you-should-use
    git clone https://github.com/Aloxaf/fzf-tab $ZSH_CUSTOM/plugins/fzf-tab

    sed -i 's/^plugins=(\(.*\))/plugins=(\1 zsh-syntax-highlighting zsh-autosuggestions zsh-history-substring-search you-should-use)/' ~/.zshrc
    echo "source $ZSH_CUSTOM/plugins/fzf-tab/fzf-tab.plugin.zsh" >> ~/.zshrc

    ((CURRENT_STEP++)); show_progress $CURRENT_STEP $TOTAL_STEPS
}

install_docker() {
    [ "$DISTRO" = 'popos' ] && install_popos docker.io || install_arch docker
    sudo systemctl enable --now docker
    sudo usermod -aG docker $USER
    ((CURRENT_STEP++)); show_progress $CURRENT_STEP $TOTAL_STEPS
}

install_lazydocker() {
    [ "$DISTRO" = 'popos' ] && install_popos golang-go || install_arch go
    go install github.com/jesseduffield/lazydocker@latest
    sudo mv ~/go/bin/lazydocker /usr/local/bin/
    ((CURRENT_STEP++)); show_progress $CURRENT_STEP $TOTAL_STEPS
}

install_lazygit() {
    [ "$DISTRO" = 'popos' ] && { sudo add-apt-repository -y ppa:lazygit-team/release; install_popos lazygit; } || install_arch lazygit
    ((CURRENT_STEP++)); show_progress $CURRENT_STEP $TOTAL_STEPS
}

install_zoxide() {
    [ "$DISTRO" = 'popos' ] && curl -sS https://webinstall.dev/zoxide | bash || install_arch zoxide
    ((CURRENT_STEP++)); show_progress $CURRENT_STEP $TOTAL_STEPS
}

install_tldr() {
    [ "$DISTRO" = 'popos' ] && sudo npm install -g tldr || install_arch tldr
    ((CURRENT_STEP++)); show_progress $CURRENT_STEP $TOTAL_STEPS
}

install_aws_cli() {
    [ "$DISTRO" = 'popos' ] && install_popos awscli || install_arch aws-cli
    ((CURRENT_STEP++)); show_progress $CURRENT_STEP $TOTAL_STEPS
}

install_nvm() {
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
    ((CURRENT_STEP++)); show_progress $CURRENT_STEP $TOTAL_STEPS
}

install_pnpm() {
    curl -fsSL https://get.pnpm.io/install.sh | sh -
    ((CURRENT_STEP++)); show_progress $CURRENT_STEP $TOTAL_STEPS
}

install_zathura() {
    [ "$DISTRO" = 'popos' ] && install_popos zathura || install_arch zathura
    mkdir -p ~/.config/zathura
    cat > ~/.config/zathura/zathurarc << EOF
set default-bg "#002b36"
set default-fg "#839496"
set statusbar-bg "#073642"
set statusbar-fg "#93a1a1"
set notification-bg "#073642"
set notification-fg "#93a1a1"
set inputbar-bg "#073642"
set inputbar-fg "#93a1a1"
EOF
    ((CURRENT_STEP++)); show_progress $CURRENT_STEP $TOTAL_STEPS
}

install_kitty() {
    [ "$DISTRO" = 'popos' ] && install_popos kitty || install_arch kitty
    git clone https://github.com/carlosGomezMojica/kitty-solarized-osaka ~/.config/kitty
    ((CURRENT_STEP++)); show_progress $CURRENT_STEP $TOTAL_STEPS
}

# Ejecutar funciones
install_nvim
install_zsh
install_oh_my_zsh
install_docker
install_lazydocker
install_lazygit
install_zoxide
install_tldr
install_aws_cli
install_nvm
install_pnpm
install_zathura
install_kitty

echo -e "\nInstalación completa."

 
