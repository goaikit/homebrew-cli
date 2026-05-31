# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Multi-agent template package manager and CLI for AI coding assistants"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.130"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.130/aikit-aarch64-apple-darwin.tar.gz"
      sha256 "8d67e854addd5ec28fdaaa2df6684e9bfadac37d7d731c623e585d4fc60d39ee"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.130/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "8bb6732a185acc480829b19002d0e9ae263951eb211a56405c0a8805e8e09af5"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.130/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "8ad4be1e96288a95bb9cefb5e4163ec217d9dde820c517bea1c14f1369d03ce6"
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
