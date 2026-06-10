# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Multi-agent template package manager and CLI for AI coding assistants"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.139"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.139/aikit-aarch64-apple-darwin.tar.gz"
      sha256 "191069706dffccabcfb9755666e3dde23984f9d68c2d77c07911a7a2947bed6b"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.139/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "9afc1cb76f66fe113e73daa1d41518fe69d3c0b5b28c510883ff91c83b766324"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.139/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "7591ae508922b44d694a2df6c7437de9919ead11ab12569e1de1e027cbb3b905"
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
