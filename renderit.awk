#
# Based on colorit by Aleksey Cheusov <vle@gmx.net>
# Enhanced by Crs.
#

BEGIN {
    for (i=1; i <= ARGC; ++i){
        if (ARGV [i] == "--help"){
            usage()
            exit 1
        }
        if (ARGV [i] == "--version"){
            version()
            exit 1
        }
        if (ARGV [i] == "--config" || ARGV [i] == "-c"){
            config_file = ARGV [i + 1]
            ARGV [i] = ARGV [i + 1] = ""
            ++i
            continue
        }
    }
}

BEGIN {
    mark_count = 0
    break_count = 0
    break_down = 0
}

function do_esc (s){
    gsub(/\\033/, "\033", s)
    return s
}

function do_unquote (s) {
    if (s ~ /^".*"$/ || s ~ /^`.*`$/){
        return substr(s, 2, length(s)-2)
    }else{
        return s
    }
}

function process_config_mark (       ok, arr){
    ok = match($0, /mark +("[^"]+"|`[^`]+`|[^ ]+) +("[^"]+"|`[^`]+`|[^ ]+) +("[^"]+"|`[^`]+`|[^ ]+) *$/, arr)

    if (ok){
        mark_repl[mark_count] = "&"
        mark_re  [mark_count] = do_unquote(arr [1])
        mark_beg [mark_count] = do_esc(do_unquote(arr [2]))
        mark_end [mark_count] = do_esc(do_unquote(arr [3]))

        ++mark_count
        return 1
    }else{
        return 0
    }
}

function process_config_break (ok, arr){
    ok = match($0, /break +("[^"]+"|`[^`]+`|[^ ]+) *$/, arr)

    if (ok){
        mark_break[break_count] = do_unquote(arr [1])
        ++break_count
        return 1
    }else{
        return 0
    }
}

function process_config_gensub (       ok, arr){
    ok = match($0, /^gensub +("[^"]+"|`[^`]+`|[^ ]+) +("[^"]+"|`[^`]+`|[^ ]+) *$/, arr)

    if (ok){
        mark_repl[mark_count] = do_esc(do_unquote(arr [1]))
        mark_re  [mark_count] = do_unquote(arr [2])
        mark_beg [mark_count] = ""
        mark_end [mark_count] = ""

        ++mark_count
        return 1
    }else{
        return 0
    }
}

function process_config_line (){
    sub(/^#.*$/, "")
    if (NF == 0)
        return

    if ($1 == "mark"){
        if (!process_config_mark()){
            print "missing arguments to `mark` at line:\n`" $0 "`" > "/dev/stderr"
            exit 1
        }
    }else if($1 == "break")  {
        if (!process_config_break())  {
            print "missing arguments to `break` at line:\n`" $0 "`" > "/dev/stderr"
            exit 1
        }
    }else if ($1 == "gensub"){
        if (!process_config_gensub()){
            print "missing arguments to `gensub` at line:\n`" $0 "`" > "/dev/stderr"
            exit 1
        }
    }else{
        print "unexpected command `" $1 "`" > "/dev/stderr"
        exit 2
    }
}

function process_config (){
    if (pp == ""){
        pipe = "cat < \"" config_file "\""
        while (0 < (ret = (pipe | getline))){
            process_config_line()
        }
    }else{
        pipe = pp " -DHOME=" ENVIRON ["HOME"] " <\"" config_file "\""

        while (0 < (ret = (pipe | getline))){
            process_config_line()
        }

        close(pipe)
    }
}

BEGIN {
    process_config()
}

{
    if(! break_down)  {
        for (i = 0; i < break_count; ++i)  {
            if(match($0, mark_break[i]) > 0)  {
                break_down = 1
                break;
            }
        }
    }

    if(! break_down)  {
        for (i=0; i < mark_count; ++i){
            cnt = gsub(mark_re [i], (mark_beg [i] "&" mark_end [i]))
            if(cnt > 0)
                break;
        }
    }

    print $0
}

