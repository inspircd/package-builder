#!/usr/bin/env ruby

%w(erb fileutils yaml).each do |lib|
	require lib
end

# The directory that packages are built in.
INSPIRCD_BUILD_DIR = '/root/packages'

# The group id that should own the output files.
INSPIRCD_BUILD_GROUP = ENV['BUILD_GROUP'].to_i || 0

# The user id that should own the output files.
INSPIRCD_BUILD_USER = ENV['BUILD_USER'].to_i || 0

# Read the package index.
packages = YAML.load_file(File.join(INSPIRCD_BUILD_DIR, 'packages.yml')) rescue nil
unless packages.is_a? Hash
	STDERR.puts "Package list is malformed or missing!"
	exit 1
end

# Read the template file.
template = File.read(File.join(__dir__, "index.rhtml")) rescue nil
unless template.is_a? String
	STDERR.puts "Template HTML is malformed or missing!"
	exit 1
end

# Generate the package list.
output = File.join(INSPIRCD_BUILD_DIR, "index.html")
File.open(output, "w") do |fh|
	fh.puts ERB
		.new(template, trim_mode: '<>')
		.result_with_hash(directory: INSPIRCD_BUILD_DIR, packages: packages)
end
FileUtils.chown INSPIRCD_BUILD_USER, INSPIRCD_BUILD_GROUP, output
