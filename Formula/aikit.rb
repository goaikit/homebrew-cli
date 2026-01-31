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
        sha256 "722d35d2c502bc24247745d2bc0a2f252b1dedc54c7d9d3f6c7136af93618d0d"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.30/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "f540d86427f5fc62ee02856b31f9ededc2aab53f49157bfa0eea043015aaa93d"
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
