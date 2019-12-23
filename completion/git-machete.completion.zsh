#compdef git-machete

_git-machete() {
    local ret=1

    _arguments -C \
        '1: :_git_machete_commands' \
        '*::arg:->args' \
        '(--debug)'--debug'[Log detailed diagnostic info, including outputs of the executed git commands]' \
        '(-h --help)'{-h,--help}'[Print help and exit]' \
        '(-v --verbose)'{-v,--verbose}'[Log the executed git commands]' \
        '(--version)'--version'[Print version and exit]' \
    && ret=0

    case $state in
        (args)
            case ${line[1]} in
                (add)
                    _arguments \
                        '1:: :_git_machete_list_unmanaged' \
                        '(-o --onto)'{-o,--onto=}'[Specify the target parent branch to add the given branch onto]: :_git_machete_list_managed' \
                        '(-y --yes)'{-y,--yes}'[Do not ask for confirmation whether to create the branch or whether to add onto the inferred upstream]' \
                    && ret=0
                    ;;
                (anno|e|edit|file)
                    ;;
                (d|diff)
                    _arguments \
                        '1:: :__git_branch_names' \
                        '(-s --stat)'{-s,--stat}'[Pass --stat option to git diff, so that only summary (diffstat) is printed]' \
                    && ret=0
                    ;;
                (delete-unmanaged)
                    _arguments \
                        '(-y --yes)'{-y,--yes}'[Do not ask for confirmation]' \
                    && ret=0
                    ;;
                (discover)
                    # TODO complete the comma-separated list of roots
                    _arguments \
                        '(-C --checked-out-since)'{-C,--checked-out-since=}'[Only consider branches checked out at least once since the given date]' \
                        '(-l --list-commits)'{-l,--list-commits}'[List the messages of commits introduced on each branch]' \
                        '(-r --roots)'{-r,--roots=}'[Comma-separated list of branches to be considered roots of trees of branch dependencies (typically develop and/or master)]: :__git_branch_names' \
                        '(-y --yes)'{-y,--yes}'[Do not ask for confirmation]' \
                    && ret=0
                    ;;
                (fork-point)
                    # TODO correctly suggest branches for `--unset-override`
                    _arguments '1:: :__git_branch_names' \
                        '(--inferred)'--inferred'[Display the fork point ignoring any potential override]' \
                        '(--override-to)'--override-to='[Override fork point to the given revision]: :__git_references' \
                        '(--override-to-inferred)'--override-to-inferred'[Override fork point to the inferred location]' \
                        '(--override-to-parent)'--override-to-parent'[Override fork point to the upstream (parent) branch]' \
                        '(--unset-override)'--unset-override'[Unset fork point override by removing machete.overrideForkPoint.<branch>.* configs]' \
                    && ret=0
                    ;;
                (g|go|show)
                    _arguments '1:: :_git_machete_directions' && ret=0
                    ;;
                (help)
                    _arguments '1:: :_git_machete_help_topics' && ret=0
                    ;;
                (l|log)
                    _arguments '1:: :__git_branch_names' && ret=0
                    ;;
                (list)
                    _arguments '1:: :_git_machete_categories' && ret=0
                    ;;
                (reapply|update)
                    _arguments \
                        '(-f --fork-point)'{-f,--fork-point=}'[Fork point commit after which the rebased part of history is meant to start]: :__git_references' \
                    && ret=0
                    ;;
                (slide-out)
                    _arguments \
                        # TODO suggest further branches based on the previous specified branch (like in Bash completion script)
                        '*:: :_git_machete_list_slidable' \
                        '(-d --down-fork-point)'{-d,--down-fork-point=}'[Fork point commit after which the rebased part of history of the downstream branch is meant to start]: :__git_references' \
                        '(-n --no-interactive-rebase)'{-n,--no-interactive-rebase}'[Run git rebase in non-interactive mode (without -i/--interactive flag)]' \
                    && ret=0
                    ;;
                (s|status)
                    _arguments \
                        '(--color)'--color='[Colorize the output; argument can be "always", "auto", or "never"]: :_git_machete_opt_color_args' \
                        '(-L --list-commits-with-hashes)'{-L,--list-commits-with-hashes}'[List the short hashes and messages of commits introduced on each branch]' \
                        '(-l --list-commits)'{-l,--list-commits}'[List the messages of commits introduced on each branch]' \
                    && ret=0
                    ;;
                (traverse)
                    _arguments \
                        '(-F --fetch)'{-F,--fetch}'[Fetch the remotes of all managed branches at the beginning of traversal]' \
                        '(-l --list-commits)'{-l,--list-commits}'[List the messages of commits introduced on each branch]' \
                        '(-n --no-interactive-rebase)'{-n,--no-interactive-rebase}'[Run git rebase in non-interactive mode (without -i/--interactive flag)]' \
                        '(--return-to)'--return-to='[The branch to return after traversal is successfully completed; argument can be "here", "nearest-remaining", or "stay"]: :_git_machete_opt_return_to_args' \
                        '(--start-from)'--start-from='[The branch to  to start the traversal from; argument can be "here", "root", or "first-root"]: :_git_machete_opt_start_from_args' \
                        '(-w --whole)'{-w,--whole}'[Equivalent to --start-from=first-root --no-interactive-rebase --return-to=nearest-remaining]' \
                        '(-W)'-W'[Equivalent to --fetch --whole]' \
                        '(-y --yes)'{-y,--yes}'[Do not ask for any interactive input; implicates -n]' \
                    && ret=0
                    ;;
            esac
    esac
}

