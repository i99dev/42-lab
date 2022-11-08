#!/bin/bash

# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    42_lab.sh                                          :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: oal-tena <oal-tena@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2022/11/08 10:13:15 by oal-tena          #+#    #+#              #
#    Updated: 2022/11/08 10:13:15 by oal-tena         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

if [[ "$OSTYPE" == "darwin"* ]]; then
    if ! command -v xcode-select &> /dev/null
    then
        echo "xcode-select could not be found"
        echo "installing xcode-select"
        xcode-select --install
    fi
    echo "xcode-select is installed"
    echo "adding xcode-select to path"
    eval "$(/usr/bin/xcode-select --install)"
fi

if [[ "$OSTYPE" == "darwin"* ]]; then
    if ! command -v brew &> /dev/null
    then
        echo "brew could not be found"
        echo "installing brew"
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    echo "brew is installed"
    echo "adding brew to path"
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi


pkg_arr=("man-db"\
    "less"\
    "build-essential"\
    "libtools"\
    "valgrind"\
    "gdb"\
    "automake"\
    "make"\
    "ca-certificates"\
    "g++"\
    "libtool"\
    "pkg-config"\
    "manpages-dev"\
    "zip"\
    "unzip"\
    "python3"\
    "python3-pip"\
    "git"\
    "openssh-server"\
    "dialog"\
    "llvm"\
    "curl"\
    "zsh"\
    "wget"\
    "clang"\
    "nano"\
    "vim"\
    "moreutils"\
    "python3-tk"\
    "ruby"\
    "bc"\
    "zlib1g-dev"\
    "libxext-dev"\
    "libx11-dev"\
    "libbsd-dev"\
    "libreadline-dev"\
    "lldb"\
    "htop"\
    "xorg")

install_pkg() {
    if [[ "$OSTYPE" == "linux-gnu" ]]; then
        sudo apt-get install -y $1
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        brew install $1
    fi
}

clean_pkg() {
    if [[ "$OSTYPE" == "linux-gnu" ]]; then
        sudo apt-get clean autoclean
        sudo apt-get autoremove --yes
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        brew cleanup
    fi
}

install_pkg_by_arr() {
    if [[ "$OSTYPE" == "linux-gnu" ]]; then
        for i in "${pkg_arr[@]}"
        do
            if ! dpkg -s $i > /dev/null 2>&1; then
                install_pkg $i
            fi
        done
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        for i in "${pkg_arr[@]}"
        do
            if ! brew ls --versions $i > /dev/null 2>&1; then
                install_pkg $i
            fi
        done
    fi
}

apt-get update
install_pkg_by_arr
clean_pkg


read -p "Do you want to install norminette? [y/n] " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
    if ! command -v norminette &> /dev/null
    then
        echo "norminette could not be found"
        echo "installing norminette"
        python3 -m pip install --upgrade pip setuptools && python3 -m pip install norminette
    fi
fi

read -p "Do you want to install miniLibX (need for graphics project)? [y/n] " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
    if [[ "$OSTYPE" == "linux-gnu" ]]; then
        git clone https://github.com/42Paris/minilibx-linux.git /usr/local/minilibx-linux
        sleep 5
        cd /usr/local/minilibx-linux && ./configure \
        && cp /usr/local/minilibx-linux/*.a /usr/local/lib \
        && cp /usr/local/minilibx-linux/*.h /usr/local/include \
        && cp -R /usr/local/minilibx-linux/man/* /usr/local/man/ \
        && /sbin/ldconfig
    elif [[ "$OSTYPE" == "darwin"* ]]; then
       echo "miniLibX for mac you can download from 42 intra"
    fi
fi

# ask if user wants to install oh-my-zsh
read -p "Do you want to install oh-my-zsh? [y/n] " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi