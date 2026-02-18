#!/bin/bash

RUNTIME=""
COMMAND=""
SCRIPT_NAME=$(basename "$0")

print_help() {
    cat << EOF
Usage: $SCRIPT_NAME RUNTIME COMMAND

RUNTIME:
    docker    Use Docker as the container runtime
    podman    Use Podman as the container runtime

COMMAND:
    build     Build the container image
    run       Run the container with proper volume mounting and user permissions
    help      Show this help message

Examples:
    $SCRIPT_NAME docker build
    $SCRIPT_NAME podman run
EOF
}

validate_runtime() {
    if ! command -v "$1" &> /dev/null; then
        echo "Error: $1 is not installed or not in PATH"
        exit 1
    fi
}

build_image() {
    echo "Building image with $RUNTIME..."
    cd docker
    $RUNTIME build . -t deeplearning-lab
    cd ..
}

run_container() {
    echo "Running container with $RUNTIME..."

    # Disable Git Bash path mangling
    export MSYS_NO_PATHCONV=1
    export MSYS2_ARG_CONV_EXCL="*"

    HOST_PWD="$(pwd -W 2>/dev/null || pwd)"

    # Convert C:\Users\X\project → /mnt/c/Users/X/project
    if [[ "$HOST_PWD" =~ ^[A-Za-z]: ]]; then
        DRIVE=$(echo "${HOST_PWD:0:1}" | tr '[:upper:]' '[:lower:]')
        HOST_PWD="/mnt/${DRIVE}${HOST_PWD:2}"
        HOST_PWD="${HOST_PWD//\\//}"
    fi

    if [ "$RUNTIME" = "podman" ]; then
        EXTRA_FLAGS="--userns=keep-id -v \"$HOST_PWD:/home/jovyan/work:Z\""
    else
        EXTRA_FLAGS="-v \"$HOST_PWD:/home/jovyan/work\""
    fi

    eval $RUNTIME run -it --rm \
        -p 8888:8888 \
        $EXTRA_FLAGS \
        deeplearning-lab
}

# Parse arguments
if [ $# -lt 1 ]; then
    print_help
    exit 1
fi

case $1 in
    docker|podman)
        RUNTIME=$1
        validate_runtime "$RUNTIME"
        ;;
    help)
        print_help
        exit 0
        ;;
    *)
        echo "Error: Invalid runtime '$1'"
        print_help
        exit 1
        ;;
esac

if [ $# -lt 2 ]; then
    echo "Error: Missing command"
    print_help
    exit 1
fi

case $2 in
    build)
        build_image
        ;;
    run)
        run_container
        ;;
    help)
        print_help
        ;;
    *)
        echo "Error: Invalid command '$2'"
        print_help
        exit 1
        ;;
esac
