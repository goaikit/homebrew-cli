# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Universal Package Manager for AI Agent Extensions"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.43"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.43/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "c72e101db48346ed4a0e91102ec87a53c80af05492abc40093d7a4cb20a3d4cd"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.43/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "62cd85676aea8b4d9b9fb0cfc6213e3c1e9e59fff4395dcac0a274c27a4aeddd"
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
