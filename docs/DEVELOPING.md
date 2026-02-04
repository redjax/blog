# Development Documentation

> [!WARNING]
> This documentation is most likely incomplete. If I ever feel like this site is "well documented," I'll remove this message.

## Creating new content pages

Content served on the site is stored in the [`content/' directory](../content). While you can manually create directories (pages) and Markdown files (pages), it's easier to use Hugo for this:

```shell
hugo new <folder-name>/<file-name>.md
```

For example, to create a new [post](../content/posts) named `example.md`:

```shell
hugo new post/example.md
```

### Archetypes

Using [archetypes](../archetypes/), you can pre-define front matter and default content for pages created with `hugo new`. For example, the [`notes.md` archetype](../archetypes/notes.md) defines the default frontmatter for new posts created with `hugo new posts/post-name.md`.

Archetypes allow for templating to create dynamic frontmatter. For example, you can automatically generate a title from the page name using `replace`:

```markdown
title: "{{ replace .Name "-" " " | title }}"
```

Automatically insert the creation date:

```markdown
date: {{ .Date }}
```

Or use conditionals to dynamically set the default tags, categories, description, etc:

```markdown
{{ if hasPrefix .Dir "notes/snippets" }}
categories: []
description: "Code snippet or command reference"
tags: ["snippet"]
{{ else }}
categories: []
description: ""
tags: ["note"]
{{ end }}
```

## Serving the site for development

Serve on `localhost:1313`:

```shell
hugo server -D
```

Serve on `0.0.0.0:1313`:

```shell
hugo server -D --bind 0.0.0.0
```

Serve on `0.0.0.0:8000`:

```shell
hugo server -D --bind 0.0.0.0 -p 8000
```

## Building the site

Simply running `hugo` builds the site in a `public/` directory at the repository root. You can add additional flags to control the way Hugo builds/runs.

| Flag                    | Description                                       |
| ----------------------- | ------------------------------------------------- |
| `--minify`              | Optimize code files for a production environment. |
| `--gc`                  | Do garbage collection/cleanup unused files.       |
| `-D`                    | Include drafts.                                   |
| `--cleanDestinationDir` | Do a fresh build by removing old files.           |

A good command to run in a production/live environment is:

```shell
hugo --minify --gc --cleanDestinationDir
```

## Using bundles

[Hugo page bundles](https://gohugo.io/content-management/page-bundles/#article) allow you to organize posts, especially those with media content like images. Creating a bundle is as simple as putting an `index.md` or `_index.md` inside of a subdirectory in [`content/posts/`](../content/posts/).

For example, say you were creating a post named `my-experience-with.md`, but you have a lot of images you want to embed. Instead of creating a "flat" Markdown file at the root of `content/posts/`, you can create a subdirectory with the same name, `content/posts/my-experience-with/` and put an `index.md` file in it. Then you can put images in the same directory and use `./img.ext` in your Markdown file to embed it.

There are 2 types of bundles: "leaf" and "branch."

- A leaf bundle is a directory that contains an `index.md` file and zero or more resources.
  - Analogous to a physical leaf, a leaf bundle is at the end of a branch.
  - It has no descendants.
- A branch bundle is a directory that contains an `_index.md` file and zero or more resources.
  - Analogous to a physical branch, a branch bundle may have descendants including leaf bundles and other branch bundles.
  - Top-level directories with or without `_index.md` files are also branch bundles.
  - This includes the home page.

You can also use page bundles to group multiple posts that are related, i.e. in a series. First, create a page bundle:

```text
content/series-bundle-name/index.md
```

In the `index.md`'s frontmatter, add a `series: ["series-name"]` tag. Add more posts in the series by creating additional Markdown files in the same directory, i.e.:

```text
content/series-bundle-name/post-1.md
content/series-bundle-name/post-2.md

...
```

In each of these, make sure to add the `series: ["series-name"]` line. You can also add a `slug: ""` to control the URL. For example in `post-1.md`:

```markdown
---
title: "Post 1"
series: ["series-name"]
slug: "/posts/series-name/post-1
---
```

In the site's `hugo.yml`, make sure to add a `taxonomies` key:

```yaml
baseUrl: https://example.org
title: "Blog Title"

taxonomies:
  tag: tags
  category: categories
  series: series # Enable series taxonomy for the blog
```

Now you can navigate to `/series/` to see the series you've written, or `/series/series-name/` to navigate to a specific series.

In the site's `hugo.yml`, you can optionally add a `/series/` page to your navigation:

```yaml
menu:
  main:
    - identifier: posts
      name: posts
      url: /posts/
      weight: 10
    - identifier: series
      name: series
      url: /series/
      weight: 20
    - identifier: tags
      name: tags
      url: /tags/
      weight: 30
```
