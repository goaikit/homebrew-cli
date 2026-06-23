# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Multi-agent template package manager and CLI for AI coding assistants"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.145"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.145/aikit-aarch64-apple-darwin.tar.gz"
      sha256 "2784f92930bff9937b99e37ae4357fde3653c5f2acbf4bc4195c61db96172141"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.145/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "385bfc933007401a82ed4637a1d86bb2413b9a50017f4f55ccc84f6aedf9af3b"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.145/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "9deef15845f42b7dd3fe21f2f15ee1f29d7afe689030955d60b868f21899030b"
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
