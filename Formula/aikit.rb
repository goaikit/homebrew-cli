# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Multi-agent template package manager and CLI for AI coding assistants"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.186"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.186/aikit-aarch64-apple-darwin.tar.gz"
      sha256 "a74a993fc5e75c5adcee8d3e7666e7279f3727135d0a9696c241a4abdaad2d56"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.186/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "d540d598475e39ffc5151c61b19994732449d68718eefff312a8d7df06bc426e"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.186/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "c4cf8a89425ebc9c4cc5a2d356741089fe6954bf362434899cc46efea5dbe61a"
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
