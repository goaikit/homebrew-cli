# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Multi-agent template package manager and CLI for AI coding assistants"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.193"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.193/aikit-aarch64-apple-darwin.tar.gz"
      sha256 "1f1f322281ad089188a6fe2c1d793e9ba3603fa7c44fbb6d19880e52e607311e"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.193/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "6c554c36453f43ba4b16b9c4746ad5acb6753d72735f80ac95e82b0e096790b3"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.193/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "dbb708466629666a338459650d3b8159e4f37f3eea58e0b4b5f948488a5ff125"
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
