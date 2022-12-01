[![Build Status](https://travis-ci.org/Leont/getopt-subcommands.svg?branch=master)](https://travis-ci.org/Leont/getopt-subcommands)

NAME
====

Getopt::Subcommands - A Getopt::Long extension for subcommands

SYNOPSIS
========

    use Getopt::Subcommands;

    sub frobnicate(*@files, Bool :$dry-run) is command { ... }

    sub unfrobnicate(:$fuzzy) is command { ... }

    sub other($subcommand?, *@args) is fallback { ... }

DESCRIPTION
===========

Getopt::Subcommands is an extension to Getopt::Long that facilitates writing programs with multiple subcommands. It dispatches based on the first argument.

It can be used by using two traits on the subs: `is command` and `is fallback`. The former can optionally take the name of the subcommand as an argument, but will default to the name of the sub. The latter will be called if no suitable subcommand can be found or if none is given.

AUTHOR
======

Leon Timmermans <fawaka@gmail.com>

COPYRIGHT AND LICENSE
=====================

Copyright 2019 Leon Timmermans

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

