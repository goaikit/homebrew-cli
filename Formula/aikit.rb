# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Universal Package Manager for AI Agent Extensions"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.38"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.38/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "a741d9d05d36a8a4e19d2778f592175a2f0ed9a6b0a29d301c6a722eb00e6148"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.38/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "54d89ffb059d5136108d7ecc0e0b861f7c7112918f66a6e395e0f24b14c38b93"
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
