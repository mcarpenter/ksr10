
require 'rake'
require 'rake/clean'
require 'rdoc/task'
require 'rubygems/package_task'

SPEC = eval(File.read('ksr10.gemspec'))

desc 'Default task (gem)'
task :default => [:gem]

Gem::PackageTask.new(SPEC) do |pkg|
end

Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = SPEC.name
  rdoc.options << '--line-numbers'
  rdoc.options << '--charset' << 'utf-8'
  rdoc.options << '--main' << 'README.md'
  rdoc.options << '--all'
end
