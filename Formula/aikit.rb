# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Universal Package Manager for AI Agent Extensions"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.71"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.71/aikit-aarch64-apple-darwin.tar.gz"
      sha256 "211be6e34dde84003bcfff5e485d45cbade90e2b5d9d979f924d0340c3b8be19"
    elsif Hardware::CPU.intel?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.71/aikit-x86_64-apple-darwin.tar.gz"
      sha256 "85acaffda7cd7da925176935a88ecaca3eaeaf73c16bcd6438d0ab70aa27a478"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.71/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "e55f9b7f0fcc14bb15ea739b4ef16a67486f232a7e535a189ddca59d7167d3c0"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.71/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "17a2dc4527a6ecbdd1944dcc75a8255b6f6dcb2cc33b6ae928723810f3c4d7c4"
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
