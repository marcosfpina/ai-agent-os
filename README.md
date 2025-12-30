# AI Agent OS

Native OS-level monitoring agent with Hyprland integration, built in Rust for maximum performance.

## 🎯 Overview

AI Agent OS is a lightweight, high-performance system monitoring agent designed to run natively on NixOS with deep Hyprland/Wayland integration. It provides:

- **Real-time system monitoring** (CPU, memory, disk, thermal, network)
- **Journald log collection** with intelligent filtering
- **Hyprland IPC integration** for compositor-level control
- **Alert system** for proactive issue detection
- **Minimal footprint** (< 20MB idle, < 100MB active)

## 🏗️ Architecture

The project is organized as a Cargo workspace with four crates:

```
ai-agent-os/
├── crates/
│   ├── agent-core/       # Main orchestrator
│   ├── system-monitor/   # System metrics collection
│   ├── hyprland-ipc/     # Hyprland compositor integration
│   └── log-collector/    # Journald log streaming
├── Cargo.toml            # Workspace configuration
└── flake.nix             # Nix build configuration
```

### Component Details

#### 1. **hyprland-ipc** 
- Unix socket communication with Hyprland
- Workspace and window management
- Event subscription (window open/close, workspace changes)
- Screen capture capabilities

#### 2. **system-monitor**
- CPU usage (global + per-core)
- Memory and swap metrics
- Disk usage and I/O
- Thermal sensors
- Network interfaces
- Load averages

#### 3. **log-collector**
- Systemd journal integration
- Real-time log streaming
- Priority-based filtering
- Unit-specific log queries
- Critical error detection

#### 4. **agent-core**
- Orchestrates all subsystems
- Alert generation and management
- Configuration management
- Async task coordination

## 🚀 Quick Start

### Development with Nix

```bash
# Enter development shell
cd ai-agent-os
nix develop

# Build the project
cargo build

# Run the agent
cargo run

# Watch mode (auto-rebuild on changes)
cargo watch -x run

# Run tests
cargo test
```

### Building with Nix

```bash
# Build the package
nix build .#ai-agent

# Run directly
nix run .#ai-agent
```

## 📦 Installation

### NixOS Integration

Add to your NixOS configuration:

```nix
{
  environment.systemPackages = [
    (pkgs.callPackage ./ai-agent-os { })
  ];

  # Optional: Run as systemd service
  systemd.user.services.ai-agent = {
    description = "AI Agent OS Monitoring";
    wantedBy = [ "default.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.ai-agent}/bin/ai-agent";
      Restart = "on-failure";
    };
  };
}
```

## ⚙️ Configuration

The agent can be configured via `AgentConfig`:

```rust
use agent_core::{Agent, AgentConfig};

let config = AgentConfig {
    monitoring_interval_secs: 5,        // Metrics collection interval
    thermal_threshold_celsius: 75.0,    // Temperature alert threshold
    memory_threshold_percent: 85.0,     // Memory usage alert threshold
    enable_hyprland: true,              // Enable Hyprland integration
    ..Default::default()
};

let agent = Agent::with_config(config)?;
```

## 🔧 Development

### Requirements

- Rust 1.75+ (provided by Nix)
- systemd (for journald integration)
- Hyprland (optional, for compositor integration)

### Project Structure

```
crates/
├── agent-core/
│   ├── src/
│   │   ├── lib.rs       # Core agent logic
│   │   └── main.rs      # CLI binary
│   └── Cargo.toml
├── system-monitor/
│   ├── src/lib.rs       # System metrics
│   └── Cargo.toml
├── hyprland-ipc/
│   ├── src/lib.rs       # Hyprland IPC client
│   └── Cargo.toml
└── log-collector/
    ├── src/lib.rs       # Journald integration
    └── Cargo.toml
```

### Testing

```bash
# Run all tests
cargo test

# Test specific crate
cargo test -p system-monitor

# Run with logging
RUST_LOG=debug cargo run
```

### Linting

```bash
# Run clippy
cargo clippy

# Format code
cargo fmt

# Check formatting
cargo fmt -- --check
```

## 📊 Performance Targets

- **Memory**: < 20MB idle, < 100MB active
- **CPU**: < 1% idle, < 10% active  
- **Startup**: < 200ms
- **Latency**: < 1ms p50, < 10ms p99

## 🎯 Roadmap

### Phase 1: Foundation ✅
- [x] Rust workspace structure
- [x] Hyprland IPC basics
- [x] System monitoring
- [x] Log collection
- [x] Nix integration

### Phase 2: Intelligence (Next)
- [ ] ML-based anomaly detection
- [ ] Predictive alerts
- [ ] Pattern recognition
- [ ] Auto-remediation

### Phase 3: UI Integration
- [ ] Tauri desktop app
- [ ] Real-time dashboard
- [ ] Visual analytics
- [ ] Global hotkeys

### Phase 4: Multimodal AI
- [ ] Vision capabilities (screen analysis)
- [ ] Voice interface (Whisper)
- [ ] LLM integration (problem-solving)
- [ ] Proactive assistance

## 🔒 Security

- Runs with minimal privileges
- No network access required
- Sandbox-friendly design
- Audit logging
- SOPS integration for secrets

## 📝 License

MIT License - See LICENSE file for details

## 🤝 Contributing

Contributions welcome! Please:

1. Fork the repository
2. Create a feature branch
3. Write tests for new functionality
4. Ensure `cargo test` and `cargo clippy` pass
5. Submit a pull request

## 📚 Documentation

For detailed architecture documentation, see:
- [`docs/AI-AGENT-OS-ARCHITECTURE.md`](../docs/AI-AGENT-OS-ARCHITECTURE.md)
- Individual crate `src/lib.rs` files for API documentation

## 🐛 Troubleshooting

### "Failed to open systemd journal"
- Ensure systemd is running
- Check user has access to journal: `journalctl --user`

### "Hyprland socket not found"
- Verify running under Hyprland: `echo $HYPRLAND_INSTANCE_SIGNATURE`
- Check socket exists: `ls $XDG_RUNTIME_DIR/hypr/*/`

### Build issues
- Update Rust: `rustup update`
- Clean build: `cargo clean && cargo build`
- Check Nix: `nix flake check`

## 📧 Contact

For questions or issues, please open a GitHub issue.