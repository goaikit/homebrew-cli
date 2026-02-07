# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Universal Package Manager for AI Agent Extensions"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.42"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.42/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "a02f76ad683da0c2619fc172695fb7c58ba4d502fa53e032cac9a84d190cf48f"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.42/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "068a34576ced5d629efef85777427e1d80466223812544b38916d25398cae6dd"
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
