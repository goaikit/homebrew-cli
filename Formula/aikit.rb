# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Multi-agent template package manager and CLI for AI coding assistants"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.169"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.169/aikit-aarch64-apple-darwin.tar.gz"
      sha256 "4cb19e30ee35c66e3a49c743db368351e4325390034b4172677a87583f24c925"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.169/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "d4d8627019590f8fe01d443195e1f72a5d053c58458a81731cc1ed4d0cec5cb8"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.169/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "3dcb418fcbdfc257426630b4a3a6344c86a8ad2507146612b92e5ea719705158"
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
