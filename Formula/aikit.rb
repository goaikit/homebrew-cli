# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Multi-agent template package manager and CLI for AI coding assistants"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.154"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.154/aikit-aarch64-apple-darwin.tar.gz"
      sha256 "b61b24a14985ecac4bf82bef0c63d45c373db6d8b82fbdf1d80d7a28a4fe22d5"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.154/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "98e7c77d8da989b9ab494164c223c2d626d3e57d2d6dd6452a76517ba1e9a333"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.154/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "17592359749f7661ab9360a1b1db0e924a64dc50f5ea2104c1f80f197809d0a3"
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
