class Moat < Formula
  desc "Policy guard for AI coding agents: decides allow, ask or deny for every tool call from Claude Code, Codex and Cursor, configures Claude Code's and Codex's own OS sandboxes from the same policy, and keeps a local audit log."
  homepage "https://github.com/crocodile-labs/openmoat"
  version "0.1.0-alpha.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/crocodile-labs/openmoat/releases/download/v0.1.0-alpha.5/openmoat-aarch64-apple-darwin.tar.xz"
      sha256 "5289b3a47ab30b7d08e29ab73cfa2971122448b687c7f5eae94aa318997fc3f6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/crocodile-labs/openmoat/releases/download/v0.1.0-alpha.5/openmoat-x86_64-apple-darwin.tar.xz"
      sha256 "ef6d820a7358fb757aa62f4812c6ecef79b4a38d207201b969db6694cb1814e0"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/crocodile-labs/openmoat/releases/download/v0.1.0-alpha.5/openmoat-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "5dd3d647c4ef1c14d372794cfae11bf668a3934cfa6db8435451032fc0834dfb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/crocodile-labs/openmoat/releases/download/v0.1.0-alpha.5/openmoat-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "7fcabdd4191512d5f54c3546e05ef1e0a4072b8fb49af46e68bdd72608eab5ed"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin": {},
    "aarch64-unknown-linux-gnu": {},
    "aarch64-unknown-linux-musl-dynamic": {},
    "aarch64-unknown-linux-musl-static": {},
    "x86_64-apple-darwin": {},
    "x86_64-pc-windows-gnu": {},
    "x86_64-unknown-linux-gnu": {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static": {}
  }

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "moat"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "moat"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "moat"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "moat"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
