#!/usr/bin/env zsh

set -e

version=$1
if [ "$version" = "" ]; then
  version=24.08
fi

# Remove all dots
ver=${version//./}

curl -L https://sourceforge.net/projects/sevenzip/files/7-Zip/${version}/7z${ver}-src.tar.xz/download \
     --output 7z${ver}-src.tar.xz

tar xvf 7z${ver}-src.tar.xz

if [ -d 7z${ver}-src ]; then
  pushd 7z${ver}-src
else
  pushd .
fi

pushd CPP/7zip/Bundles/Alone

export SDKROOT=`xcrun --sdk macosx --show-sdk-path`
export MACOSX_DEPLOYMENT_TARGET=10.13

make -j -f ../../cmpl_mac_arm64.mak
make -j -f ../../cmpl_mac_x64.mak

lipo -create b/m_arm64/7za b/m_x64/7za -output b/7za
lipo -archs b/7za
otool -L b/7za

b/7za --help

popd

popd

