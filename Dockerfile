# syntax=docker/dockerfile:1
# Build context: ~/master (root) — needed for spectre crate dependencies
#
# docker build -f ai-agent-os/Dockerfile -t ai-agent-os .

FROM rust:1.87-bookworm AS builder

RUN apt-get update && apt-get install -y --no-install-recommends \
    pkg-config \
    libssl-dev \
    libsystemd-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /build

# spectre workspace deps (path dependencies from ai-agent-os/Cargo.toml)
COPY spectre/Cargo.toml spectre/Cargo.lock ./spectre/
COPY spectre/crates/spectre-events ./spectre/crates/spectre-events
COPY spectre/crates/spectre-core   ./spectre/crates/spectre-core

# ai-agent-os workspace
COPY ai-agent-os ./ai-agent-os

WORKDIR /build/ai-agent-os
RUN cargo build --release -p agent-core --bin ai-agent

# ── Runtime ──────────────────────────────────────────────────────────────────
FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    libsystemd0 \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /build/ai-agent-os/target/release/ai-agent /usr/local/bin/ai-agent-os

ENV NATS_URL=nats://nats:4222

CMD ["ai-agent-os"]
