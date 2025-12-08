# ABOUTME: Homebrew formula for PS Mirror Server
# ABOUTME: Installs WebSocket relay that bridges Photoshop to iOS

class PsMirrorServer < Formula
  desc "WebSocket relay server for PS Mirror - Photoshop to iOS preview"
  homepage "https://github.com/hex/PS-Mirror"
  url "https://github.com/hex/ps-mirror-server/releases/download/v2025.12.16/ps-mirror-server-2025.12.16.tar.gz"
  sha256 "f77b45131549a02abf63fd32f39cdc95b79f5fd345010b8dea7ef1bb692213a9"
  license "MIT"

  depends_on "oven-sh/bun/bun"

  def install
    # Install server files to libexec
    libexec.install Dir["*"]

    # Install dependencies
    cd libexec do
      system "bun", "install"
    end

    # Create wrapper script
    (bin/"ps-mirror-server").write <<~EOS
      #!/bin/bash
      exec "#{Formula["oven-sh/bun/bun"].opt_bin}/bun" "#{libexec}/server.js" "$@"
    EOS
  end

  service do
    run [opt_bin/"ps-mirror-server"]
    keep_alive true
    log_path var/"log/ps-mirror-server.log"
    error_log_path var/"log/ps-mirror-server.log"
    working_dir var
  end

  test do
    assert_match "ps-mirror-server", shell_output("#{bin}/ps-mirror-server --version")
  end
end
