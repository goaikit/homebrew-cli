# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Multi-agent template package manager and CLI for AI coding assistants"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.120"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.120/aikit-aarch64-apple-darwin.tar.gz"
      sha256 "4c22d80eeaccfb300efd947b403bc0af85072c3d5299a945f2a799b768dee3d5"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.120/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "b42c5681ed457904647ac6ed3491dca03812b592725774dfed1221ba3b680425"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.120/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "1b23d79e276e18da75001d67dd305a61b58507eeecf809b551d250b7d36bfa20"
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
