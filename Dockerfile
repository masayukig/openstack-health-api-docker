# for API server
# TODO: Someone may want to make this more stable distro.
FROM opensuse:tumbleweed

WORKDIR /app
RUN zypper install -y \
    python \
    python-devel \
    python2-pip \
    git \
  && pip install virtualenv \
  && rm -rf /var/cache/zypp/* \
  && zypper install -y -t pattern devel_basis \
  && git clone https://github.com/openstack/openstack-health
WORKDIR /app/openstack-health

# ONBUILD COPY . /app
RUN virtualenv /venv \
  && source /venv/bin/activate \
  && /venv/bin/pip install -r /app/openstack-health/requirements.txt \
  && /venv/bin/pip install uwsgi

# FIXME: This should be changeable by users, not a fixed value.
COPY ./openstack-health.conf /etc/openstack-health.conf
EXPOSE 8080
# FIXME: Need to accept to change config files like for connecting to a DB server
CMD ["/venv/bin/uwsgi", "-s", "/tmp/uwsgi.sock", "--wsgi-file", "openstack_health/api.py", "--callable", "app", "--pyargv", "etc/openstack-health-api.conf", "--http", ":8080"]
