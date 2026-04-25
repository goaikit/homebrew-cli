# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Multi-agent template package manager and CLI for AI coding assistants"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.88"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.88/aikit-aarch64-apple-darwin.tar.gz"
      sha256 "7896c411650846075280b18ea08f838953d2aa7be3741e9ef58161bee44b943d"
    elsif Hardware::CPU.intel?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.88/aikit-x86_64-apple-darwin.tar.gz"
      sha256 "97abf7e69239f727375f5d15984ac6bf4cac856214a7e8b025a94b74341b6cc6"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.88/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "6e05d382cfd668b7d517ae6feb3dfcba9680ac2cf43b7a156c51db7e0346532f"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.88/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "620b806a7a5de352ee8abd6f69a2bb0ef5a19edb4f9cceebeb83c9514982c57e"
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
