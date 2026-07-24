# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Multi-agent template package manager and CLI for AI coding assistants"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.170"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.170/aikit-aarch64-apple-darwin.tar.gz"
      sha256 "f966853814319b5d02a1fd486b82a7c1b6278a16c10b67ba48d31fb3921058f8"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.170/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "83fc5824ad2c3aa8569cb5677820027dc6cda93aadb5de9b63f79b8a8adbd52e"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.170/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "8bbf7203fe4c36314ca109277c9807fbbba5e46f98a11da70c1a70bc0b65a582"
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
