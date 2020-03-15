require_relative 'lib/cloud_watch_logs/version'

Gem::Specification.new do |spec|
  spec.name          = 'cloud_watch_logs'
  spec.version       = CloudWatchLogs::VERSION
  spec.authors       = ['Eiji MATSUMOTO']
  spec.email         = ['e.mattsan@gmail.com']

  spec.summary       = %q{A wrapper of AWS CloudWatch Logs}
  spec.description   = %q{A wrapper of AWS CloudWatch Logs}
  spec.homepage      = 'https://github.com/mattsan'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.3.0')

  spec.metadata['allowed_push_host'] = 'http://mygemserver.com'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/mattsan'
  spec.metadata['changelog_uri'] = 'https://github.com/mattsan'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
  spec.add_runtime_dependency 'aws-sdk-cloudwatchlogs'
end
