# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Multi-agent template package manager and CLI for AI coding assistants"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.196"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.196/aikit-aarch64-apple-darwin.tar.gz"
      sha256 "814bca407bc66089c0bc64e41f0c7488ea5a2e7ffdf549a9658698c0acd9084a"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.196/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "6042976ec638dcdab42bfe927b8134705ef4ddf75434c73b5a21ab9d0745c523"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.196/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "a9f954d783ebd598c647718b30045a3aac225c5e957a7941cceae5cc0b453b06"
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
