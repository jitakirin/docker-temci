# docker-temci
advanced benchmarking tool written in python3

# usage
The entrypoint will run temci, so you can run:

    docker run -it --rm --volume=$PWD:/src jitakirin/temci --help
    docker run -it --rm --volume=$PWD:/src jitakirin/temci short exec -wd 'ls -lt /usr/bin/' --runs 10 --out ls_test.yaml

you can also run multiple temci commands in batch by separating them
with a ';' (make sure to escape it):

    docker run -it --rm --volume=$PWD:/src jitakirin/temci \
      short exec -wd 'ls -lt /usr/bin/' --runs 10 --out ls_test.yaml \;
      report --reporter console ls_test.yaml

If you need to prepare your source (build, install, etc.) pass a script
via SETUP env variable:

    docker run -it --rm --volume=$PWD:/src jitakirin/temci \
      --env=SETUP='pip install -e .' \
      short exec -wd 'python -c "print(__name__)"' --runs 10 --out py_test.yaml

# tests
run tests with:

    docker run -it --rm --volume=$PWD:/src --workdir=/src dduportal/bats test
