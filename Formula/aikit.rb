# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Universal Package Manager for AI Agent Extensions"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.55"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.55/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "3bc8b290d9bfe3723e739e6882b1a91e08e452233922b5d16e0cf906e3436d9d"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.55/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "f68d72fbfc183d2128928a93ed56cbdb612331cf54ac94ff51623b799557c7cb"
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
