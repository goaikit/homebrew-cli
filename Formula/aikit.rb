# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Multi-agent template package manager and CLI for AI coding assistants"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.164"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.164/aikit-aarch64-apple-darwin.tar.gz"
      sha256 "a163d88a17107081182adb2ed47020e92e82ec48715b7aa215264de88a6163f0"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.164/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "60297f51f97d37ee1c75a91f4c21299d4ec85c95acdfa22290fc67f38579b001"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.164/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "60ab1dbab6949e65ebb6267306341186dad41f58c67dc62528524056551fa3c9"
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
