# for API server
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

RUN mkdir -p /app/etc
COPY ./etc/openstack-health.conf /app/etc/openstack-health.conf
COPY ./etc/uwsgi.ini /app/etc/uwsgi.ini
EXPOSE 5000
CMD ["/venv/bin/uwsgi", "--ini", "/app/etc/uwsgi.ini"]
