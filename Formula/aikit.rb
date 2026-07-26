# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Multi-agent template package manager and CLI for AI coding assistants"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.183"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.183/aikit-aarch64-apple-darwin.tar.gz"
      sha256 "1f1cca1f955d4929edc1837c96b455061a1f21c3750dea2b5b3d1a83070b5373"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.183/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "c893ed876d0324676c4a53720e93f459c98cdb4d8f2362305a448ad15ecc45ca"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.183/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "a250bc1b2e8b0171214ae9224ce92c7af1052f2e190c5e84075668a6654944c0"
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
