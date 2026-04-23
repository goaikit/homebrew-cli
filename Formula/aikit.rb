# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Multi-agent template package manager and CLI for AI coding assistants"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.86"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.86/aikit-aarch64-apple-darwin.tar.gz"
      sha256 "54acae730f30fc78d4ac036f3de63ad04e2eebe1ceb81b2b4f53511d57012957"
    elsif Hardware::CPU.intel?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.86/aikit-x86_64-apple-darwin.tar.gz"
      sha256 "849142536593f3484daeedf11c28f09b54af2085d514eff43da0df9a25561a2c"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.86/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "55bf81773a88d4bf4b27368cd742a1a6435d1e264e9645ff8ef8545f3cedb697"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.86/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "957f29d73942a87a2aafe16d9207c09bcfb437c8ff276969efcfeaec67bc1b11"
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
