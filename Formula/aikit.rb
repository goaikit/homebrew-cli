# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Multi-agent template package manager and CLI for AI coding assistants"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.101"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.101/aikit-aarch64-apple-darwin.tar.gz"
      sha256 "e8b78d4a507adda7df678545fbcd0cc66b2fa3ecaf289d4c614e459795061286"
    elsif Hardware::CPU.intel?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.101/aikit-x86_64-apple-darwin.tar.gz"
      sha256 "18f55c5f70077ce8f4b311d66b75015d2a82cc33b775e4c5cf0ce64857675c0f"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.101/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "c4636aeb5fe4a49a07a1fcc3351d5f860c1d1a814de444d97d4b15ff85013a5d"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.101/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "0e6a7ec2022e32df3c8521cfd56298ef70918cd314febd431f3a3f46014e3896"
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
