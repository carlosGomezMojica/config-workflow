#!/bin/bash

total_steps=13
current_step=0

declare -A install_status

# Detectar la distribución
if grep -q 'Pop!_OS' /etc/os-release; then
    DISTRO='popos'
elif grep -q 'Arch Linux' /etc/os-release; then
    DISTRO='arch'
else
    echo "Distribución no soportada."
    exit 1
fi

# Instaladores
install_popos() {
    sudo apt update
    sudo apt install -y "$@"
}

install_arch() {
    sudo pacman -Syu --noconfirm "$@"
}

# Barra de progreso
update_progress() {
    current=$1
    total=$2
    percent=$((current_step * 100 / total_steps))
    bar=$(printf '%0.s#' $(seq 1 $((progress/5))))
    spaces=$(printf '%*s' $((20 - ${#bar})) '')
    printf "\rInstalando: [%-20s] %d%%" "${bar}${spaces}" "${progress}"
}

# 1. Neovim
install_nvim() {
    [ "$DISTRO" = 'popos' ] && install_popos neovim || install_arch neovim
    git clone https://github.com/carlosGomezMojica/starter ~/.config/nvim
}

# 2. Zsh
install_zsh() {
    { [ "$DISTRO" = 'popos' ] && install_popos zsh; } || { [ "$DISTRO" = 'arch' ] && install_arch zsh; }
}

# 3. Oh-My-Zsh
install_oh_my_zsh() {
    RUNZSH=no CHSH=yes KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    sed -i 's/^ZSH_THEME=.*/ZSH_THEME="passion"/' ~/.zshrc

    ZSH_CUSTOM=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}

    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
    git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-history-substring-search.git $ZSH_CUSTOM/plugins/zsh-history-substring-search
    git clone https://github.com/MichaelAquilina/zsh-you-should-use.git $ZSH_CUSTOM/plugins/you-should-use
    git clone https://github.com/Aloxaf/fzf-tab $ZSH_CUSTOM/plugins/fzf-tab

    sed -i 's/^plugins=(\(.*\))/plugins=(\1 zsh-syntax-highlighting zsh-autosuggestions zsh-history-substring-search you-should-use fzf-tab)/' ~/.zshrc
}

# 4. Docker
install_docker() {
    { [ "$DISTRO" = 'popos' ] && install_popos docker.io; } || { [ "$DISTRO" = 'arch' ] && install_arch docker; }
    sudo systemctl enable --now docker
    sudo usermod -aG docker $USER
}

# 5. LazyDocker
install_lazydocker() {
    curl https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash
}

# 6. LazyGit
install_lazygit() {
    if [ "$DISTRO" = 'popos' ]; then
        sudo add-apt-repository ppa:lazygit-team/release -y
        sudo apt update
        sudo apt install -y lazygit
    elif [ "$DISTRO" = 'arch' ]; then
        install_arch lazygit
    fi
}

# 7. Zoxide
install_zoxide() {
    curl -sS https://webinstall.dev/zoxide | bash
}

# 8. tldr
install_tldr() {
    sudo npm install -g tldr
}

# 9. AWS CLI
install_aws_cli() {
    { [ "$DISTRO" = 'popos' ] && install_popos awscli; } || { [ "$DISTRO" = 'arch' ] && install_arch aws-cli; }
}

# 10. NVM
install_nvm() {
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
}

# 10. PNPM
install_pnpm() {
    curl -fsSL https://get.pnpm.io/install.sh | sh -
}

# 11. Zathura
install_zathura() {
    { [ "$DISTRO" = 'popos' ] && install_popos zathura; } || { [ "$DISTRO" = 'arch' ] && install_arch zathura; }
    mkdir -p "$HOME/.config/zathura"
    cat > "$HOME/.config/zathura/zathurarc" << EOL
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

# 12. Kitty
install_kitty() {
    { [ "$DISTRO" = 'popos' ] && install_popos kitty; } || { [ "$DISTRO" = 'arch' ] && install_arch kitty; }
    git clone https://github.com/carlosGomezMojica/kitty-solarized-osaka ~/.config/kitty
}

# Array de instalaciones
installs=(
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
)

echo "🚀 Iniciando instalación..."

for install_function in "${installs[@]}"; do
    echo "🔸 Ejecutando: $install_function"
    if $install_function; then
        install_status[$install_function]="✅"
    else
        install_status[$install_function]="❌"
    fi
    ((current_step++))
    progress=$((current_step * 100 / total_steps))
    update_progress
    sleep 1
done

# Limpiar barra final
echo ""

# Mostrar resumen final
echo -e "\n📋 Resumen de instalación:"
for tool in "${!install_status[@]}"; do
    echo -e "${install_status[$tool]} ${tool#install_}"
done

echo -e "\n🎉 Instalación completada."
