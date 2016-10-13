[![docker image](https://img.shields.io/docker/stars/jitakirin/temci.svg)](https://hub.docker.com/r/jitakirin/temci/)

# docker-temci
Docker image containing [temci] - an advanced benchmarking tool written
in python3.

# usage
The entrypoint will run [temci], so you can run:

    docker run -it --rm --volume=$PWD:/src jitakirin/temci --help
    docker run -it --rm --volume=$PWD:/src jitakirin/temci \
      short exec -wd 'ls -lt /usr/bin/' --runs 10 --out ls_test.yaml

you can also run multiple [temci] commands in batch by separating them
with a ';' (make sure to escape it):

    docker run -it --rm --volume=$PWD:/src jitakirin/temci \
      short exec -wd 'ls -lt /usr/bin/' --runs 10 --out ls_test.yaml \; \
      report --reporter console ls_test.yaml

If you need to prepare your source (build, install, etc.) pass a script
via SETUP env variable:

    docker run -it --rm --volume=$PWD:/src jitakirin/temci \
      --env=SETUP='pip install -e .' \
      short exec -wd 'python -c "print(__name__)"' --runs 10 --out py_test.yaml

## Serving reports
There is also a shortcut for serving generated HTML reports using
python's built-in HTTP server.  This is purely for convenience of
quickly running a test and viewing results.

Enable by passing SERVE_REPORT env variable.  It can be set to path to
the YAML file containing results, in which case a HTML report will be
produced with default options and then served over HTTP:

    docker run -it --rm --volume=$PWD:/src jitakirin/temci \
      --env=SERVE_REPORT=ls_test.yaml
      short exec -wd 'ls -lt /usr/bin/' --runs 10 --out ls_test.yaml

Or if you want more control over how the report is generated, you can
set it to a path to a directory and generate the report into that
directory directly:

    docker run -it --rm --volume=$PWD:/src jitakirin/temci \
      --env=SERVE_REPORT=/tmp/ls_test
      short exec -wd 'ls -lt /usr/bin/' --runs 10 --out ls_test.yaml \; \
      report --html2_out /tmp/ls_test ls_test.yaml

These two examples are equivalent.

# tests
run tests with:

    docker run -it --rm --volume=$PWD:/src --workdir=/src dduportal/bats test

[temci]: http://temci.readthedocs.io/en/latest/
