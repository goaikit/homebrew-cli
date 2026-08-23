# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Multi-agent template package manager and CLI for AI coding assistants"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.192"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.192/aikit-aarch64-apple-darwin.tar.gz"
      sha256 "24181ae11f1344314ba1e82ef8fa7569c0c88970f2dc6ed1d3df099dcfc6a91e"
    else
      odie "Unsupported macOS CPU architecture (Apple Silicon only)"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      # Detect glibc version to choose appropriate binary.
      # glibc >= 2.38: use GNU binary for dynamic-linking environments.
      # glibc < 2.38 or musl-based systems: use MUSL binary for compatibility.
      glibc_version = begin
        `ldd --version 2>&1`.lines.first.to_s[/(\d+\.\d+)/].to_f
      rescue
        0
      end

      if glibc_version >= 2.38
        url "https://github.com/goaikit/aikit/releases/download/v0.1.192/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "552a820170e4884f6b6a4ea4bf051057008cdf3fd343209558263ff54549446c"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.192/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "0b3e4fed2902616be0e636f6a950028c3d26d713ebaea2ad87af14c704339163"
      end
    else
      odie "Unsupported Linux CPU architecture"
    end
  end

  def install
    bin.install "aikit"
  end

  test do
    system "#{bin}/aikit", "--version"
  end
end
