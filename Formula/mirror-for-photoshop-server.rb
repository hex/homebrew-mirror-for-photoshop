# ABOUTME: Homebrew formula for Mirror for Photoshop Server
# ABOUTME: Installs WebSocket relay that bridges Photoshop to iOS

class MirrorForPhotoshopServer < Formula
  desc "WebSocket relay server for Mirror for Photoshop - Photoshop to iOS preview"
  homepage "https://github.com/hex/Mirror-for-Photoshop"
  url "https://github.com/hex/mirror-for-photoshop-server/releases/download/v2025.12.38/mirror-for-photoshop-server-2025.12.38.tar.gz"
  sha256 "29b9d485216bdef3cb4201c96200386767e0dbfab23daf1a2810f326af1de504"
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
    (bin/"mirror-for-photoshop-server").write <<~EOS
      #!/bin/bash
      exec "#{Formula["oven-sh/bun/bun"].opt_bin}/bun" "#{libexec}/server.js" "$@"
    EOS
  end

  service do
    run [opt_bin/"mirror-for-photoshop-server"]
    keep_alive true
    log_path var/"log/mirror-for-photoshop-server.log"
    error_log_path var/"log/mirror-for-photoshop-server.log"
    working_dir var
  end

  test do
    assert_match "mirror-for-photoshop-server", shell_output("#{bin}/mirror-for-photoshop-server --version")
  end
end
