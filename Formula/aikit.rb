# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Multi-agent template package manager and CLI for AI coding assistants"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.80"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.80/aikit-aarch64-apple-darwin.tar.gz"
      sha256 "bf7d27b49af0e1e48e622999117080acecc371eb14cfce700645c269bcf7ea35"
    elsif Hardware::CPU.intel?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.80/aikit-x86_64-apple-darwin.tar.gz"
      sha256 "f7ad0d01e813ee634a10eca31ac4f30b1495d4dfb3e12293dffe4f1a248d73c9"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.80/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "cf2041a7b80aafa707e1f53357e8b35d32463f7c2171109e53464a314ef83100"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.80/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "9ca0a0002ad7da3228300b45ca510e702fa3bd94df3d6089687dfbcd9348f92e"
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
