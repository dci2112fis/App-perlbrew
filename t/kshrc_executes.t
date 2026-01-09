#!/usr/bin/env perl
use Test2::V0;

use FindBin;
use lib $FindBin::Bin;
use App::perlbrew;
require 'test2_helpers.pl';

use Capture::Tiny qw( capture_stderr );
use File::Which qw( which );

note "PERLBREW_ROOT set to $ENV{PERLBREW_ROOT}";

subtest "Works without error output on ksh where hashing is off", sub {
    my $ksh = which("ksh");
    if (!defined($ksh)) {
        skip_all "Ksh executable not found, skipping this test.";
        return;
    }

    my $app = App::perlbrew->new('self-install');
    $app->current_shell("ksh");
    $app->run;

    my $ret;
    my $out = capture_stderr {
        my $ksh_init = file($ENV{PERLBREW_ROOT}, "etc", "kshrc");
        system("ls $ENV{PERLBREW_ROOT}/etc/kshrc");
        $ret = system($ksh, "-n",". $ksh_init");
    };
    is($out, "", "No error messages in output");
    is($ret, 0, "Return value proper");
};


done_testing;
