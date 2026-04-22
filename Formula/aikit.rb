# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Multi-agent template package manager and CLI for AI coding assistants"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.85"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.85/aikit-aarch64-apple-darwin.tar.gz"
      sha256 "b5511fe90c56743968eedfda031ccc41420c3692e4f56a8c6b7dfb24173ce009"
    elsif Hardware::CPU.intel?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.85/aikit-x86_64-apple-darwin.tar.gz"
      sha256 "6e0cd5159330a1aa2567fa87c625466fca5124af7023907132b840c6e57ec8f5"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.85/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "5a96a126c0251f2d675ef5bca75571ecca847a2fedf5d8b04e84a9b6c3037fc7"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.85/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "fbdd9ffba74481ad5ed47cb1e2a31d989b66419d9e3059125c1a9488207a28bd"
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
