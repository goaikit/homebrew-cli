# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Multi-agent template package manager and CLI for AI coding assistants"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.142"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.142/aikit-aarch64-apple-darwin.tar.gz"
      sha256 "19e5843e80490743e2ec27f6deeb2de37c5c77fd2cddf9a0f57dde2a5b313e10"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.142/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "8daa96d707b9a692e9e271e52edf6555ca4049eb6e0c0f9eb4c1a480fd298a53"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.142/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "05a74b7f8cebe4bb868717183275e340e65d83dde1293b31c544ab7363f6b20a"
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
