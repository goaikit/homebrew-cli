# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Multi-agent template package manager and CLI for AI coding assistants"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.162"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.162/aikit-aarch64-apple-darwin.tar.gz"
      sha256 "5dee7776909a40762bcc4ba803d430db7f1aa020fe624f92bab102dcecee8ab8"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.162/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "fd60a91639937612e8f5d90aaf21338d4d6d8274e4e6e6a27f7a7ec5ad3f2813"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.162/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "6f14a831a320b9217763aa6ed0f6168f6766e0bb9fcf0b409ec890478c07cb7b"
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
