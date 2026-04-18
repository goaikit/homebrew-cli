# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Multi-agent template package manager and CLI for AI coding assistants"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.83"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.83/aikit-aarch64-apple-darwin.tar.gz"
      sha256 "7bc0ddf2310ba736ce3e358b5c08f53db4f01c5fdde64e020ba2b35bff7622d7"
    elsif Hardware::CPU.intel?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.83/aikit-x86_64-apple-darwin.tar.gz"
      sha256 "bf4f30ea4236692e4b2637b77d3ca9f780b3631c43fe999c0d8689bfaee0ee93"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.83/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "e597339519e0ebe884004e516b4e5e0b6e08d2c16a4c4752c9f129126dda9149"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.83/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "6f9689b1c43d11a3d7218f518b541e7747a0a0fddcafe2969adde6d88e8f898d"
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
