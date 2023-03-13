% awk

# remove files with less than 10 (x) lines
- find files - exec awk -v set varible 10 - if more than 10 then rm file
- the -v flag to Awk allows us to set an Awk variable (once) before the Awk commands are executed (for each line of the file.) In this case we set x to 10.
- NR is a special Awk variable referring to the "Number of the current Record." In other words, it is the line number we are looking at in any particular pass through the loop.
  (Note that it is possible, though unusual, to use a different "Record Separator" than the default of a newline character, by setting RS. Here is an example of playing with record separators.)
- So if the Awk script exits successfully, it means you have a file of less than ten lines. The next exec on success removes the file

find . -type f -exec awk -v x=10 'NR==x{exit 1}' {} \; -exec echo rm -f {} \;

# select columns from file
awk 'BEGIN{FS=OFS=","} {print $1,$2}' <filename>

# check if records have same columns
awk -F ',' '{print NF}' <filename>  | sort | uniq -c | wc -l

# change delimiter
awk '$1=$1' FS="<old>" OFS="<new>" <filename>

# search regex in column
awk -F ',' '$<colNr> ~/<regex>/' <filename> | column -t -s, | bat --file-name <filename>

# exclude regex in column
awk -F ',' '$<colNr> !~/<regex>/' <filename> | column -t -s, | bat --file-name <filename>

# remove all white spaces
awk 'BEGIN{FS=OFS=","} {gsub(/[ \t]+/,""); print }' <filename>

# trim leading and trailing white spaces
awk 'BEGIN{FS=OFS=","} { gsub(/^[ \t]+|[ \t]+$/, ""); print }' <filename>

# replace everywhere
awk 'BEGIN{FS=OFS=","} {gsub(/<pattern>/,"<replacement>"); print }' <filename>

# replace in column
awk 'BEGIN{FS=OFS=","} {gsub(/<pattern>/,"<replacement>",$<column>); print }' <filename>

# replace in column on condition
awk 'BEGIN{FS=OFS=","} {if(<condition>) gsub(/<pattern>/,"<replacement>",$<column>); print }' <filename>

# data validation/condition
awk -F ',' '<condition> { print }' <filename>

# remove empty lines
awk NF <filename>

# remove duplicates
awk -F ',' '!seen[$0]++' <filename>

# remove duplicates in column
awk -F ',' '!seen[$<colNr>]++' <filename>

# print index of empty lines
awk '!NF {print NR}' <filename>

# select null in column
awk -F ',' '!$<colNr>' <filename>

# exclude null in column
awk -F ',' '$<colNr>' <filename>

# search for only spaces in column
awk -F ',' '$<colNr> ~/^[[:blank:]]+$/' <filename>

# select row by index
awk -F ',' 'NR==<index>' <filename>

# count lines that match pattern
awk -F ',' '/<pattern>/{++count} END {print count}' <filename>

# count distinct
: <filename>; awk -F ',' 'NR > 1 {print $<colNr>}' <filename> | sort | uniq -c | wc -l

# count frequencies of values in column
: <filename>; awk -F ',' 'NR!=1 {print $<colNr>}' <filename> | sort | uniq -c | sort -nr

$ filename: fd -I -t f -e csv
$ colNr: xsv headers <filename> --- --column 1