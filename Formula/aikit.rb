# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Multi-agent template package manager and CLI for AI coding assistants"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.90"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.90/aikit-aarch64-apple-darwin.tar.gz"
      sha256 "4e258a031b43fdd34762f67cca5f59052c265887d66dfe6ad03305a83334f3d0"
    elsif Hardware::CPU.intel?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.90/aikit-x86_64-apple-darwin.tar.gz"
      sha256 "3ad87416e5bc89aee6c063298bcf79c1588d0d0c87f86ba7b075826e2997452b"
    else
      odie "Unsupported macOS CPU architecture"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.90/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "b42b61ce4fe857eccacb8beccb4f0071e712ea17348ff375cc6150a92372bfee"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.90/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "489f4d92ddfc08c7bdee9d87d120fc02878dcf71556ede665c0b7d0f69dab331"
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
