# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Multi-agent template package manager and CLI for AI coding assistants"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.103"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.103/aikit-aarch64-apple-darwin.tar.gz"
      sha256 "a8e989d3800b83f356cf51375f26a3548b0a20c3625f64dde7cd4bdeb5382972"
    elsif Hardware::CPU.intel?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.103/aikit-x86_64-apple-darwin.tar.gz"
      sha256 "88693574e05ac6255c3ada01bd29f5af84c1d199f55777a3a2a5900e4bb089b1"
    else
      odie "Unsupported macOS CPU architecture"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.103/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "bd10f137dc1cf9834ce20aec2ad66944280774ec11d52f4fe0d6e8532748d3f7"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.103/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "31faaa19d4eac1efc9f7a3b4757fbca5210b7441f7594fe1f7a8502eb062f260"
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
