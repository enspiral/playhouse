def require_all(*path_parts)
  path = File.join(path_parts)
  files = Dir.glob(path)
  files.each do |file|
    require file
  end
end