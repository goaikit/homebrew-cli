# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Multi-agent template package manager and CLI for AI coding assistants"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.137"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.137/aikit-aarch64-apple-darwin.tar.gz"
      sha256 "c9ae261a9c9400cab7369d06f37c3f0c887ec391c59e27cdc6b07bd342e6cddf"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.137/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "af8d8abfb3c33599829d5d5f3757a0ac5ed6f4cc717006232aca4467b707f2d0"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.137/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "125ae1cfc3509f1ffffebc1965b44915c9aaec64c83a71f90dbfc89b01f7f561"
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
