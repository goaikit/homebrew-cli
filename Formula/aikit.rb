# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Multi-agent template package manager and CLI for AI coding assistants"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.174"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.174/aikit-aarch64-apple-darwin.tar.gz"
      sha256 "58cd408065df0cc50638d0b689837fcb24f232884b7f3c9196e32dab3148cf30"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.174/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "2b4bc85e104ffbd954525bc7149ee580b57282f420a972fa71a3aa1a5f3b083b"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.174/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "94cb5da8b0251045e6b576ea2ad536ab2f2fb0bd3d2a46cca2cfbf3ca88b6181"
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
