cask "graphcode" do
  version "0.1.8"
  sha256 "04cf3a71f10d7f3f56881b3aa5c704be73ee6472bcefcadba3847115797379a7"

  url "https://github.com/scgopi/GraphCode/releases/download/v#{version}/graphcode-macos-arm64.dmg",
      verified: "github.com/scgopi/GraphCode/"
  name "GraphCode"
  desc "Graphs of live, steerable coding-agent sessions"
  homepage "https://github.com/scgopi/GraphCode/"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on arch: :arm64
  depends_on macos: :sequoia

  app "graphcode.app"
  # The CLI the app would otherwise only place in ~/.graphcode/bin, which the README
  # asks people to add to their PATH. Linking it here means a brew install needs no
  # PATH edit; both copies come from the same build.
  binary "#{appdir}/graphcode.app/Contents/Resources/bin/graphcode"

  # graphcoded runs as a launchd agent the app writes on first launch, so uninstall has
  # to unload it and take the plist with it — Homebrew never saw either get created.
  uninstall launchctl: "dev.graphcode.graphcoded",
            quit:      "dev.graphcode.app",
            trash:     "~/Library/LaunchAgents/dev.graphcode.graphcoded.plist"

  # ~/.graphcode holds every project's graph, so it survives an uninstall and goes only
  # on an explicit zap.
  zap trash: [
    "~/.graphcode",
    "~/Library/Caches/dev.graphcode.app",
    "~/Library/HTTPStorages/dev.graphcode.app",
    "~/Library/Preferences/dev.graphcode.app.plist",
    "~/Library/Saved Application State/dev.graphcode.app.savedState",
  ]
end
