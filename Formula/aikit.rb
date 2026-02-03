# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Universal Package Manager for AI Agent Extensions"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.33"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.33/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "779d067481dc01071fa8e09deb4cd4ef328f36dcce17bec827be8c008a1c49f0"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.33/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "0fa4acae0a3bd37734aa71194ab4ac1b02cabdcb26adc27aa80124f59d863456"
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
