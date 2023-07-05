install_cargo_dep()
{
    if ! command -v $1 >/dev/null 2>&1; then
        echo "$1 bulunamadi..."
        cargo install $1
    else
        echo "$1 zaten yuklu"
    fi
}

install_with_apt()
{
    if ! command -v $1 >/dev/null 2>&1; then
        echo "$1 bulunamadi..."
        sudo apt install $1
    else
        echo "$1 zaten yuklu :)"
    fi
}
install_neovim ()
{
    if command -v nvim.appimage >/dev/null 2>&1; then
        echo "Neovim yuklu"
    else
        echo "Neovim bulunamadi... Yukleniyor."
        wget https://github.com/neovim/neovim/releases/download/stable/nvim.appimage
        chmod +x nvim.appimage
        sudo ln -s $PWD/nvim.appimage /usr/local/bin/
        echo "Neovim yuklendi."
    fi
}

install_rust_and_dependencies ()
{
    if command -v cargo >/dev/null 2>&1; then
        echo "Rust zaten yuklu"
    else
        echo "Rust bulunamadi... Yukleniyor"
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
    fi
    . ~/.bashrc

    install_cargo_dep fd-find
    install_cargo_dep ripgrep

    if command -v node >/dev/null 2>&1; then
        echo "Nodejs zaten yuklu"
    else
        install_cargo_dep fnm
        . ~/.bashrc
        fnm install 18.16.1
        . ~/.bashrc
    fi
}

setup()
{ 
    install_with_apt stow
    rm ~/.bashrc
    stow */
}

install_with_apt wget
install_neovim
install_rust_and_dependencies
setup
