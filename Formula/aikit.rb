# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Multi-agent template package manager and CLI for AI coding assistants"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.100"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.100/aikit-aarch64-apple-darwin.tar.gz"
      sha256 "fda1ee7c2ef4fbea4cd392aaa167434c1a12812811754c099bc6ff1881e58652"
    elsif Hardware::CPU.intel?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.100/aikit-x86_64-apple-darwin.tar.gz"
      sha256 "d4e48cbaf50220075d41d070e3238de4b1957b2cff6f3904a89efa1cd5adba7e"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.100/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "076dbb89f9be8be953825b22f8e0a1402849e5002e8164289f555a0c37b8a82e"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.100/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "27d63562c48792f6b0f1ffc4839f2da5bc1dd1adc9b861a2bf3e519596a05c44"
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
