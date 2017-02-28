---
layout: post
title: use hard link to avoid reference error in script
date: 2017-02-23 17:19:22 +0800
categories: linux
---
> There is a real story. Here is two directories like below, the first one is the core folder for daily cronjob scripts, the second one is another folder for a web application.

```
\A
  \core_module
    \--bin
      \--core_script.sh

\B
  \extend_module
    \--bin
      \--ext_script.sh
    \--bin2
```

Last friday, I moved ext_script.sh from bin to bin2 since a structure change which cause a two day delay for core crontab jobs. The reason is that core_script.sh include ext_script.sh with an absolute path.

```
#core_script.sh
...
# include extend functions
. /B/extend_module/bin/ext_script.sh
...
```

So, to avoid this kind of fatal error. We can use hard link.
```
$ln /B/extend_module/bin/ext_script.sh /A/core_module/ext_ref/ext_script.sh

\A
  \core_module
    \--bin
      \--core_script.sh
    \--ext_ref
      \--ext_script.sh
\B
  \extend_module
    \--bin
      \--ext_script.sh
    \--bin2

#core_script.sh
...
# include extend functions
. ../ext_ref/ext_script.sh
...
```

Once we create hard link, two files point to same inode block on linux file system, one of them moved or deleted won't affect the other one, both can be updated. So for security concern, it's better to remove write permission for reference folder.

*It is always dangerous that use absolute path !!*
