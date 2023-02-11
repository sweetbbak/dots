# Various utilities and portability crutches for other POSIX sh scripts

[ "${BASH:-}" ] && shopt -s expand_aliases

_is_interactive=false
case $- in *i*) _is_interactive=true; esac


# No surprises echo override (not XSI compliant, that would be %b instead of %s)
echo()
{
	printf '%s\n' "$*"
}

# Print all arguments to stderr and exits with status 1
die()
{
	echo "$@" >&2
	exit 1
}

# Check if local or typeset is available
if ! $(fun() { local a=1; }; fun)
then
	if $(fun() { typeset a=1; }; fun)
	then
		alias local=typeset
	else
		die "local/typeset not supported by sh, aborting"
	fi
fi

# Is $1 a valid command (executable, function, builtin or alias)?
has_cmd()
{
	command -v "$1" >/dev/null
}

# Detection and fallback for readlink -f
if has_cmd greadlink
then
	alias readlinkf='greadlink -f --'
elif readlink --version 2>/dev/null | grep -q '^readlink (GNU coreutils)'
then
	alias readlinkf='readlink -f --'
else
	# Portable readlink -f using GNU's semantics (last component need not exist)
	# Currently passes the tests from https://github.com/ko1nksm/readlinkf
	# except loop detection (`getconf SYMLOOP_MAX` is undefined here, anyway)
	readlinkf()
	{
		[ $# -eq 0 ] && return 1
		local i= status=0 pwd="$(pwd -P)" base= dir=
		for i
		do
			! [ "$i" ] && { status=1; continue; }
			if [ -d "$i" ]
			then
				CDPATH= cd -P -- "$i" >/dev/null 2>&1 || return 1
				pwd -P
			else
				case "$i" in */) [ -e "${i%/}" ] && return 1;; esac
				while true
				do
					CDPATH= cd -P -- "$(dirname -- "$i")" >/dev/null 2>&1 || return 1
					base=${i%/}
					base=${base##*/}
					if [ -L "$base" ]
					then
						i=$(ls -l -- "$base")
						i=${i#*"$base -> "}
					else
						dir=$(pwd -P)
						dir=${dir%/}
						printf '%s/%s\n' "$dir" "$base"
						break
					fi
				done
			fi
			cd -- "$pwd"
		done
		return $status
	}
fi

if ! has_cmd readlink
then
	readlink()
	{
		[ -L "$1" ] || return 1
		local i= lsout=
		for i
		do
			lsout=$(ls -l -- "$i")
			echo "${lsout#*"$i -> "}"
		done
	}
fi

# Check if the variable named $1 exists
is_set()
{
	eval "[ \"\${$1+x}\" ]"
}

# Return the value of variable named $1, fails if no such variable exists
value()
{
	match "$1" '[0-9]+' &&
		{ echo "positional parameters can't be used with value()" >&2; return 1; }
	is_set "$1" ||
		{ echo "$var: variable not set" >&2; return 1; }
	eval echo "\"\$$1\""
}

# Append the remaining arguments to $1 which is interpreted as a whitespace delimited list
append()
{
	local first="$1"
	shift
	echo "${first:+$first }$*"
}

# Append the remaining arguments to $1 which is interpreted as a newline delimited list
appendnl()
{
	local first="$1" nl='
'
	shift
	echo "${first:+$first$nl}$(printf '%s\n' "$@")"
}

# Append the remaining arguments to $1 which is interpreted as a whitespace delimited list,
# only if they're not already to be found
append_chk()
{
	local first="$1"
	shift
	awk -vfirst="$first" -vrem="$*" '
	BEGIN {
		flen = split(first, farr)
		for (i = 1; i <= flen; ++i)
			hash[farr[i]] = 1

		rlen = split(rem, rarr)
		for (i = 1; i <= rlen; ++i)
		{
			if (!(rarr[i] in hash))
				farr[++flen] = rarr[i]
		}

		for (i = 1; i < flen; ++i)
			printf "%s ", farr[i]
		printf "%s\n", farr[flen]
	}'
}

# Append the remaining arguments to $1 which is interpreted as a newline delimited list,
# only if they're not already to be found
appendnl_chk()
{
	local first="$1"
	shift
	echo "$first" | awk -vrem="$(printf '%s\n' "$@")" '
	{hash[$0] = 1; print}
	END {
		rlen = split(rem, rarr, "\n")
		for (i = 1; i <= rlen; ++i)
		{
			if (!(rarr[i] in hash))
				print rarr[i]
		}
	}'
}

# Return its last argument
lastarg()
{
	eval echo "\${$#}"
}

# Check that type $1 is respected for the remaining argument variables
typecheck()
{
	local type="$1" var= val= success=true
	shift
	for var
	do
		match "$var" '[0-9]+' && die "positional parameters can't be used with typecheck"
		val=$(value "$var") || exit 1
		case "$type" in
			bool)
				[ "$val" != true ] && [ "$val" != false ] && {
					echo "$var is of type bool, must contain \"true\" or \"false\", not \"$val\""
					success=false
				}
				;;
			int)
				! match "$val" '[+-]?[0-9]+' && {
					echo "$var is of type int, must contain an integer, not \"$val\""
					success=false
				}
				;;
			uint)
				! match "$val" '\+?[0-9]+' && {
					echo "$var is of type uint, must contain a positive integer, not \"$val\""
					success=false
				}
				;;
			float)
				{ ! match "$val" '[+-]?[0-9]*\.[0-9]*' || match "$val" '[+-]?\.'; } && {
					echo "$var is of type float, must contain a floating point value, not \"$val\""
					success=false
				}
				;;
			"enum "*)
				success=false
				local nosep=$(echo "${type#enum }" | sed 's#[[:blank:]]*|[[:blank:]]*# #g')
				for item in $nosep
				do
					[ "$val" = "$item" ] && { success=true; break; }
				done
				! $success &&
					echo "$var is of type \"$type\", must contain one of \"$nosep\", not \"$val\""
				;;
			*)
				die "$type: unknown type"
				;;
		esac
	done >&2
	$success
}

