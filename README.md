# Herramientas de Desarrollo y sus Archivos de Configuración

## 1. tmux

**Descripción:** `tmux` es un multiplexor de terminal que permite a los usuarios crear, acceder y controlar múltiples terminales desde una sola pantalla. Es especialmente útil para mantener sesiones de terminal persistentes y organizar el espacio de trabajo en múltiples paneles y ventanas.

**Archivo de configuración:** `~/.tmux.conf`  
**Documentación:** [tmux](https://github.com/tmux/tmux/wiki)

## 2. zsh

**Descripción:** `zsh` es un potente intérprete de comandos para sistemas Unix que ofrece características avanzadas como autocompletado, corrección de errores tipográficos y una alta capacidad de personalización.

**Archivo de configuración:** `~/.zshrc`  
**Documentación:** [zsh](https://zsh.sourceforge.io/)

## 3. Oh My Zsh

**Descripción:** `Oh My Zsh` es un framework de código abierto para gestionar la configuración de `zsh`. Facilita la gestión de plugins, temas y otras configuraciones, mejorando la experiencia en la línea de comandos.

**Directorio de configuración:** `~/.oh-my-zsh/`  
**Documentación:** [Oh My Zsh](https://ohmyz.sh/)

## 4. Neovim (nvim)

**Descripción:** `Neovim` es una versión mejorada de Vim, diseñada para facilitar la extensión y la integración con otras herramientas. Ofrece una interfaz más moderna y soporte para plugins asíncronos.

**Directorio de configuración:** `~/.config/nvim/`  
**Documentación:** [Neovim](https://neovim.io/)

## 5. AWS CLI

**Descripción:** La `AWS Command Line Interface (CLI)` es una herramienta unificada para gestionar servicios de AWS desde la línea de comandos, permitiendo automatizar tareas y administrar recursos de manera eficiente.

**Archivo de configuración:** `~/.aws/config`  
**Documentación:** [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/)

## 6. nvm

**Descripción:** `nvm` (Node Version Manager) es una herramienta que permite instalar y gestionar múltiples versiones de Node.js en un mismo sistema, facilitando el cambio entre versiones según sea necesario.

**Directorio de instalación:** `~/.nvm/`  
**Documentación:** [nvm](https://github.com/nvm-sh/nvm)

**Nota:** `nvm` no tiene un archivo de configuración global, pero se inicializa en el archivo de configuración del shell, como `~/.zshrc`.

## 7. pnpm

**Descripción:** `pnpm` es un gestor de paquetes para Node.js que utiliza enlaces simbólicos y una caché global para ahorrar espacio en disco y acelerar las instalaciones.

**Archivo de configuración:** `~/.npmrc`  
**Documentación:** [pnpm](https://pnpm.io/)

**Nota:** Aunque `pnpm` utiliza el archivo `~/.npmrc` para su configuración, también puede tener su propio archivo de configuración en `~/.pnpmfile.cjs`.

## 8. Docker

**Descripción:** `Docker` es una plataforma que permite desarrollar, enviar y ejecutar aplicaciones dentro de contenedores, proporcionando un entorno consistente y aislado para las aplicaciones.

**Archivo de configuración del daemon:** `/etc/docker/daemon.json`  
**Directorio de configuración del cliente:** `~/.docker/`  
**Documentación:** [Docker](https://docs.docker.com/)

## 9. Zathura

**Descripción:** `Zathura` es un visor de documentos ligero y altamente configurable, compatible con formatos como PDF, DjVu y PostScript.

**Directorio de configuración:** `~/.config/zathura/`  
**Documentación:** [Zathura](https://pwmt.org/projects/zathura/)

## 10. zoxide

**Descripción:** `zoxide` es un gestor de directorios que permite un acceso rápido a los directorios más frecuentados, mejorando la eficiencia en la navegación del sistema de archivos desde la línea de comandos.

**Archivo de configuración:** `~/.zoxide.toml`  
**Documentación:** [zoxide](https://github.com/ajeetdsouza/zoxide)

**Nota:** Si no se encuentra el archivo de configuración, `zoxide` utiliza valores predeterminados.

## 11. tldr

**Descripción:** `tldr` es una herramienta de línea de comandos que ofrece versiones simplificadas y concisas de las páginas de manual tradicionales (`man`). Su objetivo es proporcionar ejemplos prácticos y directos sobre el uso de comandos comunes, facilitando su comprensión y aplicación.

**Archivo de configuración:** `~/.tldr/cache`  
**Documentación:** [tldr](https://tldr.sh/)

**Ejemplo de uso:**

```bash
tldr ls
```
