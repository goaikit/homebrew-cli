# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Universal Package Manager for AI Agent Extensions"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.76"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.76/aikit-aarch64-apple-darwin.tar.gz"
      sha256 "21a9615d0d144d68fce72f5163b67e58ce2ce8ef7193a245c4caeac0413a3c4f"
    elsif Hardware::CPU.intel?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.76/aikit-x86_64-apple-darwin.tar.gz"
      sha256 "5d1e94dd4f2685e8767e78a193d145deb336c586d42fb82744dde1562cbf116c"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.76/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "fe77641017885f3f80c77eeb61ab0e134ae93bf3f51b10c5f9149dba0ed8f206"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.76/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "2a319ecd857240d5d93eae9dd0a6332ba97ff23d9b4354b5dc733acd9b81fd05"
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
