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
      sha256 "c4c6dea74b4acdccd27c34b92df557a569a0a1453eaf1b8ed4a9c2bf864cba97"
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
        sha256 "3645cb97c6325fff4917ef5cdce046c94c9da500374a4d16b7f98ee170a527bc"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.169/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "968599c8677e3b831aeee9cad9324f09365d3649831ca4a1362519e751dc21f6"
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
