[![Build Status](https://travis-ci.org/Leont/getopt-subcommands.svg?branch=master)](https://travis-ci.org/Leont/getopt-subcommands)

NAME
====

Getopt::Subcommands - A Getopt::Long extension for subcommands

SYNOPSIS
========

    use Getopt::Subcommands;

    multi MAIN(*@files, Bool :$dry-run) is command<frobnicate> { ... }

    multi MAIN(:$fuzzy) is command<unfrobnicate> { ... }

    multi MAIN(*@args) is default { ... }

DESCRIPTION
===========

Getopt::Subcommands is an extension to Getopt::Long that facilitates writing programs with multiple subcommands. It dispatches based on the first argument.

AUTHOR
======

Leon Timmermans <fawaka@gmail.com>

COPYRIGHT AND LICENSE
=====================

Copyright 2019 Leon Timmermans

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

