# ABOUTME: Homebrew formula for PS Mirror Server
# ABOUTME: Installs WebSocket relay that bridges Photoshop to iOS

class PsMirrorServer < Formula
  desc "WebSocket relay server for PS Mirror - Photoshop to iOS preview"
  homepage "https://github.com/hex/PS-Mirror"
  url "https://github.com/hex/PS-Mirror/archive/refs/heads/main.tar.gz"
  version "2025.12.6"
  sha256 "0019dfc4b32d63c1392aa264aed2253c1e0c2fb09216f8e2cc269bbfb8bb49b5"
  license "MIT"
  head "https://github.com/hex/PS-Mirror.git", branch: "main"

  depends_on "oven-sh/bun/bun"

  def install
    # Install server files to libexec
    libexec.install Dir["server/*"]

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
