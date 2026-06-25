# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Multi-agent template package manager and CLI for AI coding assistants"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.153"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.153/aikit-aarch64-apple-darwin.tar.gz"
      sha256 "06f81198545b00bfedede730f222a9fb54c942c8dfc9797d5c53da025121f441"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.153/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "28f582f5b68d07dd29493d0c6df0a27d6c67c696224ecaad8dcae5efda0c89a6"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.153/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "5ba62df9be978e0212ceff022b453547c0815f0122c7f750969f73515fcb70c0"
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
