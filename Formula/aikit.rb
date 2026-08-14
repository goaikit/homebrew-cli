# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Multi-agent template package manager and CLI for AI coding assistants"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.187"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.187/aikit-aarch64-apple-darwin.tar.gz"
      sha256 "3b448ffed7da8f94488999ee1adab7943725a6520eede35c8efd18d3f9af1971"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.187/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "18a7af880067ed68a2e67ed50902108ff79d173799e1dc7129fc500933a18fe3"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.187/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "ebdf8966828602524c84f7da677957d679a7a854f3b8353a220f6b579373748a"
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
