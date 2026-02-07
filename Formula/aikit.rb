# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Universal Package Manager for AI Agent Extensions"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.40"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.40/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "5f6c968d6c1aafe0e5079101bffb1560643cd3d33e01f284f5d7e38aec8e8afb"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.40/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "9c88f96a599073c85a9197daf5f1b5ada9420635d06169c55456bf41b415fe48"
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
