#!/bin/bash
# Install opus-tools & ffmpeg
# Latest releases: opus 1.3.1, opus-tools 0.2, opusfile 0.11, libopusenc 0.2.1, ffmpeg 4.4

set -e
set -o pipefail

# Download necessary files

TEMP_FOLDER="$(mktemp -d)"

# Opusfile 0.11
curl -Ls https://downloads.xiph.org/releases/opus/opusfile-0.11.tar.gz | tar xz -C "$TEMP_FOLDER"
# Opus 1.3.1
curl -Ls https://archive.mozilla.org/pub/opus/opus-1.3.1.tar.gz | tar xz -C "$TEMP_FOLDER"
# Libopusenc 0.2.1
curl -Ls https://archive.mozilla.org/pub/opus/libopusenc-0.2.1.tar.gz | tar xz -C "$TEMP_FOLDER"
# Opus Tools 0.2
curl -Ls https://archive.mozilla.org/pub/opus/opus-tools-0.2.tar.gz | tar xz -C "$TEMP_FOLDER"
# yasm 1.3.0
curl -Ls http://www.tortall.net/projects/yasm/releases/yasm-1.3.0.tar.gz | tar xz -C "$TEMP_FOLDER"
# ffmpeg 4.4
curl -Ls https://ffmpeg.org/releases/ffmpeg-4.4.tar.gz | tar xz -C "$TEMP_FOLDER"

# Compile
cd "$TEMP_FOLDER"/opus-1.3.1 || exit
./configure
make -j$(nproc) && make install

cd "$TEMP_FOLDER"/opusfile-0.11 || exit
./configure
make -j$(nproc) && make install

cd "$TEMP_FOLDER"/libopusenc-0.2.1 || exit
./configure
make -j$(nproc) && make install

cd "$TEMP_FOLDER"/opus-tools-0.2 || exit
./configure
make -j$(nproc) && make install && ldconfig
cp "$TEMP_FOLDER"/opus-tools-0.2/opusrtp /usr/local/bin

cd "$TEMP_FOLDER"/yasm-1.3.0 || exit
./configure
make -j$(nproc) && make install

cd "$TEMP_FOLDER"/ffmpeg-4.4 || exit
./configure --disable-debug --enable-static --enable-libopus --enable-encoder=libopus
make -j$(nproc) && make install

rm -rf "$TEMP_FOLDER" && cd /opt
