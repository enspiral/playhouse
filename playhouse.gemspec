Gem::Specification.new do |s|
  s.name = "playhouse"
  s.version = '0.1.1'
  s.authors = ["Craig Ambrose", "Joshua Vial"]
  s.email = ["craig@enspiral.com", "joshua@enspiral.com"]
  s.homepage = "https://github.com/enspiral/playhouse"
  s.summary = "A DCI framework"
  s.description = "Provides one possible way of implementing a DCI architecture in a ruby app"

  s.require_paths = %w(lib)

  s.files = `git ls-files`.split($/)
  s.test_files = s.files.grep(%r{^(spec)/})

  s.required_ruby_version = '>= 1.9.2'

  s.add_dependency 'rake'
  s.add_dependency 'activesupport'
  s.add_dependency 'activerecord'
end
