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

## < CONTENT >

![Forgejo banner](./forgejo-banner-squirrel.png#center)

I have self-hosted a few Git forges over the last 5 or 6 years, including [Gitlab CE](https://about.gitlab.com/gitlab-community-edition/), [OneDev](https://onedev.io/), [Gitea](https://about.gitea.com/), and [Forgejo](https://forgejo.org/). I briefly tested [Soft Serve](https://github.com/charmbracelet/soft-serve), a novel, pared-down Git server with no GUI, operated entirely through a pleasant terminal UI (TUI).

I spent the most time with Gitlab and Forgejo, but over time I always end up drifting back entirely to Forgejo. It's lightweight, stays out of the way, but has all of the features I need in a forge. The UI is unassuming, maybe even a little "old" looking, but it's a reliable workhorse with all of the essentials, including a package registry for releases, a container image registry, CI/CD pipelines called Forgejo Actions that are [familiar, if not totally compatible with Github Actions](https://forgejo.org/docs/latest/user/actions/github-actions/).

I hosted Forgejo on a machine in my house over the last year, accessible only from my LAN and Netbird VPN. This worked well, but I had to navigate to `http://100.115.201.81:3000/` to see the UI, Actions were difficult (because they like domain names, not IP addresses), I was unable to make certain connections work like [Komodo](https://komo.do) hooks, and my SSH clone commands were ugly from the long IP address. If I wanted to show a friend or colleague a repository, I basically had to call them on Discord and share my screen, because without adding them to my Netbird network, there was no way to access the forge externally. That was originally a security/design decision, I only intended on using it for internal things like some scripts and configurations, maybe some light CI/CD automations.

I did some research and while Forgejo does not publish any official system requirement specifications, the consensus online is that you should have a minimum of 2GB RAM, 1 vCPU, and a 10GB drive, preferably SSD. These minimums are assuming you're [using SQLite as Forgejo's database](https://forgejo.org/docs/latest/admin/installation/database-preparation/#sqlite). Most sources recommend 4GB RAM, 2 vCPU, and a 60GB+ SSD if you can spare it. My preferred provider for cheap VPSs is [Netcup](https://www.netcup.com/en), they have a [vServer Lite offering](https://www.netcup.com/en/server/vps-lite) with very reasonably priced server SKUs. I opted for a VPS Lite 1 G12.5s, which has 2 vCPU (x86), 4GB RAM, and an 80GB SSD with no traffic caps. As of November 2026, my VPS costs ~$5.40 per month.

I use [Ansible](https://github.com/redjax/Ansible) to manage my servers, so within minutes of getting access to the new server, I had configured the host with my user account, SSH keys, firewall (disallow all, explicitly allowing only a few ports), and Fail2Ban jails. I have playbooks to install Docker and some other CLI utilities, too. All I really had to do was copy my SSH to Github and clone my [`docker_templates` repository](https://github.com/redjax/docker_templates), which has [my Forgejo template for Docker Compose](https://github.com/redjax/docker_templates/tree/main/templates/code_forges/docker_forgejo).

> [!NOTE]
> Write about setting Forgejo up, config decisions I made, and show a snippet of the `compose.yml`.

I already owned a domain that I had previously exposed Gitlab behind before deciding it was too much of a resource hog. It was still pointed at Cloudflare, but I wanted Git SSH cloning to work and Cloudflare does not support SSH traffic without using a Cloudflare Tunnel. I have my own tunnels with self-hosted [Pangolin](https://github.com/redjax/docker_templates/tree/main/templates/networking/docker_pangolin), so I decided to revert the domain's nameservers to Porkbun, and pointed them at the Netcup VPS instead.

> [!NOTE]
> Write about domain setup and using Caddy to proxy requests. Show snippets of the `compose.yml` and `Caddy`.
>
> Also describe adding [Anubis](https://anubis.techaro.lol/) to protect the site, OpenGist, and the backup container.
