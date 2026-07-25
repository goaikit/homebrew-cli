# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Multi-agent template package manager and CLI for AI coding assistants"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.175"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.175/aikit-aarch64-apple-darwin.tar.gz"
      sha256 "1f15116b3ea9af07da71e77d59c7ce6f2643c072afdf5a12c4691eaeabcad072"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.175/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "0a49e00abf27b1e1b5a23d189ab3e9d9c4bcf7f469be37c8f72cf63fc028251e"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.175/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "7221b6dffc09df15b4fae036822962a43f63c466a1d798cb8aca2ed9f70079bb"
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
