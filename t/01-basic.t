#! perl6
use v6.c;
use Test;

unit package Namespace;

use Getopt::Subcommands;

sub run(&MAIN, *@args) {
	my @*ARGS = @args;
	my $*ERR = open($*SPEC.devnull, :w);
	my &*EXIT = sub ($value) { die ~$value; }
	RUN-MAIN(&MAIN, Any);
}

package Foo {
	sub foo (:$foo) is command {
		is($foo, 'bar', 'Got bar');
	}
	sub bar (:$baz) is command {
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
