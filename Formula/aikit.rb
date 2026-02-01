# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Universal Package Manager for AI Agent Extensions"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.32"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.32/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "9d1c84949448245e19d84534f6e014311fa1d0a38e0d79629c94ec3731cecfdf"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.32/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "11af93f4b197e082264c010e32e50d13d287edcaf2cee63836696438aca44f3b"
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
