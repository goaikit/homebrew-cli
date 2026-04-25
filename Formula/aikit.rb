# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Multi-agent template package manager and CLI for AI coding assistants"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.89"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.89/aikit-aarch64-apple-darwin.tar.gz"
      sha256 "8824a5248db0133203503b0a0b9e900a5e12fb732298af091e688a0c36070910"
    elsif Hardware::CPU.intel?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.89/aikit-x86_64-apple-darwin.tar.gz"
      sha256 "37f4807a4402cc0e67d7314845be6fbb14e59bdcb58998b168093e16c77bcbbf"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.89/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "38ef8cd4267555c17ba9ec5d6a612e795120c42b8c34ed4a242e024950a7c8d9"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.89/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "c8743dc2d95c97c922f836fcfb5ef39789b0b03d4411910dd8c25e0c3f5b6667"
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
