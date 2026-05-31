# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Multi-agent template package manager and CLI for AI coding assistants"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.129"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.129/aikit-aarch64-apple-darwin.tar.gz"
      sha256 "27d0478d668892d69cc4934c82215ec4a5b4832dfbcc4583b3c59abadb41f302"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.129/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "de8603f031093e8bed4a9acef50d9bc715ae1b30af97b9c4ee9dc7232fc1f76f"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.129/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "ee93c80253499eaa4fcc18520c8ba638fa10b90bdad13e201acac56f1964459d"
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
