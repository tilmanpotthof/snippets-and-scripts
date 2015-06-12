#!/bin/bash
# source: http://stackoverflow.com/questions/7773939/show-git-ahead-and-behind-info-for-all-branches-including-remotes
# by http://github.com/jehiah 
# this prints out some branch status (similar to the '... ahead' info you get from git status)

# example:
# $ git branch-status
# dns_check (ahead 1) | (behind 112) origin/master
# master (ahead 2) | (behind 0) origin/master

git for-each-ref --format="%(refname:short) %(upstream:short)" refs/heads | \
while read local remote
do
    [ -z "$remote" ] && continue
    git rev-list --left-right ${local}...${remote} -- 2>/dev/null >/tmp/git_upstream_status_delta || continue
    LEFT_AHEAD=$(grep -c '^<' /tmp/git_upstream_status_delta)
    RIGHT_AHEAD=$(grep -c '^>' /tmp/git_upstream_status_delta)
    printf "%-50s (ahead %s) | (behind %s) %s\n" ${local::50} $LEFT_AHEAD $RIGHT_AHEAD $remote
done