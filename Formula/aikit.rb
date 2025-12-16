# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Universal Package Manager for AI Agent Extensions"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.15"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.15/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "cd6e77373569a37f6310d21c2fbcdadbef95bbb18ab50f2172f5694356ea3d3d"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.15/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "6168eae00d10f512ab61e13ba35b7e0799b5114d066a8f16efc79685ac9dd335"
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
