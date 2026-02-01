# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Universal Package Manager for AI Agent Extensions"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.31"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.31/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "b389ea57c978b379ba41d97cf2e55d694b7c13853339c61cbae46791b8fdc5bf"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.31/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "3e7206946dcd038f015e0444fcf7db61a5994f66070e9bfc819d967b5dca9dfc"
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
