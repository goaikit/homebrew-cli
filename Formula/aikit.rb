# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Universal Package Manager for AI Agent Extensions"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.36"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.36/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "5d35c48fa80a994cff75e84d64318c14ca2dd211c8a57da69833ed085eb9b2b5"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.36/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "300198037e991e3994d35dc1c91a0bc510a9db530402db0a7eb6418efbd60a6b"
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
