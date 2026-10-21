# syntax=docker/dockerfile:1
# Swaps the Node binary of an upstream image for the patched one of the same
# major (October 2026 security release: 22.23.4 / 24.22.1).
ARG BASE
ARG FLAVOR=alpine
FROM node:22-${FLAVOR} AS n22
FROM node:24-${FLAVOR} AS n24

FROM ${BASE}
ARG RESTORE_USER=root
USER root
RUN --mount=type=bind,from=n22,source=/usr/local/bin/node,target=/tmp/node22 \
    --mount=type=bind,from=n24,source=/usr/local/bin/node,target=/tmp/node24 \
    set -e; \
    p=$(readlink -f "$(command -v node)"); \
    old=$(node -v); m=$(node -p 'process.versions.node.split(".")[0]'); \
    [ -f "/tmp/node$m" ] || { echo "no patched binary for Node $m"; exit 1; }; \
    cp "/tmp/node$m" "$p"; \
    echo "$p: $old -> $(node -v)"; \
    node -e 'require("zlib").brotliDecompressSync(require("zlib").brotliCompressSync("ok"))'
USER ${RESTORE_USER}
