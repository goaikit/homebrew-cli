# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Universal Package Manager for AI Agent Extensions"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.35"
  license "MIT"

  on_linux do
    if Hardware::CPU.intel?
      # Detect glibc version to choose appropriate binary
      # glibc >= 2.38: use gnu binary for full features
      # glibc < 2.38 or musl-based (Alpine): use musl binary for compatibility
      glibc_version = begin
        `ldd --version 2>&1`.lines.first.to_s[/(\d+\.\d+)/].to_f
      rescue
        0
      end

      if glibc_version >= 2.38
        url "https://github.com/goaikit/aikit/releases/download/v0.1.35/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "3224bd9d49348833b4179da0a2a2def4e8c286d2630652c82b1bdb2d1564426d"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.35/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "6fd5c974707f4b5c4a41e9f5b7ebbe9fcb73d202009a99b1578476eb9e0cec68"
      end
    end
  end

  def install
    bin.install "aikit"
  end

  test do
    system "#{bin}/aikit", "--version"
  end
end
