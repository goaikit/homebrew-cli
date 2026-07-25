# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Multi-agent template package manager and CLI for AI coding assistants"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.176"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.176/aikit-aarch64-apple-darwin.tar.gz"
      sha256 "589da1308b401fa9fc6659ab78de5e175cf80f8ab153d23aba7dbb87a31c6a1a"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.176/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "f427644ce061c6809aa97f46f09e08d09f7a4e68302ccdc3888ca6b26db94232"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.176/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "feeff6a275bbc471ec0c5c09ce811a590a1482d4d4ec527843ebaaaeb77a634f"
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
