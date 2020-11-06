# crossbuild-spotifyd

Cross-compile the Rust Application [spotifyd](https://github.com/Spotifyd/spotifyd) for the Raspberry Pi, using `cross`, `multistrap`.

This is an example repo for a blog post on capnfabs.net.

## Checkout / Build instructions

These instructions assume you've already got [Rust](https://www.rust-lang.org/tools/install) and [Docker](https://docs.docker.com/engine/install/) installed.

```sh
# Install cross (https://github.com/rust-embedded/cross)
cargo install cross

# Clone repo and spotifyd (pinned to a commit in a submodule)
git clone --recursive https://github.com/capnfabs/crossbuild-spotifyd
cd crossbuild-spotifyd

# Build and tag the docker container
docker build -t crossbuild:local .

# Switch into the spotifyd repo
cd spotifyd

# Tell Cross to use our new Docker container
echo -e '[target.armv7-unknown-linux-gnueabihf]\nimage = "crossbuild:local"' >> Cross.toml

# Build!
cross build --target=armv7-unknown-linux-gnueabihf --features=dbus_mpris
```
