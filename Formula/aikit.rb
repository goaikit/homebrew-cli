# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Multi-agent template package manager and CLI for AI coding assistants"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.134"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.134/aikit-aarch64-apple-darwin.tar.gz"
      sha256 "a9e9e6b143ab1a2138f85310a0761b48ff432275dbfc20f21ff3f958620cc8dd"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.134/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "d7ef4b881f0ddbdbddf77ab3ff91b7a5300e53feccf8a4ec6d09f8e90aac3c6c"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.134/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "7755b4e9bc5a6d32e9b7781533c01bb07f0c8c64aa402c8da3ad93d6be8185b0"
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