_git_machete_cmds=(
    'add:Add a branch to the tree of branch dependencies'
    'anno:Manage custom annotations'
    'delete-unmanaged:Delete local branches that are not present in the definition file'
    {diff,d}':Diff current working directory or a given branch against its computed fork point'
    'discover:Automatically discover tree of branch dependencies'
    {edit,e}':Edit the definition file'
    'file:Display the location of the definition file'
    'fork-point:Display SHA of the computed fork point commit of a branch'
    {go,g}':Check out the branch relative to the position of the current branch'
    'help:Display this overview, or detailed help for a specified command'
    'list:List all branches that fall into one of pre-defined categories (mostly for internal use)'
    {log,l}':Log the part of history specific to the given branch'
    'reapply:Rebase the current branch onto its computed fork point'
    'show:Show name(s) of the branch(es) relative to the position of the current branch'
    'slide-out:Slide the current branch out and rebase its downstream (child) branch onto its upstream (parent) branch'
    {status,s}':Display formatted tree of branch dependencies, including info on their sync with upstream branch and with remote'
    'traverse:Walk through the tree of branch dependencies and ask to rebase, slide out, push and/or pull branches, one by one'
    'update:Rebase the current branch onto its upstream (parent) branch'
    'version:Display version and exit'
)

_git_machete_commands() {
    _describe -t _git_machete_cmds 'git machete command' _git_machete_cmds "$@"
}

_git_machete_help_topics() {
    local topics
    set -A topics ${_git_machete_cmds}
    topics+=(
        'format:Format of the .git/machete definition file'
        'hooks:Display docs for the extra hooks added by git machete'
    )
    _describe -t topics 'git machete help topic' topics "$@"
}

_git_machete_directions() {
    local directions
    directions=(
        {d,down}':child(ren) in tree of branch dependencies'
        {f,first}':first child of the current root branch'
        {l,last}':last branch located under current root branch'
        {n,next}':the one defined in following line in .git/machete file'
        {p,prev}':the one defined in preceding line in .git/machete file'
        {r,root}':root of the tree of branch dependencies where current branch belongs'
        {u,up}':parent in tree of branch dependencies'
    )
    _describe -t directions 'direction' directions "$@"
}

_git_machete_categories() {
    local categories
    # TODO complete slidable-after's argument
    categories=(
        'managed:all branches that appear in the definition file'
        'slidable:all managed branches that have exactly one upstream and one downstream (i.e. the ones that can be slid out with slide-out command)'
        'slidable-after:the downstream branch of the given branch, if it exists and is its only downstream (i.e. the one that can be slid out immediately following <branch>)'
        'unmanaged:all local branches that do not appear in the definition file'
        'with-overridden-fork-point:all local branches that have a fork point override config'
    )
    _describe -t categories 'category' categories "$@"
}

_git_machete_opt_color_args() {
    local opt_color_args
    opt_color_args=(
        'always:always emits colors'
        'auto:emits colors only when standard output is connected to a terminal'
        'never:colors are disabled'
    )
    _describe -t opt_color_args 'color argument' opt_color_args "$@"
}

_git_machete_opt_return_to_args() {
    local opt_return_to
    opt_return_to=(
        'here:the current branch at the moment when traversal starts'
        'nearest-remaining:nearest remaining branch in case the "here" branch has been slid out by the traversal'
        'stay:the default - just stay wherever the traversal stops'
    )
    _describe -t opt_return_to 'return-to argument' opt_return_to "$@"
}

_git_machete_opt_start_from_args() {
    local opt_start_from
    opt_start_from=(
        'here:the default - current branch, must be managed by git-machete'
        'root:root branch of the current branch, as in git machete show root'
        'first-root:first listed managed branch'
    )
    _describe -t opt_start_from 'start-from argument' opt_start_from "$@"
}

_git_machete_list_managed() {
    local list_managed
    IFS=$'\n' list_managed=($(git machete list managed))
    _describe -t list_managed 'managed branch' list_managed "$@"
}

_git_machete_list_slidable() {
    local list_slidable
    IFS=$'\n' list_slidable=($(git machete list slidable))
    _describe -t list_slidable 'slidable branch' list_slidable "$@"
}

_git_machete_list_unmanaged() {
    local list_unmanaged
    IFS=$'\n' list_unmanaged=($(git machete list unmanaged))
    _describe -t list_unmanaged 'unmanaged branch' list_unmanaged "$@"
}

zstyle ':completion:*:*:git:*' user-commands machete:'organize your repo, instantly rebase/push/pull and more'
