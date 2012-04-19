package main

import (
	"flag"
	"fmt"
	"io/ioutil"
	"os"
	"strings"
	"syscall"
)

var directory = flag.String("directory", "/", "directory of files to rebaseline")

func main() {
	flag.Parse()
	fmt.Println(*directory)

	file_names, err := ioutil.ReadDir(*directory)
	if err != nil {
		fmt.Println(err)
		syscall.Exit(1)
	}

	for i := 0; i < len(file_names); i++ {
		file_name := file_names[i].Name()
		if !strings.Contains(file_name, ".good.") {
			continue
		}

		// If string contains ".good.", delete the version of the file that doesn't and rename.
		// For PartNetwork__Part_7-511A21310-011~8V613__Container_Scrape__Expected_Results.good.xlsx
		// delete PartNetwork__Part_7-511A21310-011~8V613__Container_Scrape__Expected_Results.xlsx
		// and rename PartNetwork__Part_7-511A21310-011~8V613__Container_Scrape__Expected_Results.good.xlsx
		// to PartNetwork__Part_7-511A21310-011~8V613__Container_Scrape__Expected_Results.xlsx

		original_file_name := strings.Replace(file_name, ".good.", ".", -1)
		fmt.Println("Removing: " + original_file_name)
		err = os.Remove(*directory + original_file_name)
		if err != nil {
			fmt.Println(err)
			syscall.Exit(1)
		}

		fmt.Println("Renaming: " + file_name + " to: " + original_file_name)
		os.Rename(*directory+file_name, *directory+original_file_name)
		if err != nil {
			fmt.Println(err)
			syscall.Exit(1)
		}
	}
}
