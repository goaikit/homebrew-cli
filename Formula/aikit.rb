# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Multi-agent template package manager and CLI for AI coding assistants"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.179"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.179/aikit-aarch64-apple-darwin.tar.gz"
      sha256 "4c48d3b49a14be2cd3a74ea10fdd28de07f6e0d39116065fed716283c8d67cac"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.179/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "36c27e72a6ff71be19581dae2b0bf43fab0d4efbca84f9647666959ad7be70d9"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.179/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "7da2c98093f8603441c469d40944c97c08f0873992bf9570eb88cffa0d4f43aa"
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
