Ripgrep // rg

# make sure rg matches and searches files that match the glob pattern

$ rg Hello -g '*.toml'  -- [-g '*.jpg'] is the important part with single qoutes to avoid expansion

# If we wanted, we could tell ripgrep to search anything but *.toml files:

$ rg clap -g '!*.toml'
[lots of results]
$ rg clap -g '!*.toml' -g '*.toml'

# Instead of writing out the glob every time, you can use ripgrep's support for file types:
$ rg 'fn run' --type rust
# or, more succinctly,
$ rg 'fn run' -trust

# For example, if you wanted to search C files, you'd have to check both C source files and C header files:
$ rg 'int main' -g '*.{c,h}'


# To see the globs that make up a type, run rg --type-list:

$ rg --type-list | rg '^make:'
make: *.mak, *.mk, GNUmakefile, Gnumakefile, Makefile, gnumakefile, makefile
# define your own types
# $ rg --type-add 'web:*.html' --type-add 'web:*.css' --type-add 'web:*.js' -tweb title
or, more succinctly,
$ rg --type-add 'web:*.{html,css,js}' -tweb title

# random examples
rg -n -w '[A-Z]+_SUSPEND'
rg -uuu -tc -n -w '[A-Z]+_SUSPEND'
rg -w 'Sherlock [A-Z]\w+'
rg -I 'foo,bar,baz'

# Requires modifying the pattern to match the entire line
# shows file and line number of what is matched
$ rg '^.*(foo).*$' --no-heading -r '' ##NOTE can also add --json | jq '.' to parse in json form

# Always works, except when a file path contains a colon.
$ rg 'fn is_empty' --no-heading --line-number | cut -d':' -f1-2
