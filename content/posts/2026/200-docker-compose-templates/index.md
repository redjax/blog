---
title: "200 Docker Compose Templates"
date: 2026-07-26T21:18:37-04:00
draft: true
slug: "/200-docker-compose-templates/"
# url: "/posts/200-docker-compose-templates/"
categories: []
tags:
  - docker
  - git
author: "me"
description: ""
showToc: true
TocOpen: true
hidemeta: false
comments: false
searchHidden: false
---

![200 templates](200-compose-templates.png#center)

I have been maintaining a git monorepo named [`docker_templates`](https://github.com/redjax/docker_templates) since sometime in 2023, and I recently added my 200th template [(commit `7c112b7`)](https://github.com/redjax/docker_templates/tree/7c112b7222d81330c0310ec851c7b512f48347e6)! I thought back to 2015, when I started learning Docker and Docker Compose, and how transformative containers have been in the way I use my machines. There is something very satisfying about describing a runtime you want to work with and encapsulating everything you need to run an app or service the same way each time you run it, on any machine. In reality, there are some edge cases, but it's a beautiful dream.

The structure of the `docker_templates` repository continues to evolve, but it's also come a long way from where it started. I use this repository in some way almost every day. It is the heart of my homelab, and is where I keep references for pretty much every service I've stood up on one of my machines. I will now indulge my nostalgia by showing you how the repository has grown over time, how I use it, and share a few of my most useful/favorite containers.

## The Beginning: Disparate Directories with Docker Compose Files

I learned to write Dockerfiles to containerize my Python programs, and quickly picked up Docker Compose so I could run things like a Postgres database or Redis message queue (for Python's Celery scheduling library). Eventually, I started to find programs and apps I wanted to host myself, like a media server, document hosting, monitoring/alerting services, etc.

For years, whenever I wanted to try a new service, I would create a directory for it, write a `docker-compose.yml` file, and run it. I was hardcoding non-secret values in my Compose files for a long time (using a `.env` or environment variables to pass secrets to the template). Sometimes I would initialize a git repository and push the stack to Github, other times the directory would just sit on one of my machines wherever I originally put it. The mental overhead of deciding if the new service I wanted to try was worthy of initializing as a git repository, making sure my `.gitignore` would keep my `.env` file out of git history and ignore host volume mounts, and deciding where to put the code on my machine started to slow me down and made me hesitant to really invest time into the templates I was creating. I ended up with a lot of different repositories and realized this was not sustainable long-term.

## The Monorepo

At some point in 2023, I decided to start a new git monorepo to store all of the services I ran in Docker Compose. I created my [`docker_templates` repository](https://github.com/redjax/docker_templates), and one-by-one started copying Compose files I had written into the repository. Pulling everything into one place allowed me to do some cleanup, and made it much easier to start new templates. Whenever I wanted to run a new service, I would clone the repository into a path in my `~/git/` directory, name it after the service, and create the `docker-compose.yml` file alongside all my other templates in a branch named after the service. Each service existed in an immediate child of the `templates/` directory, and over time that path became difficult to sort through.

This worked great for a while, but as I added more and more containers, and thought about all of the templates I planned to add in the future, I realized the structure of the `templates/` directory would need to change, and the multiplicative git cloning would end up being a storage problem in the long term. I decided to overhaul the organization of templates in the repository, and write scripts to help me manage the complexity and initialize new templates in a standardized way.

### Cookiecutter Templates

When I would start new service templates, I would usually go to a previous template and copy the `docker-compose.yml` and `README.md` files into the new path and rewrite them for the new service. I realized I wanted to standardize the way I initialized new template directories. I was familiar with Jinja2 templating from writing Python programs, and had used [Cookiecutter](https://github.com/cookiecutter/cookiecutter) in the past to create templated Python project repositories. So I created a [standardized Docker Compose service template directory](https://github.com/redjax/docker_templates/tree/main/templates/_cookiecutter/docker-template), with a common starting point for all future templates, and a [Python script](https://github.com/redjax/docker_templates/blob/main/scripts/new_template.py) to guide the user through initializing a new template. I am definitely yada-yada-ing a lot of steps I took to get to this point, but after a few iterations, I settled on the template I have been using for the majority of the time this repository has existed.

Each new repository created from the Cookiecutter template starts with the same files:

- `.docker-compose.template`: An empty marker file for some of the maintenance scripts...I'll explain more later.
- `.env.example`: I parameterize my `compose.yml` files, and provide an example `.env` file with the defaults for each service.
  - The user is instructed to copy `.env.example` to `.env` (which is ignored in the `.gitignore` for the whole repository) to configure the running stack.
- `.gitignore`: Template-local ignore pattern overrides.
- `README.md`: The `new_template.py` script prompts the user for a title, summary, and optional description, and populates the README file with the user's inputs.
- `compose.yml`: A Docker Compose template file with the basic shape defined, so I can just start writing service definitions.

### Path markers

Once the template business was all sorted out, I decided to create [subdirectories under the `templates/` path](https://github.com/redjax/docker_templates/tree/main/templates) that would serve as "categories." I put my Postgres, Mariadb, Redis, and InnoDB containers under the `database/` path, my Plex and Jellyfin servers under `media/`, Ntfy and Gotify containers under `notifications/`, and so on. Splitting things up this way made it easier to browse through the containers on the web, and helped to keep the stacks logically sorted by archetype.

In each "category" directory, I created an empty `.category` file marker. I used the `.category` and `.docker-compose.template` files to write scripts that manage some of the complexity in the repository. For example, the [`count_templates.py` script](https://github.com/redjax/docker_templates/blob/main/scripts/count_templates.py) finds all of the `.docker-compose.template` files in the repository and returns a count, which I use to update the templates count in the [repository's README.md](https://github.com/redjax/docker_templates/blob/main/README.md). I wrote a [Github workflow](https://github.com/redjax/docker_templates/blob/main/.github/workflows/update-templates-count.yml) to run the script on a schedule, and if the count is different from what's in the README.md, it updates the `Templates:\s*\d+` pattern with the new count.

### Repository Map

I also created a [repository "map"](https://github.com/redjax/docker_templates/tree/main/map), a README.md file that finds all of the `.category` markers and creates a file tree from [a README.md Jinja template](https://github.com/redjax/docker_templates/blob/main/map/_template/README.md.j2), and a [script to update the map README when new categories are created](https://github.com/redjax/docker_templates/blob/main/scripts/update_repo_map.py). The [`update-repo-map.yml` Github workflow](https://github.com/redjax/docker_templates/blob/main/.github/workflows/update-repo-map.yml) also runs nightly to keep this file updated with the latest templates.

### Repository Metadata

The scripts that update my README files also write data to the [`metadata/` directory](https://github.com/redjax/docker_templates/tree/main/metadata). This can act as a sort of read-only API using cURL requests. For example, the repository map uses the [`categories.json` file](https://github.com/redjax/docker_templates/blob/main/metadata/categories.json) to populate the tree, and all `.category` and `.docker-compose.template` markers are in [`beacons.json`](https://github.com/redjax/docker_templates/blob/main/metadata/beacons.json). I started calling the marker files "beacons" at one point, and it just kind of stuck.

The metadata files are only really used for rendering README templates, but I have plans for things like a frontend webUI to explore the repository's templates, and a Go CLI or downloading and using individual templates.

## Git Sparse Checkouts

I mentioned earlier that I was cloning the whole repository each time I wanted to run a template I had in `docker_templates`. This quickly became a problem as the size of the repository grew. The repository is currently 10MB in size (mostly due to image files and some larger files in history I'll clean up at some point), so each time I cloned the repository, I added 10MB of disk usage.

I discovered [git sparse checkouts](https://git-scm.com/docs/git-sparse-checkout) when I searched for a solution to this problem. A sparse checkout is a git operation that allows you to checkout only a subset of the files in a repository. When I'm running a Docker Compose template, I don't need to pull the `src/img` directory, with the `.png` I render on the main README.md, and I can pull just the files in the Compose template I wish to run.

In practice, most of my sparse checkouts are ~5% of the total size of the repository, which is about the same amount of size they would take as separate git repositories. It adds a few steps to the initial checkout process, but it makes the clone a focused copy with only as much as I need to run.

As an example, if I want to run a [Zabbix server container](https://github.com/redjax/docker_templates/tree/main/templates/monitoring_alerting/docker_zabbix), I would run the following commands:

```shell
$> git clone --no-checkout https://github.com/redjax/docker_templates docker_zabbix
$> cd docker_zabbix
## Initialize sparse checkout
$> git sparse-checkout init --cone
## Tell git which paths to checkout
$> git sparse-checkout set templates/monitoring_alerting/docker_zabbix
## Checkout the main branch, or a working branch for the zabbix server
$> git checkout feat/some-zabbix-feature
```

This would create a directory named `docker_zabbix/`, which would have all of the files in the root path, and a single directory named `templates/`, with `monitoring_alerting/docker_zabbix`. All of the other containers still exist in the remote, but sparse checkouts let me focus on a single template.

[git worktrees](https://git-scm.com/docs/git-worktree) were not a thing when I started using sparse checkouts. An alternative to the sparse checkout method described above is cloning the whole `docker_templates` repository once, then creating worktrees for all of the services you want to run. A worktree exists in a separate path on the machine like a sparse clone would. Worktrees share the same git object database, meaning paths and objects are deduplicated, saving space on the disk.

To create a Zabbix server container using a worktree, you would clone the whole repository once, `cd` into it, then create worktrees for each service you want to run. The limitation here is that each worktree checks out a branch, and only that worktree can use that branch. So, the original repository clone stays on the `main` branch, and each worktree must have its own branch, even if I'm not making any changes on that service.

```shell
$> git clone https://github.com/redjax/docker_templates
$> cd docker_templates
$> git worktree add -b feat/zabbix-server ../docker_zabbix
$> cd ../docker_zabbix
```

I have continued to use sparse checkouts because I often checkout a service and just run it on the `main` branch until I have updates or fixes to apply, and this flow does not work with worktrees.

## How I use it

I have a "whole" clone of this repository on a few of my machines, just a regular clone of the repository that I don't touch after cloning, except to create new templates. When I want to try a new service, I `cd` into the local clone, create a branch for the new service, and run the `new_template.py` script, which prompts me for a template name, category, summary, and optional description. I usually add a link of some sort in the summary, i.e. a Github repository or documentation URL.

I commit the files as the initial starting point for that repository and push the branch up to git. Then I do a sparse clone and checkout the new service's branch, and I get to work building the `compose.yml` and `.env.example`. I usually create host volume mounts in the git path, although a better practice would be storing Docker files in another path, like `/opt/docker_data` or something. The things we wished we learned sooner...

Eventually, when the template is in working condition, I merge the branch into `main`. As I make changes to the template, I create `feat/` and `fix/` branches, which also get merged into main. The idea/goal is to be running my services off the stable `main` branch as often as possible.

### Favorite containers

With some containers, I get them into working order, then bring the stack down and forget about it. I still like having the reference file in my repository, but I might not actively run the container. If it's in the `main` branch, it means I got it running at one point and it's ready to run again.

But there are some templates I am constantly running, or re-using on different machines.

- [`docker_pangolin`](https://github.com/redjax/docker_templates/tree/main/templates/networking/docker_pangolin): One of the most important services in my stack! [Pangolin](https://github.com/fosrl/pangolin) is my reverse HTTP proxy.
  - I have Pangolin running on a VPS I rent.
  - I route my domain name through Cloudflare, and have Cloudflare pointed at the VPS.
  - In Pangolin, I create subdomain routes to services I want to expose to the Internet, and route the traffic over a private tunnel.
- [`docker_adguard`](https://github.com/redjax/docker_templates/tree/main/templates/networking/docker_adguard): I run an [AdGuard Home container](https://github.com/redjax/docker_templates/tree/main/templates/networking/docker_adguard) for ad blocking on my entire LAN.
  - My router uses the AdGuard container as its DNS server.
  - I create records for my important machines, so I can resolve `machine-name.home` anywhere on my network instead of remembering IP addresses.
- [`docker_netbird`](https://github.com/redjax/docker_templates/tree/main/templates/networking/docker_netbird): I use [Netbird](https://netbird.io/) to run a private network, similar to how many people use [Tailscale](https://tailscale.com/).
  - I use access policies to allow or restrict traffic between devices, and to give my friends limited access to things like my media and game servers.
- [`docker_paperless-ngx`](https://github.com/redjax/docker_templates/tree/main/templates/documents/docker_paperless-ngx): [Paperless-ngx](https://docs.paperless-ngx.com/) is an incredibly useful document management system.
  - I upload my receipts, work documents for things like benefits packages and employee handbooks, PDFs, and airline tickets.
  - Daily backups to local and offsite storage prevent data loss (and I've had to recover a few times, don't neglect your backups!).
  - Full-text search lets me find things quickly, and the tagging system lets me sort documents, with tags like `receipt`, `pets`, `house`, `vehicle`, etc.
- [`docker_concourse_ci`](https://github.com/redjax/docker_templates/tree/main/templates/automation/docker_concourse_ci): I use [Concourse CI](https://concourse-ci.org/) for some of my homelab automation pipelines.
- [`docker_semaphore`](https://github.com/redjax/docker_templates/tree/main/templates/automation/docker_semaphore): [Semaphore](https://semaphoreui.com/) lets me run my [Ansible roles](https://gitlab.com/redjax/ansible-roles) and [playbooks](https://gitlab.com/redjax/ansible-playbooks), as well as scheduled Bash scripts and [Terraform](https://github.com/redjax/Terraform) from a convenient webUI.
- [`docker_gickup`](https://github.com/redjax/docker_templates/tree/main/templates/backup/docker_gickup): [Gickup](https://github.com/cooperspencer/gickup) is a useful utility for backing up and mirroring git repositories.
  - I keep a config file with all of my most important/valuable repositories, and Gickup runs on a raspberry pi, pulling my changes to a local drive and mirroring some to a self-hosted Git instance.
- [`database`](https://github.com/redjax/docker_templates/tree/main/templates/database): A collection of database templates.
  - I frequently use [Postgres](https://github.com/redjax/docker_templates/tree/main/templates/database/docker_postgresql) and [Redis](https://github.com/redjax/docker_templates/tree/main/templates/database/docker_redis) in my homelab, and I use [InfluxDB](https://github.com/redjax/docker_templates/tree/main/templates/database/docker_influxdb) for some of my time-series data like weather readings.
- [`docker_linkwarden`](https://github.com/redjax/docker_templates/tree/main/templates/bookmarking/docker_linkwarden): [Linkwarden](https://linkwarden.app/) is a bookmarking/read-it-later app.
  - I imported all of my browser bookmarks, and I frequently save new links I come across on the web.
  - I can export Linkwarden's saved links as a `bookmarks.html` file to synchronize back to my browser.
- [`docker_forgejo`](https://github.com/redjax/docker_templates/tree/main/templates/code_forges/docker_forgejo): [Forgejo](https://forgejo.org/) is a self-hosted Git forge, reminiscient of 2015-2018 Github.
  - The Forgejo Actions platform is semi-compatible with Github actions, and Forgejo's pipelines are very similar in syntax.
  - I host a private/local-only Git forge for some of my more sensitive repositories that I do not want to expose to the Internet.
- [`docker_opengist`](https://github.com/redjax/docker_templates/tree/main/templates/code_forges/docker_opengist): I am a big fan of Github Gists, and discovered [OpenGist](https://opengist.io/), which is basically the self-hosted version.
  - I put a lot of code snippets, scripts, and reference files here, and occasionally I will expand a gist into an Obsidian note or a post on this blog!
- [`dav`](https://github.com/redjax/docker_templates/tree/main/templates/dav): I self-host my contacts and calendars, and synchronize them with my email client.
  - I primarily use [Radicale](https://github.com/redjax/docker_templates/tree/main/templates/dav/docker_radicale), but have recently been test driving [Davis](https://github.com/redjax/docker_templates/tree/main/templates/dav/docker_davis) and liking it a lot.
- [`games`](https://github.com/redjax/docker_templates/tree/main/templates/games): I host a bunch of game servers for my friends and I. We connect over a private network I host to play.
- [`monitoring_alerting`](https://github.com/redjax/docker_templates/tree/main/templates/monitoring_alerting): I have tried many different monitoring/alerting solutions, and have kept a template for each one in this path.
  - I used [Zabbix](https://github.com/redjax/docker_templates/tree/main/templates/monitoring_alerting/docker_zabbix) for a while, but more recently I have used [Beszel](https://github.com/redjax/docker_templates/tree/main/templates/monitoring_alerting/docker_beszel) for server metric monitoring, [Uptime Kuma](https://github.com/redjax/docker_templates/tree/main/templates/monitoring_alerting/docker_uptime-kuma) for uptime checks, [happyDomain](https://github.com/redjax/docker_templates/tree/main/templates/monitoring_alerting/docker_happydomain) to track and monitor my domains and DNS records, and [NtopNG](https://github.com/redjax/docker_templates/tree/main/templates/monitoring_alerting/docker_ntopng) for local network monitoring.
  - I run Uptime Kuma from a VPS so it can watch my homelab for outages.
- [`docker_ntfy`](https://github.com/redjax/docker_templates/tree/main/templates/notifications/docker_ntfy)/[`docker_gotify`](https://github.com/redjax/docker_templates/tree/main/templates/notifications/docker_gotify): My own self-hosted push notification servers.
  - Ntfy and Gotify work very similarly, and I have been test driving both for a while.
  - I can't decide which one I prefer and I don't see much harm in using both.
  - I've recently added [Apprise](https://github.com/redjax/docker_templates/tree/main/templates/notifications/docker_apprise) into the mix, which lets me send notifications to both services.
