if File.exist?("public/assets/rev-manifest.json")
  REV_MANIFEST = JSON.parse(File.read(rev_manifest_path))
end
