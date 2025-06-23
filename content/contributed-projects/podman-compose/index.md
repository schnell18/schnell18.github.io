---
title: podman-compose
date: 2025-04-15
external_link: https://github.com/containers/podman-compose/pull/1184
tags:
  - container
  - podman-compose
  - podman
  - python
  - docker
---

This is a highly appreciated PR by the project maintainer that solves multiple podman-compose hang issues as reported by #1176, #1178, and #1183 by employing a create-and-start approach. It also improves robustness on edge-case when the `--force-recreate` switch is on while no containers are running.

<!--more-->
