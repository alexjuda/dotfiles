function retry() {
    local sleep_time=${RETRY_SLEEP:-1}
    while ! "$@"; do
        echo "Command '$@' failed, retrying in ${sleep_time}s..."
        sleep $sleep_time
    done
}
