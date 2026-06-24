# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Multi-agent template package manager and CLI for AI coding assistants"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.147"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.147/aikit-aarch64-apple-darwin.tar.gz"
      sha256 "b30cd31a85610f6b66f42c3207cbea0c4bbfd547351730061fe24c83695e96e5"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.147/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "c6f6b3d55f4a836b48f7057a5557f476b2cc231d24a977a0161c5e4756717054"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.147/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "41469dedb0eed11d3ff18c39c431887630a086b6c60e28c1abcb1506442f3900"
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
