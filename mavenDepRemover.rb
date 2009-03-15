  #/usr/bin/env ruby  
  require 'rexml/document.rb'  
    
  if(ARGV[0] == nil)  
    puts 'Must provide the name of the artifact to remove.'  
    exit  
  end  
    
  artifact = ARGV[0].chomp  
  poms = Dir[Dir.pwd() + "/**/pom.xml"]  
    
  for pom in poms do  
    pomXML = REXML::Document.new(File.new(pom))  
    element = pomXML.get_elements("//dependency[artifactId='" + artifact + "']")[0]  
    
    if(element != nil)  
      temp = File.new(artifact + ".xml", "w+")  
      formatter = REXML::Formatters::Default.new()  
      formatter.write(element, temp)  
      puts "Removing the dependency: " + artifact + "\nfrom " + pom  
      element.parent.delete(element)  
      pomXML.write(File.new(pom, "w+"))  
    else  
      puts "No artifacts with the name:'" + artifact + "' were found."  
    end  
  end  
