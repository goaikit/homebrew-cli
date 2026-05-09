# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Multi-agent template package manager and CLI for AI coding assistants"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.102"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.102/aikit-aarch64-apple-darwin.tar.gz"
      sha256 "a0454a13e0f67f04ef02dec66854a2905b8bad0994798ee5977b6939d4c2e6c3"
    elsif Hardware::CPU.intel?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.102/aikit-x86_64-apple-darwin.tar.gz"
      sha256 "a215260f6254bf6771a91ff001422891faf97804c879ab807b2d829514341e4a"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.102/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "13921c775131a07646decef56f88358a410fd700b728eb4e01b9a97308c92fb0"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.102/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "ed582f3bcb0d920e413ae1e3f75bebac9940894177f59af7bf7e13e7cddf57ec"
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
