
# Get the list of all java files - DONE
# If they have the license in them, ignore
# else add the license to the top of the file and save. - DONE
# extra style points for creating the git commit.
# check for .h, .c, .cpp, and .m files??

class Licenser

	def licenseFiles(dir)
    filenames = Dir[dir.chop + "**/*.java"]
	  for filename in filenames do
      contents = ''
      File.open(filename, 'r') { |file| contents = file.read }
      contents = HEADER + contents
      File.open(filename, 'w') { |file| file.write(contents) }
    end
	end
end
	
HEADER = <<HEAD
/*
 * Copyright 2008-2009 Mike Reedell / LuckyCatLabs.
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *      http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

HEAD


	Licenser.new.licenseFiles(ARGV[0])	