#! perl6
use v6.c;
use Test;

use Getopt::Subcommands;

my class ExitException {
	has Int $.value;
}

sub run(&MAIN, *@args) {
	my @*ARGS = @args;
	my $*ERR = open($*SPEC.devnull, :w);
	my &*EXIT = sub ($value) { die ~$value; }
	RUN-MAIN(&MAIN, Any);
}

module Foo {
	multi MAIN(:$foo) is command<foo> {
		is($foo, 'bar', 'Got bar');
	}
	multi MAIN(:$baz) is command<bar> {
		is($baz, val('1'), 'Got 1');
	}
	subtest 'First', {
		plan 5;
		run(&MAIN, <foo --foo bar>);
		run(&MAIN, <bar --baz 1>);
		throws-like({ run(&MAIN) }, X::AdHoc, 'Should fail without arguments', :message('No command given'));
		throws-like({ run(&MAIN, 'none') }, X::AdHoc, 'Should fail with non-existent argument', :message('Unknown subcommand none, known commands are bar, foo'));
		throws-like({ run(&MAIN, 'for') }, X::AdHoc, 'Should fail with non-existent argument', :message('Unknown subcommand for, did you mean bar or foo'));
	};
}

done-testing;
