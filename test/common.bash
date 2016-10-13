#!/bin/bash
# docker-temci
# Copyright (C) 2016  jitakirin
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

mock_dir="${BATS_TEST_DIRNAME}/mock"
src_dir="${BATS_TEST_DIRNAME%/*}"  # parent dir

path_add() { # DIR
  if [[ ${PATH} == *${1}:* ]]; then
    return 0
  fi
  export PATH="${1}${PATH:+:$PATH}"
}

path_rm() { # DIR
  if [[ ${PATH} != *${1}:* ]]; then
    return 0
  fi
  export PATH="${PATH/${1}:/}"
}

setup() {
  path_add "${src_dir}"
  path_add "${mock_dir}"
}

teardown() {
  path_rm "${mock_dir}"
  path_rm "${src_dir}"

  {
    #echo "status: ${status}"  # status seems to be reset here
    echo "output: '${output}'"
    echo "lines=("
    printf '  "%s"\n' "${lines[@]}"
    echo ")"
  } >&2
}
