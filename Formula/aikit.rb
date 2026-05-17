# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Multi-agent template package manager and CLI for AI coding assistants"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.113"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.113/aikit-aarch64-apple-darwin.tar.gz"
      sha256 "aab05b9bbcdcc26fbfab3ca26621541f45a8425933b6c3e36174dae9924b1c2b"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.113/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "600c7463e4c205b58d3225e965f81426bf7fbc84479b925113ff6add7fb7e234"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.113/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "bd1ec86d491ef144e742b3bdaeed2c5550fe8ba4640aa0a5f8e68d2ad60faaa6"
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
