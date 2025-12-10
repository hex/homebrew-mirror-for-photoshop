# Homebrew Tap for Mirror for Photoshop

This tap contains the formula for [Mirror for Photoshop Server](https://github.com/hex/Mirror-for-Photoshop) - a WebSocket relay that bridges Photoshop to iOS for real-time preview.

## Installation

```bash
brew tap hex/mirror-for-photoshop
brew install mirror-for-photoshop-server
```

## Usage

Run in foreground:
```bash
mirror-for-photoshop-server
```

Run on custom port:
```bash
mirror-for-photoshop-server --port 9000
```

Run as background service:
```bash
brew services start mirror-for-photoshop-server
```

Stop background service:
```bash
brew services stop mirror-for-photoshop-server
```

## Requirements

- macOS 12.0+
- Bun (installed automatically by Homebrew)

## Uninstall

```bash
brew uninstall mirror-for-photoshop-server
brew untap hex/mirror-for-photoshop
```
