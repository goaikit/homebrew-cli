# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Universal Package Manager for AI Agent Extensions"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.20"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.19/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "0d1f375257cdc8e31d83ad2d2e96f2a18a011d10a026616ec058b489bdafb8d0"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.19/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "8d641ad2cba68899938c2219921946ad71239c5c12dfc4bd6189738a222cbafa"
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
