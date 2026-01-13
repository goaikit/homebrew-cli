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
        sha256 "24fd3af3933b1864054f5c76c07e3d7e1124da9c7e32e05f71bdff239311e80a"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.30/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "634f60134ee03f447a8dca77652f1b700d0c703035e89c85a2b061a9f7ac8fd4"
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
