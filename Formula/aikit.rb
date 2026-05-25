# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Multi-agent template package manager and CLI for AI coding assistants"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.119"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.119/aikit-aarch64-apple-darwin.tar.gz"
      sha256 "7c9f458e3a1f37af54ec4b784741a7c374b4d846cd3ea2fd0efef4ac018f6f20"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.119/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "b9bbec31b1f796b15b5b4cfe0f18ee2bad80b1b06298632d3a2ae14109df81ab"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.119/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "977814c8a40b4d890a330ecfb0e16d16308e055af611fac0859b0dfc9c9f1562"
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
