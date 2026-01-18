# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Universal Package Manager for AI Agent Extensions"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.30"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.30/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "d1c6e0111cdcb65165c4db46e8b53921fee92d41b7db4828683d92168fc012d5"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.30/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "6b5daba5b87b2ca19cc456a8fe2abcba4eb8e54f968dc921a4e4ea2a879b338c"
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
