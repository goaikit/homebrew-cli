# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Multi-agent template package manager and CLI for AI coding assistants"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.165"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.165/aikit-aarch64-apple-darwin.tar.gz"
      sha256 "f49b3642afd968d664796c992ca047fc744dfca93832d5c6151e9afb166547ca"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.165/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "50cf26b3b7b275cbba2195c579e9ac330ef0e07beb80cf2c8d8c6ade9507739c"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.165/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "9326aa88f72602f7875dc27edf6b11e6d61910d25e5b8c0b6ab2226037c00ab4"
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
