# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Multi-agent template package manager and CLI for AI coding assistants"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.121"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.121/aikit-aarch64-apple-darwin.tar.gz"
      sha256 "3ce365e7db736519360d7c6449dff2f6a82ca8ddb04b68d2e48619e9a6746362"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.121/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "55a7411fee2c0752ee5b15453fbf8b455494103eba1605931095ce1196d1e216"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.121/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "ffe9d01d104fe311a22cbf3aedb8f0f93737f698cac8919bab11603781aa7612"
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
