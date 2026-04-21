# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Multi-agent template package manager and CLI for AI coding assistants"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.84"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.84/aikit-aarch64-apple-darwin.tar.gz"
      sha256 "a61569050545db5d7502620a8c49d1a904e295c985b4d1d39cc0c750d229a181"
    elsif Hardware::CPU.intel?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.84/aikit-x86_64-apple-darwin.tar.gz"
      sha256 "874079f657d49e2175228ad26cceec2bfdd12b6b20151df6955e947e17bc08c7"
    else
      odie "Unsupported macOS CPU architecture"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.84/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "651423a9a6b8e955f69dbce890836ec8cef3c27523dc3172ee0d10e9b4de2b3d"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.84/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "faf2e2f873ddf14e76d154ebfb347f143a27352b924fcab8fd888cdb4a326f2d"
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
