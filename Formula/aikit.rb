# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Multi-agent template package manager and CLI for AI coding assistants"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.181"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.181/aikit-aarch64-apple-darwin.tar.gz"
      sha256 "cef7450f546c0d2a92815ad7b8c3def7fed05d5f549581f863dd0d7949ac3bc7"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.181/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "6d0502968e120f432fca958e81fc973ed52bc5fdf452447b13767a1105990a4f"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.181/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "eed0155d976b95321131eb6052250c739924bc1aec3f5611e5c53632b5b465af"
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