# Returns 0 if $1 matches $2 (as an ERE), 1 otherwise
match()
{
	echo "$1" | grep -Eqx -- "$2"
}

# Die with an appropriate message if "test $1" returns false for any of the
# remaining argument paths or if one of these doesn't exists
requirefile()
{
	local testarg="$1" i=
	shift
	for i
	do
		[ ! -L "$i" ] && [ ! -e "$i" ] && die "$i: file not found"
		if [ "$testarg" != "-e" ] && [ ! "$testarg" "$i" ]
		then
			case "$testarg" in
				-b)    die "$i: not a block device";;
				-c)    die "$i: not a character special file";;
				-d)    die "$i: not a directory";;
				-f)    die "$i: not a regular file";;
				-g)    die "$i: not a setgid file";;
				-h|-L) die "$i: not a symbolic link";;
				-p)    die "$i: not a FIFO";;
				-r)    die "$i: not a readable file";;
				-S)    die "$i: not a socket";;
				-s)    die "$i: not a non-empty file";;
				-u)    die "$i: not a setuid file";;
				-w)    die "$i: not a writeable file";;
				-x)    die "$i: not a executable file";;
			esac
		fi
	done
}

# For each argument, check for executable presence; use a|b|c... for alternatives
requirebin()
{
	local i= j= success=
	for i
	do
		if match "$i" '.*/.*'
		then
			i=$(echo "$i" | tr '/' ' ')
			success=false
			for j in $i
			do
				if has_cmd "$j"
				then
					success=true
				fi
			done
			if ! $success
			then
				echo "At least one executable amongst $i required"
				return 1
			fi
		elif ! has_cmd "$i"
		then
			echo "$i: executable not found"
			return 1
		fi
	done
}

