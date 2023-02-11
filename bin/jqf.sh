#!/usr/bin/env bash
# another version of JQ repl that lets you edit JQ strings and get live feedaback
# its extremely useful and saves a ton of time

panic() {
  # shellcheck disable=SC2059
  printf >&2 "$@"
  exit 1
}

tmp_dir="$(mktemp --directory -t jqf.XXXXXXXXXX)"
trap 'command rm -rf $tmp_dir' EXIT

jq --help | grep -Po '\-\-?[\w\-\=]+' | sed 's/=$/=.*/' >"$tmp_dir/tmp_jq_args"

inputs=()
jq_args=()
eval=0
while [[ $# -gt 0 ]]; do
  case "$1" in
  --arg|--argjson|--slurpfile|--rawfile)
      jq_args+=("$1" "$2" "$3")
    shift
    shift
    shift
    ;;
  --indent|-f|--from-file|-L)
      jq_args+=("$1" "$2")
    shift
    shift
    ;;
  -L*)
      jq_args+=("$1")
    shift
    ;;
  -h | --help)
    printf >&2 "WARNING: argument '%s' ignored\n" "$1"
    shift
    ;;
  -z)
    eval=1
    shift
    ;;
  *)
    if grep -qFx -f "$tmp_dir/tmp_jq_args" <<<"$1"; then
      jq_args+=("$1")
      shift
      continue
    fi
    if [[ -f "$1" ]]; then
      if [[ ! -r "$1" ]]; then
        panic "file %s does not exist" "$1"
      fi

      inputs+=("$1")
      shift
      continue
    fi
    panic "unknown arg %s" "$1"
    shift
    ;;
  esac
done

# todo this doesn't allow for streaming any more. It will block until stdin is finished.
if [[ ${#inputs[@]} -eq 0 ]]; then
  input="$tmp_dir/in"
  cat /dev/stdin >"$input"
  inputs+=("$input")
fi

preview_cmd_args_file="$tmp_dir/args"
header_file="$tmp_dir/header"
touch "$preview_cmd_args_file"
printf '%s\n' '-C' >>"$preview_cmd_args_file"
command cp "$preview_cmd_args_file" "$header_file"

history_file="$HOME/.cache/fzf/.jqfhistory"
[[ ! -d $(dirname "$history_file") ]] && mkdir -p "$(dirname "$history_file")"
touch "$history_file"

_jqf_preview_cmd() {
  cat <<EOF
query={q}
[ ! -n \$query ] && query="." # todo this doesn't work
jq_args=()
[[ "${#jq_args[@]}" -gt 0 ]] && jq_args+=($(printf " %q" "${jq_args[@]}"))
while IFS='' read -r arg; do
  arg="\${arg#"\${arg%%[![:space:]]*}"}" # remove leading whitespace characters
  arg="\${arg%"\${arg##*[![:space:]]}"}" # remove trailing whitespace characters
  if [[ -n \$arg ]]; then
    jq_args+=("\$arg")
  fi
done < <(
  cat "$preview_cmd_args_file"
)
command jq "\${jq_args[@]}" "\$query" "${inputs[@]}" >"$tmp_dir/out.tmp" 2>&1
rc=\$?
headers="\$(sed 's/\x1B\[\([0-9]\{1,2\}\(;[0-9]\{1,2\}\)\?\)\?[mGK]//g' $header_file | grep -vE '^(err|null|OK)$')"
if [[ ! -f $tmp_dir/out ]]; then
  command mv $tmp_dir/out.tmp $tmp_dir/out
  headers="\$(printf '\x1b[1;32mOK\x1b[0m\n%s\n' "\$headers")"
elif [[ \$rc != 0 ]]; then
  headers="\$(printf '\x1b[1;31merr\x1b[0m\n%s\n' "\$headers")"
  printf "\x1b[1;31m"
  command cat "$tmp_dir/out.tmp"
  printf "---\n\x1b[0m"
elif [[ "\$(sed 's/\x1B\[\([0-9]\{1,2\}\(;[0-9]\{1,2\}\)\?\)\?[mGK]//g' $tmp_dir/out.tmp)" == 'null' ]]; then
  headers="\$(printf '\x1b[1;33mnull\x1b[0m\n%s\n' "\$headers")"
else
  command mv $tmp_dir/out.tmp $tmp_dir/out
  headers="\$(printf '\x1b[1;32mOK\x1b[0m\n%s\n' "\$headers")"
fi
printf "\$headers" > $header_file
sync
command cat $tmp_dir/out
EOF
}

_jqf_update_flag_cmd() {
  opt="$1"
  opt_exclusive="${2:-}"

  # language=shell
  command cat <<EOF
  if grep -qF -- "$opt" "$preview_cmd_args_file"; then
    sed -i "/^$opt/d" "$preview_cmd_args_file"
  else
EOF
  if [[ -n $opt_exclusive ]]; then
    command cat <<EOF
    sed -i "/^$opt_exclusive/d" "$preview_cmd_args_file";
EOF
  fi

  command cat <<EOF
    printf "%s\n" "$opt" >> "$preview_cmd_args_file";
  fi
  command cp "$preview_cmd_args_file" "$header_file"
  sync
EOF
}

# todo sleep 0.1 is hacky. Need a better way of ensuring the header file is updated before FZF is reloaded.
query="$(
  echo -e "$(<"$header_file")\n" |
    fzf --phony \
      --no-extended \
      --disabled \
      --sync \
      --ansi \
      --tabstop=4 \
      --prompt='jq> ' \
      --history="$history_file" \
      --info=hidden \
      --header-lines=1 \
      --print-query \
      --preview-window='down:99%' \
      --preview "$(_jqf_preview_cmd "${jq_args[@]}")" \
      --bind "change:refresh-preview+reload(sleep 0.1; tr '\n' ' ' <$header_file)" \
      --bind="alt-r:execute-silent($(_jqf_update_flag_cmd "-r"))+refresh-preview+reload(sleep 0.1; tr '\n' ' ' <$header_file)" \
      --bind="alt-c:execute-silent($(_jqf_update_flag_cmd "-c"))+refresh-preview+reload(sleep 0.1; tr '\n' ' ' <$header_file)" \
      --bind="alt-j:execute-silent($(_jqf_update_flag_cmd "-j")+refresh-preview+reload(sleep 0.1; tr '\n' ' ' <$header_file)" \
      --bind="alt-0:execute-silent($(_jqf_update_flag_cmd "-0")+refresh-preview+reload(sleep 0.1; tr '\n' ' ' <$header_file)" \
      --bind="alt-M:execute-silent($(_jqf_update_flag_cmd "-M" "-C")+refresh-preview+reload(sleep 0.1; tr '\n' ' ' <$header_file)" \
      --bind="alt-C:execute-silent($(_jqf_update_flag_cmd "-C" "-M")+refresh-preview+reload(sleep 0.1; tr '\n' ' ' <$header_file)" \
      --bind="ctrl-d:preview-half-page-down,ctrl-u:preview-half-page-up" \
      --bind="ctrl-j:preview-down,ctrl-k:preview-up" \
      --bind="pgdn:preview-half-page-down,pgup:preview-half-page-up" \
      --bind="down:preview-down,up:preview-up"
)"

printf "%s\n" "$query"

if [[ -n "$eval" ]]; then
  while read -r arg; do jq_args+=("$arg"); done <"$preview_cmd_args_file"
  printf "\n"
  jq "${jq_args[@]}" "$query" "${inputs[@]}"
  exit $?
fi
