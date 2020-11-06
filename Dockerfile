# Use the container supplied by `cross` as a starting point
FROM rustembedded/cross:armv7-unknown-linux-gnueabihf-0.2.1

# Install the target system with multistrap
RUN apt-get update && apt-get install multistrap --assume-yes
COPY multistrap-config /
RUN multistrap -a armhf -f multistrap-config /sysroot-armhf

# Fix the absolute symlinks in the target distribution
COPY relink.sh /
RUN cd /sysroot-armhf && /relink.sh

# Fix openssl configuration problems by linking a header
# into the right place
RUN ln -s /sysroot-armhf/usr/include/arm-linux-gnueabihf/openssl/opensslconf.h \
          /sysroot-armhf/usr/include/openssl/

# Set up paths and flags for compiling on the target architecture.
ENV PKG_CONFIG_LIBDIR_armv7_unknown_linux_gnueabihf=/sysroot-armhf/usr/lib/arm-linux-gnueabihf/pkgconfig
ENV PKG_CONFIG_SYSROOT_DIR_armv7_unknown_linux_gnueabihf=/sysroot-armhf
ENV CARGO_TARGET_ARMV7_UNKNOWN_LINUX_GNUEABIHF_RUSTFLAGS="-C link-arg=--sysroot=/sysroot-armhf"
