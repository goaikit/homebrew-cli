# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Universal Package Manager for AI Agent Extensions"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.51"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.51/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "3f3c5db47034a12f7b8d9719617c77102a02f739de349efa54ba857f13daf03d"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.51/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "1caa531cb630cfff731d3fb8d6897730406427e63dc0c0a80dc36b412a41fef9"
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
