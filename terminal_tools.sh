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

# Función para instalar paquetes en Pop!_OS
install_popos() {
    sudo apt update
    sudo apt install -y "$@"
}

# Función para instalar paquetes en Arch Linux
install_arch() {
    sudo pacman -Syu --noconfirm "$@"
}

# 1. Instalar Neovim y configurar
install_nvim() {
    if [ "$DISTRO" = 'popos' ]; then
        install_popos neovim
    elif [ "$DISTRO" = 'arch' ]; then
        install_arch neovim
    fi
    git clone https://github.com/carlosGomezMojica/starter ~/.config/nvim
}

# 2. Instalar Zsh
install_zsh() {
    if [ "$DISTRO" = 'popos' ]; then
        install_popos zsh
    elif [ "$DISTRO" = 'arch' ]; then
        install_arch zsh
    fi
}

# 3. Instalar Oh-My-Zsh y configurar
install_oh_my_zsh() {
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    sed -i 's/^ZSH_THEME=.*/ZSH_THEME="passion"/' ~/.zshrc

    ZSH_CUSTOM=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}

    # Instalar plugins
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
    git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-history-substring-search.git $ZSH_CUSTOM/plugins/zsh-history-substring-search
    git clone https://github.com/MichaelAquilina/zsh-you-should-use.git $ZSH_CUSTOM/plugins/you-should-use

    # Añadir plugins al .zshrc
    sed -i 's/^plugins=(\(.*\))/plugins=(\1 zsh-syntax-highlighting zsh-autosuggestions zsh-history-substring-search you-should-use)/' ~/.zshrc

    # Configurar fzf-tab
    git clone https://github.com/Aloxaf/fzf-tab $ZSH_CUSTOM/plugins/fzf-tab
    echo "source $ZSH_CUSTOM/plugins/fzf-tab/fzf-tab.plugin.zsh" >> ~/.zshrc

    # Aplicar cambios
    source ~/.zshrc
}

# 4. Instalar Docker
install_docker() {
    if [ "$DISTRO" = 'popos' ]; then
        install_popos docker.io
    elif [ "$DISTRO" = 'arch' ]; then
        install_arch docker
    fi
    sudo systemctl enable --now docker
    sudo usermod -aG docker $USER
}

# 5. Instalar LazyDocker
install_lazydocker() {
    if [ "$DISTRO" = 'popos' ]; then
        sudo apt install -y golang-go
    elif [ "$DISTRO" = 'arch' ]; then
        install_arch go
    fi
    go install github.com/jesseduffield/lazydocker@latest
    sudo mv ~/go/bin/lazydocker /usr/local/bin/
}

# 6. Instalar LazyGit
install_lazygit() {
    if [ "$DISTRO" = 'popos' ]; then
        sudo add-apt-repository ppa:lazygit-team/release
        sudo apt update
        sudo apt install -y lazygit
    elif [ "$DISTRO" = 'arch' ]; then
        install_arch lazygit
    fi
}

# 7. Instalar Zoxide
install_zoxide() {
    if [ "$DISTRO" = 'popos' ]; then
        curl -sS https://webinstall.dev/zoxide | bash
    elif [ "$DISTRO" = 'arch' ]; then
        install_arch zoxide
    fi
}

# 8. Instalar tldr
install_tldr() {
    if [ "$DISTRO" = 'popos' ]; then
        sudo npm install -g tldr
    elif [ "$DISTRO" = 'arch' ]; then
        install_arch tldr
    fi
}

# 9. Instalar AWS CLI
install_aws_cli() {
    if [ "$DISTRO" = 'popos' ]; then
        sudo apt install -y awscli
    elif [ "$DISTRO" = 'arch' ]; then
        install_arch aws-cli
    fi
}

# 10. Instalar NVM
install_nvm() {
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
}

# 11. Instalar PNPM
install_pnpm() {
    curl -fsSL https://get.pnpm.io/install.sh | sh -
}

# 12. Instalar Zathura y configurar
install_zathura() {
    if [ "$DISTRO" = 'popos' ]; then
        install_popos zathura
    elif [ "$DISTRO" = 'arch' ]; then
        install_arch zathura
    fi

    CONFIG_DIR="$HOME/.config/zathura"
    CONFIG_FILE="$CONFIG_DIR/zathurarc"

    mkdir -p "$CONFIG_DIR"

    cat > "$CONFIG_FILE" << EOL
set default-bg       "#002b36"
set default-fg       "#839496"
set statusbar-bg     "#073642"
set statusbar-fg     "#93a1a1"
set notification-bg  "#073642"
set notification-fg  "#93a1a1"
set inputbar-bg      "#073642"
set inputbar-fg      "#93a1a1"
EOL
}

# 13. Instalar Kitty y configurar
install_kitty() {
    if [ "$DISTRO" = 'popos' ]; then
        install_popos kitty
    elif [ "$DISTRO" = 'arch' ]; then
        install_arch kitty
    fi
    git clone https://github.com/carlosGomezMojica/kitty-solarized-osaka ~/.config/kitty
}

# Ejecutar funciones
install_nvim
install_zsh
install_oh_my_zsh
install_docker
install_l
::contentReference[oaicite:0]{index=0}
 