# Die with an appropriate message if one of the argument paths exists
forbidfile()
{
	local i=
	for i
	do
		if [ -L "$i" ] || [ -e "$i" ]
		then
			die "$i: file already exists"
		fi
	done
}

# Output all arguments separated by '\n'. If there is no argument or the only
# argument is '-', output stdin instead
readargs()
{
	if [ $# -eq 0 ] || { [ $# -eq 1 ] && [ "$1" = "-" ]; }
	then
		cat
	else
		printf '%s\n' "$@"
	fi
}

# Like map.sh, for lighter use with functions
map()
{
	local cmd="$1" it=
	shift
	readargs "$@" | while IFS= read -r it
	do
		eval "$cmd"
	done
}

# Like filter.sh, for lighter use with functions
filter()
{
	local cmd="$1" it=
	shift
	readargs "$@" | while IFS= read -r it
	do
		eval "$cmd" >/dev/null && echo "$it"
	done
}

# Single quote $1
quote()
{
	echo "$1" | sed "s#'#'\\\\''#g; s#^#'#; s#\$#'#"
}
# Double quote $1
dquote()
{
	echo "$1" | sed 's#"#\\"#g; s#^#"#; s#$#"#'
}

# Double quote $1 $2 times (defaults to 1)
dquote_nest()
{
	local res="$1" cnt="${2:-1}"
	while [ $cnt -ne 0 ]
	do
		res=$(echo "$res" | sed 's#"#\\"#g; s#^#"#; s#$#"#')
		cnt=$((cnt - 1))
	done
	echo "$res"
}

# Escape all BRE metacharacters in $1
bre_escape()
{
	echo "$1" | sed 's#[[^$*.\\-]#\\&#g'
}

# Escape all ERE metacharacters in $1
ere_escape()
{
	echo "$1" | sed 's#[()|{}+?[^$*.\\-]#\\&#g'
}

# Escape all AWK regexp metacharacters in $1
awk_re_escape()
{
	echo "$1" | sed 's#[()|{}+?[^$*.\\-]#\\\\&#g'
}

# Escape all sed substitute metacharacters in $1
sed_repl_escape()
{
	echo "$1" | sed 's#[\\&]#\\&#g'
}

# Escape all globbing metacharacters in $1
glob_escape()
{
	echo "$1" | sed 's#[[*?]#\\&#g'
}

# Emulation for find -- $1 -mindepth 1 -maxdepth 1 $1..$$#
listfiles()
{
	local dir="$1"
	shift
	find -- "$dir" \( ! -path "$(glob_escape "$dir")" -prune \) "$@"
}

# xargs -d'\n' emulation
# Portability: GNU, *BSD, MacOS, Illumos
xargsnl()
{
	tr '\n' '\000' | xargs -0 "$@"
}

# Convert $1 to lowercase
tolower()
{
	echo "$1" | tr '[:upper:]' '[:lower:]'
}

# Portable head -n-val
headneg()
{
	! match "$1" '[[:digit:]]+' && return 1
	awk -varg="$1" '{if(NR > arg) print buf[NR % arg]; buf[NR % arg] = $0}'
}

# Execute $2..@ and quiets its output according to $1 (true or false)
cond_quiet()
{
	local quiet="$1"
	typecheck bool quiet
	shift
	if $quiet
	then
		"$@" >/dev/null 2>&1
	else
		"$@"
	fi
}

# Format stdin so that __foo_bar__ is underlined and **foo*bar** is emboldened
# Portability: GNU, *BSD, MacOS, Illumos
text_format()
{
	local sgr0= bol= smul= rmul=
	if [ -t 1 ]
	then
		sgr0=$(tput sgr0) || true
		bold=$(tput bold) || true
		smul=$(tput smul) || true
		rmul=$(tput rmul) || true
	fi
	sed -E \
		-e ":a; s#([^_]|^)__(([^_]*(_[^_])*[^_]*)+)__([^_]|\$)#\1$smul\2$rmul\5#; ta" \
		-e ":b; s#([^*]|^)\*\*(([^\*]*(\*[^*])*[^*]*)+)\*\*([^*]|\$)#\1$bold\2$sgr0\5#; tb"
}

# Try to extract the extension of $1
file_ext()
{
	echo "$1" | sed -n 's#\(.*/\)\{0,1\}[^/]*\.\([^/.]*\)$#\2#p'
}


# Extract the basename of a $1 and remove its extension
file_base()
{
	echo "${1##*/}" | sed 's#\.[^/.]*$##'
}

file_size()
{
	ls -n -- "$1" | cut -d' ' -f5
}

# Print the mimetype of $1
mimetype()
{
	file --dereference --brief --mime-type -- "$1"
}

# Read a password securely into variable $2 using $1 as a prompt
read_password()
{
	printf '%s ' "$1"
	stty -echo
	read -r "$2"
	stty echo
	echo
}

# Takes argv ("$@") as argument and determines if the help option is called
is_help()
{
	[ $# -eq 1 ] && ([ "$1" = "-h" ] || [ "$1" = "--help" ])
}

# Print stdin lines as a pretty list: "line1, line2, ..."
list_join()
{
	local sep="${1:-, }"
	sed ':a; N; $!ba; s#\n#'"$(sed_repl_escape "$sep")"'#g'
}

# Execute $@ with sh then outputs the number of seconds it took
real_time()
{
	command time -p sh -c '{ "$@";} 2>&3 >/dev/null' dummy "$@" 3>&2 2>&1 | \
		sed -n 's#^real ##p'
}

# Produce a "random" 32 bit unsigned number using a classic LCG
rand()
{
	[ -c /dev/urandom ] && \
		_rand_state=$(od -An -N4 -t u4 /dev/urandom | tr -d '[:blank:]') || \
		_rand_state=$$
	rand() { echo $((_rand_state = (_rand_state * 1103515245 + 12345) & 2147483647)); }
	rand
}

# IFS split $1 into the variables $2, $3, ...
read_split()
{
	local str="$1"
	shift
	read -r "$@" <<-EOF
		$str
EOF
}

# Something a bit like select. The selection is read on stdin and the result is
# printed to stdout
sselect()
{
	local choice= in="$(cat)"
	local len="$(echo "$in" | wc -l)"
	while true
	do
		echo "$in" | awk '{printf "%d) %s\n", NR, $0}' >&2
		printf '\n#?' >&2
		read -r choice </dev/tty
		if ! match "$choice" '[0-9]+' || [ $choice -gt $len ]
		then
			echo "$choice: invalid value" >&2
			continue
		fi
		echo "$in" | sed -n "$choice"'{p; q}'
		break
	done
}

! $_is_interactive && export PARALLEL=
# GNU parallel handling nested instances
parallel()
{
	if [ "${PARALLEL_PID:-}" ]
	then
		command parallel --no-notice -j1 "$@"
	else
		has_cmd ionice && ionice='ionice -c idle'
		${ionice:-} parallel --no-notice "$@"
	fi
}

# Like the usual tac(1), print lines in reverse
ptac()
{
	awk '{line[NR] = $0} END {for (i = NR; i; --i) {print line[i]}}' "$@"
}

# Recursively delete empty directories
rmdir_recursive()
{
	local i=
	for i
	do
		find -- "$i" -type d | awk -F/ '{print NF, $0}' | sort -k1 -n | rev | \
			cut -d' ' -f2- | xargsnl rmdir --
	done
}

# GNU/BSD-like seq without options
if ! has_cmd seq
then
	pseq()
	{
		local incr=1 first=1
		case $# in
			1)	last=$1;;
			2)
				first=$1
				last=$2
				;;
			3)
				first=$1
				incr=$2
				last=$3
				;;
		esac
		while [ $first -le $last ]
		do
			echo $first
			first=$((first + incr))
		done
	}
