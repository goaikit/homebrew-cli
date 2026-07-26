# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Multi-agent template package manager and CLI for AI coding assistants"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.182"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.182/aikit-aarch64-apple-darwin.tar.gz"
      sha256 "c22cc044425d265beb9fc991434d7178069e71f10f0bf7e57bdf83dc30df0273"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.182/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "395165751fa408f0f0fccd388b41f9abfbb114edc0d68fa845cc97eb6a1bd6f3"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.182/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "e6293a02fd643d4ab3944438bc0dff515a201b58f829e9674559341817924b62"
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
