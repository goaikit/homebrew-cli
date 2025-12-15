# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Universal Package Manager for AI Agent Extensions"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.5"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.5/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "329e0bc91e266cdf6c3f309a26f632adbf5f345f1086b0554e2a3730fc8bb3ab"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.5/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "2e57ba0edc0c363b4a978579848b66d9f5e53bf40a20d3e4e588b1ed9593e037"
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
