# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Multi-agent template package manager and CLI for AI coding assistants"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.115"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.115/aikit-aarch64-apple-darwin.tar.gz"
      sha256 "cfc566e1463518659037f17bc72ec32b8b9bc0335881dc4e46fabe151f86e2ea"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.115/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "52d7d8f15d9faacdfb88e59a18338ade2840a8d6aa0bbdb967afd0b75f692408"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.115/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "0af8599afb966d8e1de58e922d8dc542e4fd0dc7136003437a0ba354d0c5473f"
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
