#!/bin/bash
(
    cd $(dirname "$0")
    COMPOSE=docker-compose
    export COMPOSE_PROJECT_NAME=pipeline-assembly-test-remote
    export COMPOSE_FILE=test-remote.yml
    mkdir -p resources/test-remote/cli/var/opt/daisy-pipeline2-cli
    # fixme: don't bring up cli!
    $COMPOSE up -d
    sleep 10
    samples="$(pwd)/resources/test-remote/cli/data/samples.zip"
    mkdir -p $(dirname $samples)
    rm -f $samples
    (
        cd ../../src/main/resources/samples
        zip -r $samples zedai
    )
    $COMPOSE run cli zedai-to-html --i-source zedai/alice.xml --data /data/samples.zip --background
    sleep 15
    rm -f resources/test-remote/cli/data/alice.html.zip
    $COMPOSE run cli results -l --zipped --output /data/alice.html.zip
    $COMPOSE stop
)
