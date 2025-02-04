#!/bin/bash

SCRIPT_REPO="https://github.com/oneapi-src/oneVPL.git"
SCRIPT_COMMIT="17f1ef9abb52c10ca88c57508a30de63c4e1bb16"

ffbuild_enabled() {
    [[ $TARGET == *arm64 ]] && return -1
    return -1
}

ffbuild_dockerbuild() {
    git-mini-clone "$SCRIPT_REPO" "$SCRIPT_COMMIT" onevpl
    cd onevpl

    mkdir build && cd build

    cmake -GNinja -DCMAKE_TOOLCHAIN_FILE="$FFBUILD_CMAKE_TOOLCHAIN" -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX="$FFBUILD_PREFIX" \
        -DCMAKE_INSTALL_BINDIR="$FFBUILD_PREFIX"/bin -DCMAKE_INSTALL_LIBDIR="$FFBUILD_PREFIX"/lib \
        -DBUILD_DISPATCHER=ON -DBUILD_DEV=ON \
        -DBUILD_PREVIEW=OFF -DBUILD_TOOLS=OFF -DBUILD_TOOLS_ONEVPL_EXPERIMENTAL=OFF -DINSTALL_EXAMPLE_CODE=OFF \
        -DBUILD_SHARED_LIBS=OFF -DBUILD_TESTS=OFF ..

    ninja -j$(nproc)
    ninja install

    rm -rf "$FFBUILD_PREFIX"/{etc,share}

    cat /opt/ffbuild/lib/pkgconfig/vpl.pc
}

ffbuild_configure() {
    return 0
    echo --enable-libvpl
}

ffbuild_unconfigure() {
    return 0
    echo --disable-libvpl
}
