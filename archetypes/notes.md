---
title: "{{ replace .Name "-" " " | title }}"
type: "notes"
date: {{ .Date }}
draft: true
slug: "/{{ .File.ContentBaseName | lower }}/"
url: "/notes/{{ .File.ContentBaseName | lower }}/"
{{ if hasPrefix .Dir "notes/snippets" }}
categories: []
description: "Code snippet or command reference"
tags: ["snippet"]
{{ else }}
categories: []
description: ""
tags: ["note"]
{{ end }}
---
