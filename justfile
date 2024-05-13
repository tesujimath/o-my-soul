build: generate-scripture-index build-tools
    rm -rf docs
    hugo -d docs --buildFuture
    ./buildtools/target/release/lta contextualize-home-links

generate-scripture-index: build-tools
    rm -rf content/ref
    ./buildtools/target/release/lta create-scripture-index --with-sequence-numbers
    ./buildtools/target/release/lta create-scripture-index-links

build-tools:
    #!/usr/bin/env bash
    set -euxo pipefail
    cd buildtools
    nix develop -c cargo build --release

clean:
    rm -rf content/ref docs

localhost := `uname -n`

serve: generate-scripture-index
    hugo server --baseURL http://{{ localhost }}:1313 --bind 0.0.0.0 --disableFastRender --buildFuture --buildDrafts

build-and-serve: build
    static-web-server -d docs -p 1313
