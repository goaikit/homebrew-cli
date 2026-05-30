# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Multi-agent template package manager and CLI for AI coding assistants"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.126"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.126/aikit-aarch64-apple-darwin.tar.gz"
      sha256 "6670dc02af78924a49fe902c82b54ffa40da6e6df35cc29c5ffd0debda70e43a"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.126/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "27d8854d03a58fd0b0efb69034bfe372c83044e130b3bedf8f2b4b8c9f485646"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.126/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "b4f5568684e1c5642f126c6a7787ffb072d2bcd0d3121b332366ff937bf77489"
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
