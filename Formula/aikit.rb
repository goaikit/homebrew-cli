# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Multi-agent template package manager and CLI for AI coding assistants"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.172"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.172/aikit-aarch64-apple-darwin.tar.gz"
      sha256 "90d34499b1f1df1061778f429295249861a2f468198f7632a354979a5e1f1a5a"
    else
      odie "Unsupported macOS CPU architecture (Apple Silicon only)"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      # Detect glibc version to choose appropriate binary.
      # glibc >= 2.38: use GNU binary for dynamic-linking environments.
      # glibc < 2.38 or musl-based systems: use MUSL binary for compatibility.
      glibc_version = begin
        `ldd --version 2>&1`.lines.first.to_s[/(\d+\.\d+)/].to_f
      rescue
        0
      end

      if glibc_version >= 2.38
        url "https://github.com/goaikit/aikit/releases/download/v0.1.172/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "b94fd43d7a9242a9fc7f7a8222f3c0e4a2a91982eb2eaf8f409d5e721f19ecce"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.172/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "d24da39e83900d71314ab95fb5180a299761e31f0528edf840ac053eee69fe06"
      end
    else
      odie "Unsupported Linux CPU architecture"
    end
  end

  def install
    bin.install "aikit"
  end

  test do
    system "#{bin}/aikit", "--version"
  end
end
