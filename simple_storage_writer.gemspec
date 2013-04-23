lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'simple_storage_writer/version'

Gem::Specification.new do |s|
  s.name        = 'simple_storage_writer'
  s.version     = SimpleStorageWriter::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Jeremy Boles']
  s.email       = ['jeremy@centralstandard.com']
  s.homepage    = 'https://github.com/centralstandard/simple_storage_writer'
  s.summary     = 'Simple API for uploading static pages to Amazon S3'
  s.description = "Makes creating static pages on Amazon's S3 service as easy as using ActionMailer"

  s.required_rubygems_version = '>= 1.3.7'

  s.add_dependency 'actionpack', '~> 3.2.13'
  s.add_dependency 'aws-sdk',    '~> 1.8.3'

  s.files        = Dir.glob("lib/**/*") + %w(README.md)
  s.require_path = 'lib'
end
