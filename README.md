# PSSearchAndReplace
----------------------
A search and replace tool using powershell.
/Alexander Eriksson 2021-02-12
----------------------

## Required files:
 - dictionary.csv, allows for both strings and/or regex-syntax
 - extensions.csv, e.g. *.txt, text.*, *text* or text.txt

## Instructions:
 - Edit dictionary.csv with the desired vales for Search and Replace

 - Edit extensions.csv with the desired file extensions

 - Run PSSearchAndReplace.ps1

 - Choose an input: Zip-archive, Folder or a Single File

 - For Zip-archives the script will
   * Extract the archive to a temporary folder
   * Search and replace recursively the contents of every file with the specified extension in extensions.csv
   * Compress a new archive containig the replaced file/s
   * Remove temporary extracted files

 - For Folders the script will
   * Make a copy the folder
   * Search and replace recursively every file in the copied folder with the specified extension in extensions.csv

 - For Single Files the script will
   * Make a copy the file
   * Search and replace copied file. extensions.csv is not used for single files.

