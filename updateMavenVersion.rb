#/usr/bin/env ruby
require 'rexml/document.rb'
require 'fileutils.rb'

version = ARGV[0]

if(version == nil) 
    puts 'Must provide a version number to update.'
    exit
end

poms = Dir[Dir.pwd() + "/**/pom.xml"]

for pom in poms do
  if(!File.writable?(pom))
    FileUtils.chmod 0644, pom
  end

  pomXML = REXML::Document.new(File.new(pom))
  element = pomXML.get_elements("/project/version")[0]
  element.text = version

  formatter = REXML::Formatters::Default.new(4)
  formatter.write(pomXML, File.new(pom, "w+"))
end
