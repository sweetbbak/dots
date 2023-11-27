which sqlite3 >/dev/null 2>&1 || return;

typeset -g HISTDB_QUERY=""
typeset -g HISTDB_FILE="${HOME}/.histdb/zsh-history.db"
typeset -g HISTDB_SESSION=""
typeset -g HISTDB_MAX_ROWID=""
typeset -g HISTDB_DIR_FILTER=1

typeset -gA HISTDB_RESULT

sql_escape () {
    sed -e "s/'/''/g" <<< "$@"
}

_histdb () {
    sqlite3 "${HISTDB_FILE}" "$@"
    [[ "$?" -ne 0 ]] && echo "error in $@"
}

_histdb_init () {
    if ! [[ -e "${HISTDB_FILE}" ]]; then
        _histdb 'create table hist (
             id integer primary key,
             sess integer,
             cmd text,
             pwd text,
             ret integer,
             start integer,
             end integer
           );'
    fi
    if [[ -z "${HISTDB_SESSION}" ]]; then
        HISTDB_SESSION=$(_histdb 'select 1+max(sess) from hist')
        HISTDB_SESSION="${HISTDB_SESSION:-0}"
        readonly HISTDB_SESSION
    fi
}

zshaddhistory () {
    local retval=$?
    local cmd="${1[0,-2]}"
    local now="$(date +%s)"
    _histdb_init
    [[ -z "$cmd" ]] ||
        _histdb "insert into hist (sess, cmd, pwd, ret, start, end)
                values (
                   ${HISTDB_SESSION},
                   '$(sql_escape ${cmd})',
                   '$(sql_escape ${PWD})',
                   ${retval}, ${_STARTED:-${now}}, ${_FINISHED:-${now}}
                );"
    return 0
}

_histdb_query () {
    local tab="	"
    local pwd
    local ret
    local start
    local cmd

    if [[ -n "$1" ]]; then
        IFS=$tab read -r -d '' rowid pwd cmd < \
           <(_histdb -separator $tab \
                     "select max(rowid), pwd, cmd from hist where $1 group by pwd, cmd order by $2 limit 1;")
    fi

    HISTDB_RESULT[rowid]="$rowid"
    HISTDB_RESULT[pwd]="$pwd"
    HISTDB_RESULT[cmd]="${cmd[0,-2]}"

    return 0
}

_histdb_gen_where () {
    if [[ -n "$1" ]]; then
        local where_clause="cmd like '%$(sql_escape $@)%'"

        if [[ -n ${HISTDB_MAX_ROWID} ]]; then
            where_clause="${where_clause} and rowid < ${HISTDB_MAX_ROWID}"
        fi

        case ${HISTDB_DIR_FILTER} in
            1)
                where_clause="${where_clause} and '$(sql_escape $PWD)' like (pwd || '%')"
            ;;
            -1)
                where_clause="${where_clause} and pwd like '$(sql_escape $PWD)%'"
            ;;
        esac
        if [[ ${HISTDB_DIR_FILTER} != 0 ]]; then

        fi

        echo "${where_clause}"
    fi
}

_histdb_gen_order () {
    local order_clause="rowid"

    if [[ ${HISTDB_DIR_FILTER} != 0 ]]; then
        order_clause="-length(pwd), ${order_clause}"
    fi

    echo "${order_clause} desc"
}

_histdb_settings () {
    echo "${HISTDB_DIR_FILTER}"
}

_histdb_render () {
    PREDISPLAY="[$(_histdb_settings)] "
    if [[ -n ${HISTDB_RESULT[rowid]} ]]; then
        POSTDISPLAY=" : ${HISTDB_RESULT[cmd]} in ${HISTDB_RESULT[pwd]}"
    else
        POSTDISPLAY=" : no matches"
    fi
}

_histdb_update_state () {
    _histdb_query "$(_histdb_gen_where ${BUFFER})" "$(_histdb_gen_order)"
    if [[ -n "${BUFFER}" ]]; then
        if [[ -z ${HISTDB_RESULT[rowid]} ]] && [[ $HISTDB_DIR_FILTER != 0 ]]; then
            HISTDB_DIR_FILTER=0
            _histdb_query "$(_histdb_gen_where ${BUFFER})" "$(_histdb_gen_order)"
        fi
    fi
    _histdb_render
}

self-insert-histdb () {
    zle .self-insert
    _histdb_update_state
}

histdb-backwards () {
    HISTDB_MAX_ROWID=${HISTDB_RESULT[rowid]}
    _histdb_update_state
    if [[ -z $HISTDB_RESULT[rowid] ]] ; then
        HISTDB_MAX_ROWID=""
        _histdb_update_state
    fi
}

histdb-search () {
    bindkey -N histdb $KEYMAP
    bindkey -M histdb '^h' histdb-backwards

    HISTDB_MAX_ROWID=""

    # ideally, iterate on keymap and hook all editing commands to refresh
    _histdb_update_state
    zle recursive-edit -K histdb
}

histdb () {
    _histdb -separator "⁣" "select pwd, datetime(max(start), 'unixepoch'), cmd from hist  where cmd like '%$(sql_escape $@)%' group by cmd, pwd order by max(start)" |
        column -t -s "⁣"
}

zle -N histdb-backwards
zle -N self-insert-histdb
zle -N histdb-search

bindkey '^r' histdb-search
