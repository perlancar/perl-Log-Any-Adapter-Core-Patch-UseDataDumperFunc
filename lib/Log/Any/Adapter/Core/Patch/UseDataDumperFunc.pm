package Log::Any::Adapter::Core::Patch::UseDataDumperFunc;

use 5.010001;
use strict;
no warnings;
use Log::Any; # required prior to loading Log::Any::Adapter::Core

use Module::Patch 0.12 qw();
use base qw(Module::Patch);

use Data::Dumper qw(Dumper);

# VERSION
# DATE

our %config;

my $_dump_one_line = sub {
    my ($value) = @_;

    return Dumper($value);
};

sub patch_data {
    return {
        v => 3,
        patches => [
            {
                action      => 'replace',
                mod_version => qr/^0\.\d+$/,
                sub_name    => '_dump_one_line',
                code        => $_dump_one_line,
            },
        ],
    };
}

1;
# ABSTRACT: Use Data::Dumper function to dump data structures

=for Pod::Coverage ^(patch_data)$

=head1 SYNOPSIS

 use Log::Any '$log';
 use Log::Any::DDF; # shortcut for Log::Any::Adapter::Core::Patch::UseDataDumperFunc;

 $log->debug("See this data structure: %s", $some_data);


=head1 DESCRIPTION

Log::Any dumps data structures using L<Data::Dumper> like this:

 sub _dump_one_line {
     my ($value) = @_;

     return Data::Dumper->new( [$value] )->Indent(0)->Sortkeys(1)->Quotekeys(0)
       ->Terse(1)->Dump();
 }

This patch replaces that subroutine with:

 sub _dump_one_line {
     my ($value) = @_;

     return Dumper($value);
 }

The goal is to be able to customize the dumping parameter by setting the various
C<$Data::Dumper::*> variables (e.g. C<Indent>, C<Terse>, etc).


=head1 FAQ


=head1 SEE ALSO

L<Log::Any::Adapter::Core::Patch::SetDumperIndent>

L<Log::Any::Adapter::Core::Patch::UseDataDump>

L<Log::Any::Adapter::Core::Patch::UseDataDumperPerlTidy>

=cut
