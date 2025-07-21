#! /usr/bin/env bash

script_dir=$(dirname $0)
bin_dir="$script_dir/../bin"
root_dir="$script_dir/../"
valon_output_dir="$script_dir/../valon_output"
mkdir -p $valon_output_dir

# Store the current working directory in a temporary variable.
CURR_PATH=$(pwd);

# When the script exits, change back into the original directory.
trap "cd $CURR_PATH" EXIT;

cd $root_dir

release_branches=("release-22.0-valon-fork")
binaries=("vtgate" "vttablet")
# os=("linux" "darwin")
os=("linux")
arch=("amd64" "arm64")

for release_branch in "${release_branches[@]}"; do  
    git checkout $release_branch
    for os in "${os[@]}"; do
        for arch in "${arch[@]}"; do
            echo "Building binaries for $os/$arch"
            NOVTADMINBUILD=true GOOS=$os GOARCH=$arch make build
            for binary in "${binaries[@]}"; do
                # Copy the binary to the valon_output_dir
                cp $bin_dir/$binary $valon_output_dir/$binary-$os-$arch-$release_branch
            done
        done
    done
done
