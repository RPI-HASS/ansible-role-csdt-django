# vim: set ft=dockerfile:

FROM ubuntu:xenial

# Colour output.
ENV TERM=xterm

RUN apt-get update -y \
    && apt-get install -y apt-transport-https software-properties-common \
    && apt-get autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY chef.asc /tmp/chef.asc
COPY chef-stable.list /etc/apt/sources.list.d/chef-stable.list

RUN apt-key add /tmp/chef.asc \
    && apt-add-repository ppa:ansible/ansible \
    && apt-get update -y \
    && apt-get --no-install-recommends install -y \
      ansible \
      git \
      sudo \
      inspec=1.43.5-1 \
      coreutils \
      net-tools \
    && apt-get autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
