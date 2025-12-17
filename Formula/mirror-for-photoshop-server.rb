# ABOUTME: Homebrew formula for Mirror for Photoshop Server
# ABOUTME: Installs WebSocket relay that bridges Photoshop to iOS

class MirrorForPhotoshopServer < Formula
  desc "WebSocket relay server for Mirror for Photoshop - Photoshop to iOS preview"
  homepage "https://github.com/hex/Mirror-for-Photoshop"
  url "https://github.com/hex/mirror-for-photoshop-server/releases/download/v2025.12.52/mirror-for-photoshop-server.tar.gz"
  sha256 "231180e084b39c8b2bf042689212fef9acaaf8da908fe65d2aadcac42dec0189"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

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

    # Short alias
    bin.install_symlink "mirror-for-photoshop-server" => "mirrorps"
  end

  def caveats
    <<~EOS
      Short alias available: mirrorps

      To start as a background service:
        brew services start mirror-for-photoshop-server

      Default port: 8765
      Custom port:  mirrorps --port 9000
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
