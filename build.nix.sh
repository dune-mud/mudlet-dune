#! /usr/bin/env nix-shell
#! nix-shell -i bash -p adoptopenjdk-jre-bin

MUDDLE="${MUDDLE:-../muddle-shadow-1.0.1/bin/muddle}" ./build.sh
