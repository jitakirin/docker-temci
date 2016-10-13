#!/usr/bin/env bats
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

load "${BATS_TEST_DIRNAME}/common.bash"

dkr_init="${BATS_TEST_DIRNAME}/../docker-init.sh"

@test "it runs temci" {
  run "${dkr_init}" subcmd
  (( status == 0 ))
  [[ ${output} == 'temci:argv[1]="subcmd"' ]]
}

@test "it runs SETUP script if defined" {
  SETUP="echo setup" run "${dkr_init}" subcmd
  (( status == 0 ))
  [[ ${lines[0]} == setup ]]
  [[ ${lines[1]} == 'temci:argv[1]="subcmd"' ]]
  (( ${#lines[@]} == 2 ))
}

@test "it does't run temci when SETUP fails" {
  SETUP=false run "${dkr_init}" subcmd
  (( status == 1 ))
  [[ ${output} == "" ]]
}

@test "it produces report and runs a HTTP server when SERVE_REPORT specifies a result (YAML) file" {
  SERVE_REPORT=foo_test.yaml run "${dkr_init}" short exec -wd ls --out foo_test.yaml

  (( status == 0 ))
  [[ ${lines[0]} == 'temci:argv[1]="short"' ]]
  [[ ${lines[1]} == 'temci:argv[2]="exec"' ]]
  [[ ${lines[2]} == 'temci:argv[3]="-wd"' ]]
  [[ ${lines[3]} == 'temci:argv[4]="ls"' ]]
  [[ ${lines[4]} == 'temci:argv[5]="--out"' ]]
  [[ ${lines[5]} == 'temci:argv[6]="foo_test.yaml"' ]]

  [[ ${lines[6]} == 'temci:argv[1]="report"' ]]
  [[ ${lines[7]} == 'temci:argv[2]="--html2_force_override"' ]]
  [[ ${lines[8]} == 'temci:argv[3]="--html2_out"' ]]
  [[ ${lines[10]} == 'temci:argv[5]="foo_test.yaml"' ]]

  [[ ${lines[11]} == 'Serving HTTP on'* ]]
}

@test "it runs a HTTP server when SERVE_REPORT specifies a directory name" {
  SERVE_REPORT="${BATS_TMPDIR}" run "${dkr_init}" report --html2_out "${BATS_TMPDIR}"

  (( status == 0 ))
  [[ ${lines[0]} == 'temci:argv[1]="report"' ]]
  [[ ${lines[1]} == 'temci:argv[2]="--html2_out"' ]]

  [[ ${lines[3]} == 'Serving HTTP on'* ]]

  [[ -f ${BATS_TMPDIR}/index.html || -L ${BATS_TMPDIR}/index.html ]]
}
