#! /bin/bash

export SRCFILE=nim-$VERSION.tar.xz
export BINFILE=nim-$VERSION-linux_x$ARCH.tar

echo "Building Nim $VERSION for $ARCH"

set -e

# Activate Holy Build Box environment.
source /hbb_exe/activate

set -x

# Install xz
yum -y install wget xz || yum clean all

# Extract and enter source
tar -xJf /io/$SRCFILE
cd nim-$VERSION

# Compile
case $ARCH in
  32) cpu="i386" ;;
  64) cpu="amd64" ;;
esac

./build.sh --cpu $cpu
./bin/nim c koch
./koch boot -d:release
./koch tools -d:release

# Cleanup
find -name *.o | xargs rm -f
find -name nimcache | xargs rm -rf
rm -f compiler/nim0
rm -f compiler/nim1
rm -f compiler/nim
rm -f /io/$BINFILE.xz

# Create XZ
cd ..
tar cf $BINFILE nim-$VERSION
xz -9fc $BINFILE > /io/$BINFILE.xz
