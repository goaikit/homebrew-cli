# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Universal Package Manager for AI Agent Extensions"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.48"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.48/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "ecf9d2021d1e52fc8c6683afcae9b4c76dcb7c9e076842138ab005d8ca8f9257"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.48/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "42e067e4f2991959a7c56db366f19666c2a09c4d285cca8892b7d59e18ccff20"
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
