# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Multi-agent template package manager and CLI for AI coding assistants"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.117"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.117/aikit-aarch64-apple-darwin.tar.gz"
      sha256 "6ff76ea41fb816e72d96b422cc51d6113be861aeb7b33eb09186581e703b8137"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.117/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "89e4815bef0aea87547236e21455ab34a94f65aa0796b0265eadd9c504383c05"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.117/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "6bdb0fff5bfe12dd5916d0f5556f3437fbc8b6aa779285bcf974c6de9d1e9ec1"
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
