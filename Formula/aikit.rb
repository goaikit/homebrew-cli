# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Universal Package Manager for AI Agent Extensions"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.56"
  license "MIT"

  on_linux do
    if Hardware::CPU.intel?
      # Detect glibc version to choose appropriate binary
      # glibc >= 2.38: use gnu binary for full features
      # glibc < 2.38 or musl-based (Alpine): use musl binary for compatibility
      glibc_version = begin
        `ldd --version 2>&1`.lines.first.to_s[/(\d+\.\d+)/].to_f
      rescue
        0
      end

      if glibc_version >= 2.38
        url "https://github.com/goaikit/aikit/releases/download/v0.1.56/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "538dfb15cd700aa1e23be8e3f1fab0e642b1a3124b897ac31b6cf764dd5578c1"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.56/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "f2e8015798e9827acfbbd1c0c351f1538b8b03a59658b7260ff0a647e8508d33"
      end
    end
  end

  def install
    bin.install "aikit"
  end

  test do
    system "#{bin}/aikit", "--version"
  end
end
