#!/bin/bash

###
# @Author: EagleXiang
# @LastEditors: EagleXiang
# @Email: eagle.xiang@outlook.com
# @Github: https://github.com/eaglexiang
# @Date: 2019-08-24 11:16:00
# @LastEditTime: 2019-08-25 13:31:50
###

# $1 为文件名
copy_config() {
    if [ -f "$root/etc/eagle-tunnel.d/$1" ]; then
        echo "find $1, new file will be named $1_new"
        cp "./config/$1" "$root/etc/eagle-tunnel.d/$1_new"
    else
        cp "./config/$1" "$root/etc/eagle-tunnel.d/$1"
    fi
}

# main
if [ "$1" == "test" ] && [ "$2" == "clean" ]
then
    rm -rf "$(pwd)/test"
    exit 0
elif [ "$1" == "test" ]
then
    root="$(pwd)/test"
fi


# user check
if [ X"$root" == "X" ];then # root not specific
    if [ $UID -ne 0 ]; then
        echo "this script requires superuser privileges."
        exit 1
    fi
fi

# copy files

# lib
echo "lib installing..."
mkdir -p "$root/usr/eagle-tunnel"
\cp -f ./et.go.linux "$root/usr/eagle-tunnel/"

# etc
echo "etc installing..."
mkdir -p "$root/etc/eagle-tunnel.d"
copy_config client.conf
copy_config server.conf
copy_config users.list
\cp -rf ./config/hosts "$root/etc/eagle-tunnel.d/"
# proxylists
proxylists_dir="$root/etc/eagle-tunnel.d/proxylists"
mkdir -p "$proxylists_dir"
cp ./config/clearDomains/proxylist.txt "$proxylists_dir/"
# directlists
directlists_dir="$root/etc/eagle-tunnel.d/directlists"
mkdir -p "$directlists_dir"
cp ./config/clearDomains/directlist.txt "$directlists_dir/"

# bin
echo "bin installing..."
mkdir -p "$root/bin"
ln -sf "$root/usr/lib/eagle-tunnel/et.go.linux" "$root/bin/et"

# systemd
echo "systemd units installing..."
mkdir -p "$root/usr/lib/systemd/system"
\cp -f ./nix/systemd/* "$root/usr/lib/systemd/system"
if [ X"$root" == "X" ];then # root not specific
    systemctl daemon-reload
fi

echo "done"