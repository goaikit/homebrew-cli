# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Multi-agent template package manager and CLI for AI coding assistants"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.177"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.177/aikit-aarch64-apple-darwin.tar.gz"
      sha256 "4f7548294c65ca9fbc0f1cc427e0f9464d03767af88109bf4a83b6051c5dd20a"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.177/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "951bee647788d539d4d31e466b9c4fd5b3c6725359dadc280925e4c91bec723b"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.177/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "7959df7e5d0f508dade5a798deed0e27462cda99e74234c7e444a2db7894147e"
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
