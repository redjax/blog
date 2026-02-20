---
title: "Blog Setup: Challenges"
slug: "/blog-setup/challenges"
date: 2026-02-07T00:00:03-05:00
draft: true
series: ["blog-setup"]
summary: ""
categories: []
tags: ["post", "setup", "hugo"]
author: "me"
description: ""
showToc: true
TocOpen: false
hidemeta: false
comments: false
searchHidden: false
---

*This post is part of a series: [Blog Setup](/series/blog-setup).*

I also faced some difficulties getting started with the blog. I spent way too much time creating the Github Action that deploys my content to Netlify. I failed so many times before getting it right, I exceeded Netlify's free tier 🤡. Most of the difficulty actually came from the "extra" functionality with Lychee link checking and Vale linting. Although I was able to get both of these tools running well locally on my machine, I ran into challenges getting them to run in the pipeline.

Linting with Vale was very difficult to nail down. I was able to get it to work reliabily in the local repository, but struggled with containerizing it and running in a pipeline. I also had invalid syntax in my Lychee link scanning for a while. I resolved both issues, but definitely got caught up in the weeds and did not write any new blog posts in the meantime.

I reposted [one of my old blogs from Medium](/posts/linux-frustrated-lovingI don't), and realized Hugo doesn't have a great way of centering images. You can use [Hugo shortcodes](https://gohugo.io/content-management/shortcodes/), but those are specific to/dependent on Hugo, and in the interest of keeping the content as decoupled from the site generator as possible, I did not want to invest too heavily in shortcodes. I found [a really helpful blog post on ebaddf.net](http://www.ebadf.net/2016/10/19/centering-images-in-hugo/) that had a simple, elegant fix that should work across site generators.

It involves creating a custom CSS file, i.e. at `static/css/custom.css`:

```css
img[src$='#center']
{
    display: block;
    margin: 0.7rem auto; /* you can replace the vertical '0.7rem' by
                            whatever floats your boat, but keep the
                            horizontal 'auto' for this to work */
    /* whatever else styles you fancy here */
}

img[src$='#floatleft']
{
    float:left;
    margin: 0.7rem;      /* this margin is totally up to you */
    /* whatever else styles you fancy here */
}

img[src$='#floatright']
{
    float:right;
    margin: 0.7rem;      /* this margin is totally up to you */
    /* whatever else styles you fancy here */
}
```

And embedding images using that class:

```markdown
![your_img](/img/your_img.png#center)
![your_img](/img/your_img.png#floatleft)
![your_img](/img/your_img.png#floatright)
```

Getting URL slugs to work for content nested in directories by year (i.e. `content/posts/<year>/post-name.md` in the source code) to work proved harder than I expected. I wanted to organize the source code for my blogs by year (both as a way to reduce clutter/page loads in Github, and because it's easier to manage in a code editor), but I wanted the URLs to omit the year (i.e. `/posts/post-name` without the year).

I tried a few different things:

- Using [the `cascade` configuration option](https://gohugo.io/configuration/cascade/#target) to "collapse" URLs
  - This was supposed to move anything in subdirectories under `content/posts/**` up to the root `posts/` path when building the site.
  - It worked, but it also caused `/posts/` to return a `404` error.
- Creating a branch bundle with `content/posts/<year>/_index.md`.
  - This solution also made use of the `cascade` option, but in a more targeted way:

    ```markdown
    ---
    cascade:
    url: "/posts/:slug/"
    ---
    ```

  - I originally used `headless: true`, but this option contributed to my `404` problem, because I use [`/posts`](/posts) to aggregate all of my posts.
- Adding a `slug` to each page.
  - I tried adding `slug: "url-slug-i-want"`. I even added it to my `posts` [archetype](https://gohugo.io/content-management/archetypes/#article)
  - This apparently has no effect on bundles.

I found that using a [`slug`](https://gohugo.io/content-management/urls/#slug) to manually set the URL path works well. For some pages, the [`url`](https://gohugo.io/content-management/urls/#url) option worked better. `slug` is for overriding the last segment of the path, i.e. `/page-name/slug-name`, while `url` gives full control over the URL path, even allowing characters that are reserved by the OS, i.e. adding colons `:` to a URL like `http://example.com/my:example`.

If both `slug` and `url` are set, the `url` parameter takes precedence

For posts, this looks like:

```markdown
# archetypes/posts.md
---
title: "{{ replace .Name "-" " " | title }}"
date: {{ .Date }}
draft: true
slug: "/post-name/optional-sub-post-name"
## Settinng a URL too will override the slug
url: "post-name/optional-sub-post-name"
```

I am sure there will be many other challenges (for instance, I have not tried changing the blog's theme yet, and that looks like a whole adventure if you rely on theme features), but the [community forums](https://discourse.gohugo.io) are filled with very helpful threads, and it is relatively easy to find help for Hugo online. It's a popular tool that's well documented and has an active community. Some of the challenges I've faced are quirks or limitations of Hugo, while some are problems I would have had with any static site generator. I'm overall happy with the Hugo experience.
