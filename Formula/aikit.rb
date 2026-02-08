# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Universal Package Manager for AI Agent Extensions"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.46"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.46/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "77b52f31dbf0c3743cd18f8e9e602a35e4140cce30546060a143e8c274b233b4"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.46/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "e6258fd6c6ef94b2a64e792ec2abfa95fbf0e66cbff78928430a6292d4f1c6fc"
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
