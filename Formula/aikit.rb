# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Multi-agent template package manager and CLI for AI coding assistants"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.149"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.149/aikit-aarch64-apple-darwin.tar.gz"
      sha256 "c5ca84b4b3068e8f3ee9f2126ba9f62a57883ae234e4367bc7406944544862cc"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.149/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "58511182656bd9f0de81fd21069c36789a23d77b52159e27b46f5b2e64da7bae"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.149/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "147a23be375189f53a3d0638f9ea210cb44066eafed23b45d00c80e31b50cebb"
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
