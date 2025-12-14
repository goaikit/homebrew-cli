# typed: false
# frozen_string_literal: true

class Aikit < Formula
  desc "Universal Package Manager for AI Agent Extensions"
  homepage "https://github.com/goaikit/aikit"
  version "0.0.0"
  license "MIT"

  # Placeholder formula - will be updated when releases are available
  # Run ./generate_formula.sh --version latest to update

  on_linux do
    if Hardware::CPU.intel?
      # Formula will be generated automatically when releases are available
      url "https://github.com/goaikit/aikit/releases/download/v0.0.0/placeholder"
      sha256 "0000000000000000000000000000000000000000000000000000000000000000"
    end
  end

  def install
    bin.install "aikit"
  end

  test do
    system "#{bin}/aikit", "--version"
  end
end

