# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Universal Package Manager for AI Agent Extensions"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.55"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.55/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "d7191db1f0b3c5215a82dc13299bcf0168b6e61d455852881507425a53395924"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.55/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "6e892befef698531843e2252a8c960cb5c0875e5233ca5144f1572e9aeb46be7"
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
