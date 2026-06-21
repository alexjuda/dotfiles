# Extracting tars is super cumbersome.
# Source: https://askubuntu.com/a/792063
function untar() {
    local filename="$1"
    local basename="${filename%.tar.gz}"

    mkdir -p $basename
    tar -xzf $filename -C $basename
}
