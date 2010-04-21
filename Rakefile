#!/usr/bin/env ruby
require 'rubygems'
require 'rake'
require 'spec/rake/spectask'


task :default => [:spec]

desc "Run all spec examples"
Spec::Rake::SpecTask.new do |t|
  t.libs << "spec"
  t.spec_files = FileList['spec/**/*_spec.rb']
  t.spec_opts = ['--options', %\"#{File.dirname(__FILE__)}/spec/spec.opts"\]
end
