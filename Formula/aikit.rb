# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Multi-agent template package manager and CLI for AI coding assistants"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.161"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.161/aikit-aarch64-apple-darwin.tar.gz"
      sha256 "a30f0fabe7c815ddf7b345bd1d01552bba87f2be241e38a0f0f492ab240c6e5f"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.161/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "3ff23f7f7fe1b441d0c31041ef0e9ef22f6cd6644f3164cfc9f146e23dd5d69d"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.161/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "09c2af0e779bad685d282dbad10ad18e58d3e3d1db3d63b1e30dfd769c2aff66"
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
