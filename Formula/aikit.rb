# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Multi-agent template package manager and CLI for AI coding assistants"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.191"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.191/aikit-aarch64-apple-darwin.tar.gz"
      sha256 "3e74bb298afc4769ecaf7855df2c06b332105a6e2f6e9c42385c817cea8915e4"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.191/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "7783ef2937b574a1d4c4cf5f30cbc55121b3b94294f46e4048e922354ce2388a"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.191/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "e6ca6de9b3151e30df51b0f289dd4d12d31c3fe71309564fe26d415908204b0f"
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
