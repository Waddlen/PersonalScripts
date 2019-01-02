## WIP
#Variables
GCC_VER="7.3"
BOOST_VER="1_69_0"
WINE_VER="staging" # Alternatively Devel, Stable
VULKAN_SDK_URL="https://sdk.lunarg.com/sdk/download/1.1.92.1/windows/VulkanSDK-1.1.92.1-Installer.exe"


mkdir -p ~/VK9/
cd ~/VK9/

###install prerequisites
sudo apt install -y g++-mingw-w64 gcc-mingw-w64 binutils-mingw-w64 mingw-w64-tools meson cmake rename

###configure gcc threading
sudo update-alternatives --set x86_64-w64-mingw32-gcc /usr/bin/x86_64-w64-mingw32-gcc-posix
sudo update-alternatives --set x86_64-w64-mingw32-g++ /usr/bin/x86_64-w64-mingw32-g++-posix
sudo update-alternatives --set i686-w64-mingw32-gcc /usr/bin/i686-w64-mingw32-gcc-posix
sudo update-alternatives --set i686-w64-mingw32-g++ /usr/bin/i686-w64-mingw32-g++-posix

# tar -xvzf community_images.tar.gz
# note v is for verbose, disable?

### Setup Boost
wget https://dl.bintray.com/boostorg/release/1.69.0/source/boost_$BOOST_VER.tar.gz
tar -xvzf boost_$BOOST_VER.tar.gz

cd boost_$BOOST_VER

cat > user-config-x86.jam << EOF
using gcc : $GCC_VER : i686-w64-mingw32-g++
    :
    <rc>i686-w64-mingw32-windres
    <archiver>i686-w64-mingw32-ar
;
EOF

./bootstrap.sh

./b2 toolset=gcc target-os=windows variant=release threading=multi threadapi=win32 address-model=32 link=static runtime-link=static --prefix=/usr/i686-w64-mingw32/include --user-config=user-config-x86.jam -j 4 --with-system --with-thread --with-filesystem --with-program_options --with-log -sNO_BZIP2=1 -sNO_ZLIB=0 -a -d+2 --layout-tagged




# Seems to be unecessary in boost 1.6.9
# sudo mv libboost_thread_win32.a libboost_thread.a

cd ./stage/lib/

rename "s/\.a/-mt-$BOOST_VER.a/" libboost*

sudo cp ./* /usr/i686-w64-mingw32/lib/

cd ../../


#64-bit boost

rm -rf ./stage/ ./bin.v2/ user-config-x86.jam

cat > user-config-x64.jam << EOF
using gcc : $GCC_VER : x86_64-w64-mingw32-g++
    :
    <rc>x86_64-w64-mingw32-windres
    <archiver>x86_64-w64-mingw32-ar
;
EOF

./bootstrap.sh
./b2 toolset=gcc target-os=windows variant=release threading=multi threadapi=win32 address-model=64 link=static runtime-link=static --prefix=/usr/x86_64-w64-mingw32/include --user-config=user-config-x64.jam -j 4 --with-system --with-thread --with-filesystem --with-program_options --with-log -sNO_BZIP2=1 -sNO_ZLIB=0 -a -d+2 --layout-tagged

# Seems to be unecessary in boost 1.6.9
# sudo mv libboost_thread_win32.a libboost_thread.a


cd ./stage/lib/

rename "s/\.a/-mt-$BOOST_VER.a/" libboost*

sudo cp ./* /usr/x86_64-w64-mingw32/lib

cd ../../



sudo cp ./boost/*.hpp /usr/i686-w64-mingw32/include
sudo cp ./boost/*.hpp /usr/x86_64-w64-mingw32/include

cd ../

wget $VULKAN_SDK_URL -O VulkanSDK-Installer.exe

#WINE
sudo dpkg --add-architecture i386 
wget -nc https://dl.winehq.org/wine-builds/winehq.key
sudo apt-key add winehq.key
sudo apt-add-repository https://dl.winehq.org/wine-builds/ubuntu/
sudo apt install --install-recommends winehq-$WINE_VER




