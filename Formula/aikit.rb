# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Multi-agent template package manager and CLI for AI coding assistants"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.143"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.143/aikit-aarch64-apple-darwin.tar.gz"
      sha256 "4d4b22fa4ab5c6e27d1640313927f67b00d07d7b2c6c8505aa1210efc4005249"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.143/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "81155dd71b394551065a371292cfdcbd7e1d7c3ca9bca0172e6ee242bf49a541"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.143/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "d61c125a05785f653856c77cf6ee9dd6da39c3e920d29c50bd72c53f9e31e4be"
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
