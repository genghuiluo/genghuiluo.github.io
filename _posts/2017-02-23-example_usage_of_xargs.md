---
layout: post
title: example usage of xargs
date: 2017-02-23 17:19:22 +0800
categories: linux
---
### Using a placeholder
```
find . -maxdepth 1 -type d -print | xargs echo Directories:
find . -maxdepth 1 -type d -print | parallel -X echo Directories:
```
This will print all directories in the current folder. The command (echo) specified will receive the input from find and be executed once. That's why this code will output all directories on one line.

```
find . -maxdepth 1 -type d -print | xargs -I {} echo Directory: {}
find . -maxdepth 1 -type d -print | parallel echo Directory: {}
```
This time we added -I {} to xargs. This is the replacement argument. The command specified to xargs will now be executed once for each line of output from find and replace {} with that line. -I {} is default for GNU Parallel and thus not needed.

So this time we get each directory printed on a separate line.

> Note: If xargs -I fails you might need a newer version of xargs. The Gentoo package findutils contains xargs.

Keep this in mind when using xargs. When creating more complex commands you often need to use the -I argument. Like if you want to run multiple commands and/or pipe to another command.

### Multiple lines as one argument
```
ls | xargs -L 4 echo
ls | parallel -L 4 echo
```
Using the -L argument we can concatenate n lines into one (separated with spaces of course). In this case it will output four files/directories on each line.

### Custom delimiters
```
echo "foo,bar,baz" | xargs -d, -L 1 echo
echo "foo,bar,baz" | parallel -d, echo
```
The -d argument is used to use a custom delimiter, c-style escaping is supported (\n is newline for instance). In this case it will output foo, bar and baz on a separate line.

### Read from file instead of stdin
```
xargs -a foo -d, -L 1 echo
parallel -a foo -d, echo
```
The -a argument is used to read from a file instead of stdin. Otherwise this example is the same as the previous.

### Showing command to be executed
```
ls | xargs -t -L 4 echo
ls | parallel -t -L 4 echo
```
Before running the command -t will cause xargs to print the command to run to stderr. In this case it will output "echo fred barney wilma betty" before running that same line.

As GNU Parallel runs the commands in parallel you may see the output from one of the already run commands mixed in. You can use -v instead which will print the command just before it prints the output to stdout.
```
ls | parallel -v -L 4 echo
```

### Handling paths with whitespace etc
```
find . -print0 | xargs -0 echo
```
Each argument passed from find to xargs is separated with a null-terminator instead of space. It's hard to present a case where it is required as the above example would work anyway. But if you get problems with paths which may contain whitespace, backspaces or other special characters use null-terminated arguments instead.

GNU Parallel does the right thing for file names containing ", ' and space. Only if the file names contain newlines you need -0.

### Snippets
```
find . -type d -name ".svn" -print | xargs rm -rf
find . -type d -name ".svn" -print | parallel rm -rf
```
The above command will execute rm on each file found by 'find'. The above construct can be used to execute a command on multiple files. This is similar to the -exec argument find has but doesn't suffer from the "Too Many Arguments" problem. And xargs is easier to read than -exec in most cases.
