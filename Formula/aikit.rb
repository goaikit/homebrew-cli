# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Universal Package Manager for AI Agent Extensions"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.41"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.41/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "bfe55019bd8608cde3589fe144fcab168dd41e8dbcea4afed32ab7af3bd8453f"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.41/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "5dbf8c74dc71ec58a0d49597a4eea52e0df51abb9d8d50461350eb30a230fcb6"
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
