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
