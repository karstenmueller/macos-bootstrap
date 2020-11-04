#!/usr/bin/env bash

set -e
set -o pipefail
set -o nounset

shellcheck --shell bash modules/* run.sh
