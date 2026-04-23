# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Multi-agent template package manager and CLI for AI coding assistants"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.87"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.87/aikit-aarch64-apple-darwin.tar.gz"
      sha256 "5faf5edff111bbbe0170b9b56dd5379515d109d65199be0c249e86fd18f4e8f5"
    elsif Hardware::CPU.intel?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.87/aikit-x86_64-apple-darwin.tar.gz"
      sha256 "a5f8bda87bc11a8e7018b3c552786b83c2a066e193af60ca8aab88766c1b9186"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.87/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "26308400b9db5d265ae5488976957069bf29cafc27a50acc00530c4c9e480095"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.87/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "7aa064b9993c8c679091b3ac1de94f6d4a935e2d442ea99b1c609346e37eaa07"
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
