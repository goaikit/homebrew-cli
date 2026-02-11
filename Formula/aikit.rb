# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Universal Package Manager for AI Agent Extensions"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.53"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.53/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "f1bba42f19f7c8d92dc1e980bdf0c5feb452fb8b138d6eaeea4a1d6d53f13c8f"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.53/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "b33b727bfd9028d324e1e7f0a2f010e1dd358db1c79058eced5704479b11f8a6"
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
