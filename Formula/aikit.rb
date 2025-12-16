# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Universal Package Manager for AI Agent Extensions"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.12"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.12/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "23b86a49cd0be465c0fc9db9a1d17543ecc95a4ae3fb81f0209de06e9b8a9fd9"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.12/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "5457d74bec8a1f3292d8b6bb3a185f8f60b706b10ae14f4e7a69cf827d520b53"
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
