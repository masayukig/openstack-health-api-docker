# for API server
# TODO: Someone may want to make this more stable distro.
FROM opensuse:latest

WORKDIR /app
RUN zypper install -y \
    python \
    python-devel \
    python-pip \
    git \
  && pip install virtualenv \
  && zypper install -y -t pattern devel_basis \
  && rm -rf /var/cache/zypp/* \
  && git clone https://github.com/openstack/openstack-health
WORKDIR /app/openstack-health

# ONBUILD COPY . /app
RUN virtualenv /venv \
  && source /venv/bin/activate \
  && /venv/bin/pip install -r /app/openstack-health/requirements.txt \
  && /venv/bin/pip install uwsgi

# FIXME: This should be changeable by users, not a fixed value.
RUN mkdir -p /app/etc
COPY ./etc/openstack-health.conf /app/etc/openstack-health-api.conf
COPY ./etc/uwsgi.ini .
RUN ln -s /app/etc/openstack-health-api.conf /etc/openstack-health.conf
EXPOSE 5000
# FIXME: Need to accept to change config files like for connecting to a DB server
CMD ["/venv/bin/uwsgi", "--ini", "uwsgi.ini"]
