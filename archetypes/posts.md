---
title: "{{ replace .Name "-" " " | title }}"
date: {{ .Date }}
draft: true
slug: "/{{ .File.ContentBaseName | lower }}/"
# url: "/posts/{{ .File.ContentBaseName | lower }}/"
categories: []
tags: []
author: "me"
description: ""
showToc: false
TocOpen: false
hidemeta: false
comments: false
searchHidden: false
---
