# vhostparser
## Description
`vhostparser` is a shell script that parses Apache configuration files
for VirtualHost directives, and returns the IP, ServerName, ServerAlias,
and DocumentRoot values.

## Installation
Just put it in `/usr/local/bin` and `chmod +x` it.

## Invokation
You just feed it a file.  That's all.  It will only take one at a time,
so if you have multiple files, you'll have to loop it.

```
vhostparser [INFILE]
```
