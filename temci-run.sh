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

set -e ${VERBOSE:+-x}

declare -a cmd

while [[ -n ${1:+defined} ]]; do
  if [[ $1 == \; ]]; then
    shift
    if (( $# == 0 )); then
      # if this was the last command let it be executed by the outer run
      break
    fi
    temci "${cmd[@]}"
    unset cmd[@]
    continue
  fi
  cmd+=( "$1" )
  shift
done
temci "${cmd[@]}"
