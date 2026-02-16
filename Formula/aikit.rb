# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Universal Package Manager for AI Agent Extensions"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.57"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.57/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "037b516352c278a656383fdb9d0fdd68dc9522d524194b4216dba0b773e941fd"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.57/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "184d28d583131f407f9b66b1d603e92f241525b7ab90281f1f59047205342691"
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
