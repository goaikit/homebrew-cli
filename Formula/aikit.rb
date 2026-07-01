# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Multi-agent template package manager and CLI for AI coding assistants"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.155"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.155/aikit-aarch64-apple-darwin.tar.gz"
      sha256 "cc2c120dad46a28d02d455ace3f34d2f0b62e9cd60cc4be1b9a03ffe41b9f3cb"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.155/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "20f3a777227f430279183d13fe7f4cbf56e4d48df871ef8a994410e8d10f1fa9"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.155/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "a906136b85d05b47c128a7c52879584d65b8320094087bb96f42ec5d2a8cbbb6"
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
