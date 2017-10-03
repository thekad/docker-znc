ZNC Bouncer
-----------

Just a simple `ZNC <https://znc.in>_` bouncer with optional support for SSL.
Heavily based on <https://github.com/jimeh/docker-znc> just wanted a smaller
image


Running
=======

An ephemeral container listening on standard port 6667::

    docker run --user=`id -u` --publish localhost:6667:6667 docker.io/thekad/znc:latest

An ephemeral container listening on a different port::

    docker run --user=`id -u` --publish localhost:6767:6767 docker.io/thekad/znc:latest

A container with persistent config/data::

    docker run --user=`id -u` --publish 6667:6667 --volume /var/lib/znc:/data:rw docker.io/thekad/znc:latest

ZNC by default refuses to start as root, so you need to pass ``--user=foo`` to
your docker run call *or* do something like this::

    docker run --publish 6667:6667 docker.io/thekad/latest /entrypoint.sh --allow-root

.. NOTE:: Keep in mind that ZNC will *still* wait 30 seconds before running as root

Remarks
=======

* Default user and password is ``admin:admin`` CHANGE RIGHT AWAY
* In all cases, if the configuration doesn't exist, a simple configuration will
  be created (refer to znc.conf.default)
* If there is a file named ``/data/ssl/znc.pem`` (container's path) then SSL support
  will be bootstrapped on the first run. This is highly recommended. If you have
  your own PEM file then just name it ``znc.pem`` and put it in the data volume
* Modules inside ``/data/modules`` (container's path) will be automatically built
  on startup with ``znc-buildmod``

