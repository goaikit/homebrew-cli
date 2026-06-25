# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Multi-agent template package manager and CLI for AI coding assistants"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.152"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.152/aikit-aarch64-apple-darwin.tar.gz"
      sha256 "0fc2f721a0f194e4e036f55fbab8bb0d836f07a905208d0389c9d49a0285ae4c"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.152/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "136d13ddf5864193efce732f7a6b0899c2e67baea3a6202b0d14d74cae9d5656"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.152/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "e02592752a9b547b629ed54892ce1a5a6658f01e2f670c2ef99b58f2ab4a5990"
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
