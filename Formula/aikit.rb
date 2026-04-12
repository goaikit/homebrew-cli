# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Multi-agent template package manager and CLI for AI coding assistants"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.78"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.78/aikit-aarch64-apple-darwin.tar.gz"
      sha256 "bfcedad821ca6b9e156c7976d6d8da885ca626570d1b2939b3c86c15352ba424"
    elsif Hardware::CPU.intel?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.78/aikit-x86_64-apple-darwin.tar.gz"
      sha256 "6228d8b07ff64e6f15a080526c6a6fd1d290a8cfc968a9aac6786d4bfb5e7e46"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.78/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "15f030bc2753447eff471938dbe8907525ba6ee5e02b1e4d9f5bdf0864203a15"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.78/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "9f37fdbf4f2513e2c310d78e359c9c269449796703090665ebac975fa48e3342"
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
