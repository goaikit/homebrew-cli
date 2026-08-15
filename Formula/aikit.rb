# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Multi-agent template package manager and CLI for AI coding assistants"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.188"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.188/aikit-aarch64-apple-darwin.tar.gz"
      sha256 "b5afb7ad5342c671d0b1e8c018f88267951b79a204cd29fcbf1b3a925d93847e"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.188/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "96ca92322518c0a9cf06df7875b8c8d7b3f4572acf277b523ddffe4a0b8b9c62"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.188/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "e5b305b1a6229181b1b01b03f5b35d6651641a7377cdd2344aa28e889a599a9f"
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
