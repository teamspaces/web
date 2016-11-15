if File.exist?("public/assets/rev-manifest.json")
  REV_MANIFEST = JSON.parse(File.read("public/assets/rev-manifest.json"))
end
