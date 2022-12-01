use v6.c;
unit class Getopt::Subcommands:ver<0.1.0>:auth<cpan:LEONT>;

use Getopt::Long :functions;
use Text::Levenshtein::Damerau;

my %commands;
my &fallback;

# A noop but without this Raku will not run RUN-MAIN
proto MAIN(|) is export(:DEFAULT :MAIN) {*}

multi trait_mod:<is>(Sub $sub, Str :$command!) is export(:DEFAULT :traits) {
	%commands{$command} = $sub;
}

multi trait_mod:<is>(Sub $sub, Bool :$command!) is export(:DEFAULT :traits) {
	%commands{$sub.name} = $sub;
}

multi trait_mod:<is>(Sub $sub, Bool :$fallback!) is export(:DEFAULT :traits) {
	&fallback = $sub;
}

our sub RUN-MAIN(Sub $main, $, *%) is export(:DEFAULT :MAIN :RUN-MAIN) {
	my @orig-args = @*ARGS;
	my $command = @*ARGS.shift;
	my $program-name = $command ?? "$*PROGRAM $command" !! $*PROGRAM;

	if %commands{$command} -> $callback {
		return call-with-getopt($callback, @*ARGS);
	}
	elsif &fallback {
		@*ARGS = @orig-args;
		return call-with-getopt(&fallback, @*ARGS);
	}
	elsif $command {
		if %commands.keys.grep({ dld($command, $_) < 3 }) -> @alternatives {
			die Getopt::Long::Exception.new: "Unknown subcommand $command, did you mean { @alternatives.sort.join(' or ') }";
		}
		else {
			die Getopt::Long::Exception.new: "Unknown subcommand $command, known commands are { %commands.keys.sort.join(', ') }";
		}
	}
	else {
		die Getopt::Long::Exception.new: "No command given";
	}
	CATCH {
		when Getopt::Long::Exception {
			note "$program-name: {.message}";
			&*EXIT(IntStr.new(2, .message));
		}
	}
}

=begin pod

=head1 NAME

Getopt::Subcommands - A Getopt::Long extension for subcommands

=head1 SYNOPSIS

 use Getopt::Subcommands;

 sub frobnicate(*@files, Bool :$dry-run) is command { ... }
 
 sub unfrobnicate(:$fuzzy) is command { ... }

 sub other($subcommand?, *@args) is fallback { ... }

=head1 DESCRIPTION

Getopt::Subcommands is an extension to Getopt::Long that facilitates writing programs with multiple subcommands. It dispatches based on the first argument.

It can be used by using two traits on the subs: C<is command> and C<is fallback>. The former can optionally take the name of the subcommand as an argument, but will default to the name of the sub. The latter will be called if no suitable subcommand can be found or if none is given.

=head1 AUTHOR

Leon Timmermans <fawaka@gmail.com>

=head1 COPYRIGHT AND LICENSE

Copyright 2019 Leon Timmermans

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

=end pod
