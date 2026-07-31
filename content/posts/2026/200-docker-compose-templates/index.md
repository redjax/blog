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
TocOpen: false
hidemeta: false
comments: false
searchHidden: false
---

I have been maintaining a git monorepo named [`docker_templates`](https://github.com/redjax/docker_templates) since sometime in 2023, and I recently added my 200th template [(commit `7c112b7`)](https://github.com/redjax/docker_templates/tree/7c112b7222d81330c0310ec851c7b512f48347e6)! I thought back to when I started learning Docker and Docker Compose sometime in 2015, and how transformative containers are in how I use my machines. There is something very satisfying about describing a runtime you want to work with and encapsulating everything you need to run an app or service the same way each time you run it, on any machine. There are some edge cases in reality, but it's a beautiful dream.

The structure of the `docker_templates` repository continues to evolve, but it's also come a long way from how it started out.

## The Beginning: Disparate Directories with Docker Compose files

I learned to write Dockerfiles to containerize my Python programs, and quickly picked up Docker Compose so I could run things like a Postgres database or Redis message queue (for Python's Celery scheduling library). Eventually I started to find programs and apps I wanted to host myself, like a media server, document hosting, monitoring/alerting services, etc.

For years, whenever I wanted to try a new service, I would create a directory for it, write a `docker-compose.yml` file, and run it. I was hardcoding non-secret values in my Compose files for a long time (using a `.env` or environment variables to pass secrets to the template). Sometimes I would initialize a git repository and push the stack to Github, other times the directory would just sit on one of my machines wherever I originally put it. The mental overhead of deciding if the new service I wanted to try was worthy of initializing as a git repository, making sure my `.gitignore` would keep my `.env` file out of git history and ignore host volume mounts, and deciding where to put the code on my machine started to slow me down and made me hesitant to really invest time into the templates I was creating. I started to end up with a lot of different repositories and realized this was not sustainable long-term.

## The Monorepo

At some point in 2023, I decided to start a new git monorepo where I would store all of the services I ran in Docker Compose. I created my [`docker_templates` repository](https://github.com/redjax/docker_templates), and one-by-one started copying Compose files I had written into the repository. Pulling everything into 1 place allowed me to do some cleanup, and made it much easier to start new templates. Whenever I wanted to run a new service, I would clone the repository into a path in my `~/git/` directory, name it after the service, and create the `docker-compose.yml` file alongside all my other templates in a branch named after the service. Each service existed in an immediate child of the `templates/` directory, and over time that path became difficult to sort through.

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
