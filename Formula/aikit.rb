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
      sha256 "9f57e56f3a2825108fac417f1be40d0682f37139d2791499801318190e6fe33a"
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
        sha256 "3914137bb88cbb4d02372ff3fad8ffb54441b5afb343b8027bb80bc30b2d7957"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.196/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "c6635c68325836a825cc77855f99265772d4714fdf14133d9a67e9c187366330"
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
