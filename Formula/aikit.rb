# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Multi-agent template package manager and CLI for AI coding assistants"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.79"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.79/aikit-aarch64-apple-darwin.tar.gz"
      sha256 "89689eb4d4776c51c9dab46d7de64b8fbe6abda36b0b50ab3f212761f4d7f5f6"
    elsif Hardware::CPU.intel?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.79/aikit-x86_64-apple-darwin.tar.gz"
      sha256 "279103c8740188083e22bf844488e9617b726e77217dc89c4d0f00443ea14c93"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.79/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "a14b9ddf899909e7d29ba3031b8ea6c3bae73f2ca078665b3cded22b8dba2788"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.79/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "153c56bc668e938e8da1c953d43dd2a5bb0c5b78c950470d76e4ebc72c640743"
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
