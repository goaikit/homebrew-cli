# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Universal Package Manager for AI Agent Extensions"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.77"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.77/aikit-aarch64-apple-darwin.tar.gz"
      sha256 "2beec9576094df8b8ae8b3cc997a7d0716c33188c0a68d5e73b59c272931e10e"
    elsif Hardware::CPU.intel?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.77/aikit-x86_64-apple-darwin.tar.gz"
      sha256 "f794ebb66951e5bef69421a97675df2641569ddbdcf12f4a2ac759abd36ae8d1"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.77/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "cdf573bcda5c4a9e2b47a4a7941d392e8e07c20ccb4ee5b7783646bff74aeed3"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.77/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "583f135b5752247a41c466a8a60a3b3fa9532d95d25e1be66938f2e32c72a46f"
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