fi

# URL decode $1
urldecode()
{
	echo "$1" | sed 's#+# #g; s#%#\\x#g' | xargsnl printf '%b\n'
}

# Portable to Linux, *BSD and Mac
numcpu()
{
	getconf _NPROCESSORS_ONLN
}

# Queue $* to the script queue triggered by trap EXIT
# A trap for common abort signals is also set so that they trigger EXIT after setting the
# variable _aborted to true
#
# Only for non-interactive shells (how to check on POSIX?)
if ! $_is_interactive
then
   _atexit_scripts=
   _aborted=false
   trap '_aborted=true; exit 1' HUP INT QUIT ${ZSH_VERSION-ABRT} TERM
   trap 'set +e; eval "$_atexit_scripts"' EXIT
   atexit() { _atexit_scripts=$(appendnl "$_atexit_scripts" "$*"); }
fi

# Portable mktemp [-d]
# Use $(echo "mkstemp(/tmp/tmp.XXXXXX)" | m4) if you just want mktemp
if ! has_cmd mktemp || ! _test_mktemp=$(mktemp -d) || ! rmdir -- "$_test_mktemp"
then
	mkmktemp()  # Use a function just to avoid polluting the global var namespace
	{
		# Simplistic mktemp -d (can't use the same technique for files because set -o noclobber and
		# { >path; } aren't enough, cf https://austingroupbugs.net/view.php?id=1364)
		local dir=
		while true
		do
			dir=/tmp/tmp.$(rand)
			mkdir "$temp_dir" >/dev/null 2>&1 && break
		done
		cat <<'EOF' >"$temp_dir"/mktemp.c
#define _DEFAULT_SOURCE

#include <errno.h>
#include <getopt.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>


static void usage(FILE *stream, int exit_status)
{
	fprintf(stream,
		"Usage: mktemp [-d]\n"
		"\n"
		"Create a temporary file or directory in $TMPDIR or /tmp if $TMPDIR is unset or \n"
		"empty then print its path to stdout.\n"
	);
	exit(exit_status);
}

int main(int argc, char **argv)
{
	const char template_base[] = "tmp.XXXXXXXXXX";
	int dir = 0;
	for (int opt; (opt = getopt(argc, argv, "dh")) != -1; )
	{
		switch (opt)
		{
			case 'd':
				dir = 1;
				break;

			case 'h':
				usage(stdout, EXIT_SUCCESS);

			case '?':
				usage(stderr, EXIT_FAILURE);
		}
	}

	const char *tmpdir = "/tmp";
	size_t tmpdir_len = sizeof("/tmp") - 1;

	const char *env = getenv("TMPDIR");
	if (env && env[0] != '\0')
	{
		tmpdir = env;
		tmpdir_len = strlen(env);
		for (; tmpdir_len && env[tmpdir_len - 1] == '/'; --tmpdir_len)
			;
	}

	size_t template_len = tmpdir_len + 1 + sizeof(template_base);
	char *template = malloc(template_len);
	if (!template)
	{
		fprintf(stderr, "malloc(%zu): %s\n", template_len, strerror(errno));
		return EXIT_FAILURE;
	}
	snprintf(template, template_len, "%.*s/%s", (int)tmpdir_len, tmpdir, template_base);

	if (dir)
	{
		if (!mkdtemp(template))
		{
			fprintf(stderr, "mkdtemp(%s): %s\n", template, strerror(errno));
			return EXIT_FAILURE;
		}
	}
	else
	{
		int fd = mkstemp(template);
		if (fd == -1)
		{
			fprintf(stderr, "mkstemp(%s): %s\n", template, strerror(errno));
			return EXIT_FAILURE;
		}
		(void)close(fd);
	}
	puts(template);
	return EXIT_SUCCESS;
}
EOF
		c99 -O -s -o "$dir"/mktemp "$dir"/mktemp.c
		alias mktemp="$dir"/mktemp
		atexit rm -r "$dir"
	}
	mkmktemp
fi
