# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Multi-agent template package manager and CLI for AI coding assistants"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.184"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.184/aikit-aarch64-apple-darwin.tar.gz"
      sha256 "bc6067b553ffa2087d8502eba835f4973405c28092e6cd07c51413b0952570ed"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.184/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "393b78202c9e8de57ca159fc5af52588e521c3d1fecea21c206459d170241304"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.184/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "2a2c1bb83c4a9b08879af1e69d95695269b34d105de6a03ba8d24db1a7a03d7a"
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
