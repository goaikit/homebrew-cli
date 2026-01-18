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
        sha256 "4103c762447d3174a4d1fa98a1b0faa3b9ad53c8c939ab32e55f48f0cb9c35d2"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.30/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "b0b5f69261b8bf8df2e4f6adf530ac57c7cd5c9736a851c4f0e863ef2425000a"
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
