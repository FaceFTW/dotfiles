#!/bin/bash
set -e

# Generate all astal libraries into unified crate structure
gir -c Gir.toml

# Generate sys crate bindings (if needed)
# gir -c sys/Gir.toml

echo "Generated all astal bindings into src/*/"