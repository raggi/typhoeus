#!/usr/bin/env rake
require "spec/rake/spectask"
require 'rake/clean'
require 'lib/typhoeus/version'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "typhoeus"
    gemspec.version = Typhoeus::VERSION
    gemspec.summary = "A library for interacting with web services (and building SOAs) at blinding speed."
    gemspec.description = "Like a modern code version of the mythical beast with 100 serpent heads, Typhoeus runs HTTP requests in parallel while cleanly encapsulating handling logic."
    gemspec.email = "paul@pauldix.net"
    gemspec.homepage = "http://github.com/pauldix/typhoeus"
    gemspec.authors = ["Paul Dix"]
    gemspec.add_development_dependency "rspec"
    gemspec.add_development_dependency "jeweler"
    gemspec.add_development_dependency "diff-lcs"
    gemspec.add_development_dependency "sinatra"
    gemspec.add_development_dependency "json"
  end

  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler not available. Install it with: gem install jeweler"
end

CLOBBER.include 'pkg'

Spec::Rake::SpecTask.new do |t|
  t.libs << 'ext'
  t.ruby_opts << '-rubygems'
  t.spec_opts = ['--options', "\"#{File.dirname(__FILE__)}/spec/spec.opts\""]
  t.spec_files = Dir['spec/**/*_spec.rb']
end

sources = FileList['ext/typhoeus/*.{c,h}']
extconf = FileList['ext/typhoeus/extconf.rb']
makefile = 'ext/typhoeus/Makefile'
extension = "ext/typhoeus/native.#{Config::CONFIG['DLEXT']}"

CLOBBER.include makefile, extension, *Dir['ext/typhoeus/*.{log,dSYM,o}']

file makefile => extconf do
  chdir('ext/typhoeus') { ruby 'extconf.rb' }
end

file extension => [makefile] + sources do
  chdir 'ext/typhoeus' do
    sh Config::CONFIG['make-prog'] || ENV['MAKE'] || 'make'
  end
end

desc "Run 500ms delay test server"
task :server do
  exec 'benchmarks/config.ru'
end

namespace :bench do
  Dir['benchmarks/*.rb'].each do |file|
    name = File.basename(file, '.rb')
    desc "Run #{name} benchmark"
    task name => :native do
      ruby '-Ilib:ext', file
    end
  end
end

desc "Build the native extension"
task :native => extension

task :spec => extension

desc "Run all the tests"
task :default => :spec
