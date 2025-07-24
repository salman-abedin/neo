#!/bin/sh

LOGFILE="$HOME/.neo-log.log"
ENTRYFILE="$HOME/.neo-entry.log"
RECEPIENT=me@salmanabedin.com

timestamp=$(date)
commit_id=
commit_author=

notify(){
    cat <<eof | sendmail -t -oi -f salman.abedin@dsinnovators.com -t $RECEPIENT
Subject: $1
$2
eof
}

notify_success(){
    notify "✅ Neo was Deployed Succeesfully!" "To the infinity and beyond!"
    echo "$timestamp,$commit_id,$commit_author,succeeded" >> "$ENTRYFILE"
}

notify_failure(){
    notify "❌ Neo Deployment Failed!" "Failure is the piller of success!"
    echo "$timestamp,$commit_id,$commit_author,failed" >> "$ENTRYFILE"
    exit 1
}

notify_rollback(){
    notify "🧻 Neo Deployment Rolledback!" "One step forward, two step backward!"
    echo "$timestamp,$commit_id,$commit_author,rolledback" >> "$ENTRYFILE"
}

healthcheck(){
    url="http://localhost:5000/health"
    head_start=30
    max_attempts=3
    timeout=5
    delay=5

    sleep $head_start

    for i in $(seq $max_attempts); do
        if curl -fsS -m "$timeout" "$url" > /dev/null 2>&1; then
            notify_success
            return 0
        else
            if [ "$i" -lt $max_attempts ]; then
                sleep "$delay"
            fi
        fi
    done

    git reset --hard ORIG_HEAD
    docker compose down
    docker compose up -d --build deploy
    notify_rollback

}

main(){
    exec >> "$LOGFILE" 2>&1
    commit_id=$1
    commit_author=$2
    git pull
    docker compose up --build lint || notify_failure
    docker compose down
    docker compose up -d --build deploy
    healthcheck &
    wait
}
main "$@"
