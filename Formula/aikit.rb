# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Multi-agent template package manager and CLI for AI coding assistants"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.178"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.178/aikit-aarch64-apple-darwin.tar.gz"
      sha256 "114b21bdf76d338caabc018c6f02fe5d8245436f084dc6422c9a516b9cee1daa"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.178/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "3602f25c5ae4c88e8780e1c3721590a996b5495bf3b7da3878546f4dfcd62e27"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.178/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "7cc6cef58a80b2c2a9e81b5deee5cd02cbd6a7780129d287265161a1c0de15ce"
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
