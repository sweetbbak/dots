## remove all non-alphanumeric characters

$ sed "s/[^[:alnum:]-]//g" 

# This one works well for weird characters. Had to use this for converting
# text files into something that can be read by tts
$ perl -i.bak -pe 's/[^[:ascii:]]//g' <your file>

# -i (inplace)

$ sed -i 's/[\d128-\d255]//g' FILENAME

$ tr -cd '\11\12\15\40-\176'

# this one preserves newlines and carraige returns
$ tr -cd '[:print:]\n\r' < file.txt

# acts like dos to unix
$ sed -i 's/[^[:print:]]//' FILENAME

# and another lol
$ sed -i 's/[^a-zA-Z 0-9`~!@#$%^&*()_+\[\]\\{}|;'\'':",.\/<>?]//g' FILE 

-----------------------------------------------------------------------
# delete single quotes
$ sed "s/[',#,\`,@]//g"

# sed delete empty lines
$ sed '/^$/d' <input file>
$ echo "LINE" | sed '/^$/d'
* posix syntax
$ sed '/^[[:space:]]*$/d' input_file
* delete all empty lines
$ sed '/^[[:space:]]*$/d' input.file
$ sed -i '/^[[:space:]]*$/d' input.file
$ sed -r '/^\s*$/d' input.file > output.file
$ sed -i '/^[[:space:]]*$/d' /tmp/data.txt

## AWK
# delete empty lines
$ awk 'NF'

# Perfect grep to get links from html :)
$ grep -io '<a href=['"'"'"][^"'"'"']*['"'"'"]'
# AND the perfect sed to remove the html tags :D
$ sed -e 's/^<a href=["'"'"']//i' -e 's/["'"'"']$//i'

# another solution to grab links
$ cat index.html | grep -o '<a .*href=.*>' |\
   sed -e 's/<a /\n<a /g' |\
   sed -e 's/<a .*href=['"'"'"]//' -e 's/["'"'"'].*$//' -e '/^$/ d'

# Sed
