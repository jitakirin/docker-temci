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

temci_run="${BATS_TEST_DIRNAME}/../temci-run.sh"
mock_dir="${BATS_TEST_DIRNAME}/mock"

setup() {
  if [[ ${PATH} == *${mock_dir}:* ]]; then
    return 0
  fi
  export PATH="${mock_dir}:${PATH}"
}

teardown() {
  if [[ ${PATH} == *${mock_dir}:* ]]; then
    export PATH="${PATH/${mock_dir}:/}"
  fi

  {
    #echo "status: ${status}"  # status seems to be reset here
    echo "output: '${output}'"
    echo "lines=("
    printf '  "%s"\n' "${lines[@]}"
    echo ")"
  } >&2
}

@test "no arguments passed to temci which prints usage instructions" {
  run "${temci_run}"
  (( status == 0 ))
  [[ ${lines[0]} == Usage:* ]]
}

@test "passes single subcommand and options to temci" {
  run "${temci_run}" subcmd --sopt1 sarg1 --sopt2 'opt2 val'
  (( status == 0 ))
  [[ ${lines[0]} == 'temci:argv[1]="subcmd"' ]]
  [[ ${lines[1]} == 'temci:argv[2]="--sopt1"' ]]
  [[ ${lines[2]} == 'temci:argv[3]="sarg1"' ]]
  [[ ${lines[3]} == 'temci:argv[4]="--sopt2"' ]]
  [[ ${lines[4]} == 'temci:argv[5]="opt2 val"' ]]
  (( ${#lines[@]} == 5 ))  # runs only the single command, no other output
}

@test "passes multiple subcommands to temci in order" {
  run "${temci_run}" msubcmd1 m1a1 \; msubcmd2 m2a1 m2a2
  (( status == 0 ))
  [[ ${lines[0]} == 'temci:argv[1]="msubcmd1"' ]]
  [[ ${lines[1]} == 'temci:argv[2]="m1a1"' ]]
  [[ ${lines[2]} == 'temci:argv[1]="msubcmd2"' ]]
  [[ ${lines[3]} == 'temci:argv[2]="m2a1"' ]]
  [[ ${lines[4]} == 'temci:argv[3]="m2a2"' ]]
  (( ${#lines[@]} == 5 ))
}

@test "succeeds if semicolon terminates the last command" {
  run "${temci_run}" single_sub \;
  (( status == 0 ))
  [[ ${output} == 'temci:argv[1]="single_sub"' ]]
  (( ${#lines[@]} == 1 ))
}

@test "a lone semicolon is same as no command" {
  run "${temci_run}" \;
  (( status == 0 ))
  [[ ${lines[0]} == Usage:* ]]
}
