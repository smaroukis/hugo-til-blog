---
title: "filename with spaces"
date: 2023-10-18
description: null
tags: [test]
---

Currently a few ways to embed images:
1. `obsidian-export` will export the `sample-vault/attachments` files into `$HUGO_ROOT/content/posts/attachments` (or whatever destination we pass). If we also include the partials that allow relative links to work (`render-image.html` and `render.link.html`) then the images will be served **but not responsive or scaled**
2. without the partials to enable relative links we have to move images to `$HUGO_ROOT/static/attachments` AND add prepending `/` (slash) to the image referenced in markdown (e.g. `![alt](/attachments/image.png`) (note that `static` is mounted to `/` when the site is built) 
3. for the responsive image partials in `imgh.html` to work, we need to put images into `$HUGO_ROOT/assets/images` (note `images` is hardcoded in the `imgh.html` partial so we can change that) AND reference the image in markdown as `{{< imgh src="image.png" alt="alt-text" >}}`

Typically we can include images at `/static/images`

## 1 - No edits

> Currently Obsidian encodes spaces when we insert images 

The following 
```
![alt text](attachments/image%20with%20spaces.png)
```

Renders as:
![alt text](attachments/image%20with%20spaces.png)

## 3 - For responsive

The following line:
```
{{< imgh src="attachments/image%20with%20spaces.png" alt="alt text" >}}
```

%%
Renders as the image: 
{{< imgh src="attachments/image%20with%20spaces.png" alt="alt text" >}}
%%