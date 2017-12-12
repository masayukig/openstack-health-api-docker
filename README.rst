openstack-health-api-docker
===========================

.. image::
    https://img.shields.io/docker/build/masayukig/openstack-health-api.svg
    :target: https://hub.docker.com/r/masayukig/openstack-health-api/builds/
.. image::
    https://img.shields.io/docker/automated/masayukig/openstack-health-api.svg
    :target: https://hub.docker.com/r/masayukig/openstack-health-api/

How to build
------------

You can build this docker image like below::

  $ docker build -t masayukig/openstack-health-api:latest .

Or if you'd like to update the openstack-health code base, you can do it::

  $ docker build --no-cache -t masayukig/openstack-health-api:latest .

How to use
----------

You can specify the listen port like below::

  $ docker run -d -p 5000:5000 --rm masayukig/openstack-health-api
