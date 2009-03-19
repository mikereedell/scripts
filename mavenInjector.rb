#/usr/bin/env ruby
require 'rexml/document.rb'
require 'fileutils.rb'

class MavenInjector

  def inject(path)
    if(path == nil) 
      puts 'Must provide the root path of the node to inject under.'
      exit
    end

    poms = Dir[Dir.pwd() + "/**/pom.xml"]

    for pom in poms do
      if(!File.writable?(pom))
        FileUtils.chmod 0644, pom
      end

      pomXML = REXML::Document.new(File.new(pom))
      element = pomXML.get_elements(path)[0]

      if(element == nil)
        parentElement = pomXML.get_elements("/project/build")[0]
        element = REXML::Element.new("plugins", parentElement)
      end
        
      for plugin in getElementsToInject() do
        element.add_element(plugin)
      end

      formatter = REXML::Formatters::Default.new(4)
      formatter.write(pomXML, File.new(pom, "w+"))
    end
  end
  
  def getElementsToInject()
    elementXML = REXML::Document.new(SNIPPET)
    return elementXML.get_elements("/inject/plugin")
  end
end

SNIPPET = <<HEAD
<inject>
    <plugin>
        <groupId>org.codehaus.mojo</groupId>
        <artifactId>cobertura-maven-plugin</artifactId>
        <configuration>
            <formats>
                <format>html</format>
            </formats>
        </configuration>
    </plugin>
    <plugin>
        <groupId>org.apache.maven.plugins</groupId>
        <artifactId>maven-checkstyle-plugin</artifactId>
        <configuration>
            <enableFilesSummary>false</enableFilesSummary>
            <enableRulesSummary>false</enableRulesSummary>
            <outputFileFormat>plain</outputFileFormat>
        </configuration>
    </plugin>
    <plugin>
        <groupId>org.codehaus.mojo</groupId>
        <artifactId>javancss-maven-plugin</artifactId>
        <version>2.0-beta-2</version>
    </plugin>
</inject>
 
HEAD

MavenInjector.new.inject(ARGV[0])