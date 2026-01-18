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
    $RUNTIME run --userns=keep-id:uid=$(id -u),gid=$(id -g) \
                -it --rm \
                -p 8888:8888 \
                -v "$(pwd):/home/jovyan/work" \
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
