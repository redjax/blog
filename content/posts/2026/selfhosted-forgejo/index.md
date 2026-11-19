---
title: "Selfhosted Forgejo"
date: 2026-11-17T23:54:38-05:00
draft: true
slug: "/selfhosted-forgejo/"
# url: "/posts/selfhosted-forgejo/"
categories: []
tags:
  - git
  - selfhosting
  - forgejo
author: "me"
description: ""
showToc: false
TocOpen: false
hidemeta: false
comments: false
searchHidden: false
---

## Outline

- Intro
  - Recently set up Forgejo on a Netcup VPS
  - Ran Forgejo locally/internally on my LAN for a while, but wanted to expose it behind a domain
- Setup
  - Size & purchase VPS
    - Forgejo doesn't list official system specifications, but sources around the Internet suggest the minimum system requirements for Forgejo are 2GB RAM, 1 vCPU, and at least 10GB of disk space for the app and some repositories.
    - Recommended minimum is 4GB RAM, 2 vCPU, and 60GB disk space.
    - Went with a VPS Lite 1 G12.5s from [Netcup](https://www.netcup.com/en/server/vps-lite).
      - €4.92/mo (~$5.40/mo USD).
      - 4GB RAM, 2 vCPUs, 80GB SSD.
  - Had enough power left over to host [OpenGist](https://opengist.io/) at `gist.domain.com`.
  - Add Authentik SSO.
    - Link Authentik account to Forgejo user.
- Hurdles
  - Moving repos.
    - Had to use commands to [export from old Forgejo and import to new](https://github.com/redjax/docker_templates/tree/main/templates/code_forges/docker_forgejo#migrate-forgejo-repository-to-new-forgejo)
- Backups
  - `offen/docker-volume-backups` to Wasabi
  - `rclone` copy to local drives
  - Git mirror sync script
