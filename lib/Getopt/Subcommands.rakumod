use v6.c;
unit class Getopt::Subcommands:ver<0.0.2>:auth<cpan:LEONT>;

use Getopt::Long :functions;
use Text::Levenshtein::Damerau;

my role Subcommand {
	has Str:D $.name is required;
}

multi sub trait_mod:<is>(Sub $sub, Str :$command!) is export {
	$sub does Subcommand($command);
}

our sub RUN-MAIN(Sub $main, $, *%) is export {
	my %options = %*SUB-MAIN-OPTS // {};
	my %commands = $main.candidates.grep(Subcommand).map: { $^sub.name => $sub };
	my $program-name = $*PROGRAM;
	my @orig-args = @*ARGS;
	my $command = @*ARGS.shift;
	$program-name ~= ' ' ~ $command if $command;

	if %commands{$command} -> $callback {
		return call-with-getopt($callback, @*ARGS, %options).sink;
	}
	elsif $main.candidates.first(*.can('default')) -> $callback {
		@*ARGS = @orig-args;
		return call-with-getopt($callback, @*ARGS, %options).sink;
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

 multi MAIN(*@files, Bool :$dry-run) is command<frobnicate> { ... }
 
 multi MAIN(:$fuzzy) is command<unfrobnicate> { ... }

 multi MAIN(*@args) is default { ... }

=head1 DESCRIPTION

Getopt::Subcommands is an extension to Getopt::Long that facilitates writing programs with multiple subcommands. It dispatches based on the first argument.

=head1 AUTHOR

Leon Timmermans <fawaka@gmail.com>

=head1 COPYRIGHT AND LICENSE

Copyright 2019 Leon Timmermans

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

=end pod
