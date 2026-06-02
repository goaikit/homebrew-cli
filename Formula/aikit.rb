# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Multi-agent template package manager and CLI for AI coding assistants"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.133"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.133/aikit-aarch64-apple-darwin.tar.gz"
      sha256 "350972391fdc52d858a2484ef392a5ce06f7d914cc99177922a16483b44dc375"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.133/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "9a5d6b8d617009ad2fca4d0f1d9d707ad77933cb7041cf340509237a0e016b20"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.133/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "b96c87d000c793415aa163fee48481c868ed8e7a737f95d763bff4f749f0137a"
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
