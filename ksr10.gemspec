require './lib/ksr10'

Gem::Specification.new do |s|
  s.add_dependency 'libusb', '~> 0.6', '>= 0.6.4'
  s.add_dependency 'pry', '~> 0.12', '>= 0.12.2'
  s.authors = ['Martin Carpenter']
  s.date = Time.now.strftime('%Y-%m-%d')
  s.description = 'Interface and control script for the Velleman KSR-10 robotic arm.'
  s.executables << 'ksr10'
  s.email = 'martin.carpenter@gmail.com'
  s.extra_rdoc_files = %w{ LICENSE Rakefile README.md }
  s.files = FileList['lib/**/*', 'test/**/*'].to_a
  s.homepage = 'http://github.com/mcarpenter/ksr10'
  s.licenses = 'BSD-3-Clause'
  s.name = 'ksr10'
  s.platform = Gem::Platform::RUBY
  s.require_path = 'lib'
  s.rubyforge_project = nil
  s.summary = 'KSR-10 robotic arm API and CLI'
  s.test_files = FileList["{test}/**/*test.rb"].to_a
  s.version = Ksr10::VERSION
end
