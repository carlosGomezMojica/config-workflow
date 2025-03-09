#!/bin/bash

total_steps=13
current_step=0

declare -A install_status

# Barra de progreso
update_progress() {
    current_step=$((current_step + 1))
    percentage=$((current_step * 100 / total_steps))
    filled=$((percentage / 5))
    empty=$((10 - filled))
    printf "\rProgreso: [%-40s] %d%%\n" "$(printf "%${done}s" | tr ' ' '#')$(printf "%${left}s" | tr ' ' '-')" "$progress"
}

detect_distro() {
    if grep -q 'Pop!_OS' /etc/os-release; then
        DISTRO='popos'
    elif grep -q 'Arch Linux' /etc/os-release; then
        DISTRO='arch'
    else
        echo "Distribución no soportada."
        exit 1
    fi
}

install_popos() { sudo apt update && sudo apt install -y "$@"; }
install_arch() { sudo pacman -Syu --noconfirm "$@"; }

# Funciones de instalación
install_nvim() {
    { [ "$DISTRO" = 'popos' ] && install_popos neovim; } || { [ "$DISTRO" = 'arch' ] && install_arch neovim; }
    git clone https://github.com/carlosGomezMojica/starter ~/.config/nvim && install_status[nvim]="✅" || install_status[nvim]="❌"
    update_progress
}

install_zsh() {
    { [ "$DISTRO" = 'popos' ] && install_popos zsh; } || { [ "$DISTRO" = 'arch' ] && install_arch zsh; }
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

    sed -i 's/^plugins=(\(.*\))/plugins=(\1 zsh-syntax-highlighting zsh-autosuggestions zsh-history-substring-search you-should-use fzf-tab)/' ~/.zshrc
}

install_docker() {
    { [ "$DISTRO" = 'popos' ] && install_popos docker.io; } || { [ "$DISTRO" = 'arch' ] && install_arch docker; }
    sudo systemctl enable --now docker
    sudo usermod -aG docker $USER
}

install_lazydocker() {
    curl https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash
}

install_lazygit() {
    { [ "$DISTRO" = 'popos' ] && { sudo add-apt-repository ppa:lazygit-team/release -y; sudo apt update; sudo apt install -y lazygit; }; } ||
    { [ "$DISTRO" = 'arch' ] && install_arch lazygit; }
}

install_zoxide() {
    curl -sS https://webinstall.dev/zoxide | bash
}

install_tldr() {
    npm install -g tldr || install_arch tldr
}

install_aws_cli() {
    { [ "$DISTRO" = 'popos' ] && install_popos awscli; } || { [ "$DISTRO" = 'arch' ] && install_arch aws-cli; }
}

install_nvm() {
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash
}

install_pnpm() {
    curl -fsSL https://get.pnpm.io/install.sh | sh -
}

install_zathura() {
    { [ "$DISTRO" = 'popos' ] && install_popos zathura; } || { [ "$DISTRO" = 'arch' ] && install_arch zathura; }

    CONFIG_DIR="$HOME/.config/zathura"
    mkdir -p "$CONFIG_DIR"
    cat > "$CONFIG_DIR/zathurarc" << EOL
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

install_pnpm() {
    curl -fsSL https://get.pnpm.io/install.sh | sh -
}

install_kitty() {
    { [ "$DISTRO" = 'popos' ] && install_popos kitty; } || { [ "$DISTRO" = 'arch' ] && install_arch kitty; }
    git clone https://github.com/carlosGomezMojica/kitty-solarized-osaka ~/.config/kitty
}

# Ejecutar todas las instalaciones
main() {
    detect_distro
    tareas=("install_nvim" "install_zsh" "install_oh_my_zsh" "install_docker" "install_lazydocker" "install_lazygit" "install_zoxide" "install_tldr" "install_aws_cli" "install_nvm" "install_pnpm" "install_zathura" "install_kitty")

    for tarea in "${tareas[@]}"; do
        ((current_step++))
        echo -e "\n🔧 Ejecutando: $tarea"
        if $tarea; then
            install_status[$tarea]="✅"
        else
            install_status[$tarea]="❌"
        fi
        echo "Progreso: $((current_step * 100 / total_steps))% completado"
        sleep 1
    done
}

# Ejecución principal
detect_distro
main_installations

# Resumen
echo -e "\nResumen de la instalación:"
for tool in "${!install_status[@]}"; do
    echo "$tool: ${install_status[$tool]}"
done

 
