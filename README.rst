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

    docker run --user=`id -u` --publish localhost:6767:6667 docker.io/thekad/znc:latest

A container with persistent config/data::

    docker run --user=`id -u` --publish 6667:6667 --volume /var/lib/znc:/data:rw docker.io/thekad/znc:latest

ZNC by default refuses to start as root, so you need to pass ``--user=foo`` to
your docker run call *or* do something like this::

    docker run --publish 6667:6667 docker.io/thekad/latest /entrypoint.sh --allow-root

.. NOTE:: Keep in mind that ZNC will *still* wait 30 seconds before running as root

A container with a provided SSL will bootstrap with SSL support::

    docker run --publish 6697:6667 --volume /path/to/your/znc/pem/files:/ssl docker.io/thekad/znc:latest

Or you can also override that::

    docker run --publish 6697:6667 --env SSL_CRT=/etc/ssl/fullchain.pem --env SSL_KEY=/etc/ssl/privkey.pem --env SSL_DHP=/etc/ssl/dhparam.pem --volume /path/to/your/certs:/etc/ssl docker.io/thekad/znc:latest

You can even install alpine dependency packages for those cases where your plugins need some extra libraries::

    docker run --publish 6667:6667 --env "DEPENDENCIES=curl-dev openssl-dev" docker.io/thekad/znc:latest


Remarks
=======

* Default user and password is ``admin:admin`` CHANGE RIGHT AWAY
* In all cases, if the configuration doesn't exist, a simple configuration will
  be created (refer to znc.conf.default)
* If there are files named ``/ssl/fullchain.pem``  and ``/ssl/privkey.pem``
  (container's path) then SSL support will be bootstrapped on the first run.
  This is highly recommended. If you have your own PEM files then just pass the
  right paths using environment variables ``SSL_{CRT,KEY,DHP}``
* Modules inside ``/data/modules`` (container's path) will be automatically built
  on startup with ``znc-buildmod``

