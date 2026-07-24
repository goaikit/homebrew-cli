# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Multi-agent template package manager and CLI for AI coding assistants"
  homepage "https://github.com/goaikit/aikit"
  version "0.1.166"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/goaikit/aikit/releases/download/v0.1.166/aikit-aarch64-apple-darwin.tar.gz"
      sha256 "8f6f1a42c055371f137bb76a768bdbc12ba897414fe3b9c10624b529dc9bd2a4"
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
        url "https://github.com/goaikit/aikit/releases/download/v0.1.166/aikit-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "d145293776ca037989ac58c438c0246aa9bd54614dddc7a20b73a13902a639a4"
      else
        url "https://github.com/goaikit/aikit/releases/download/v0.1.166/aikit-x86_64-unknown-linux-musl.tar.gz"
        sha256 "652603cb0cb6ce25209efab4dd95cf39b2645bd4bdcc3861b35bf39b49c98a29"
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
