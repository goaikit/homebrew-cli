# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Multi-agent template package manager and CLI for AI coding assistants"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.194"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.194/aikit-aarch64-apple-darwin.tar.gz"
      sha256 "abce1b01ef3e6dcbbbdd4bdb947979642b3855d392ec50f09ed4edf00b9f4eb4"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.194/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "61102b868f511bd2d33d291c084cb1bdfe4f66742a4810907f1576e0ddbd7bcf"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.194/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "6efd9f5d9cf74a5d436fdb2f744733d4d7d8457975a89f60d94f771f3e253250"
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
