# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Universal Package Manager for AI Agent Extensions"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.45"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.45/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "2fe9d6f9c7bb488b67ad7f8d70966a6d40054f0076b597ebc6f2747a282873b9"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.45/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "50fab408ff7662543daa2b1776e3fb4349abbb470458705f858813ed3f6f8d7b"
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
