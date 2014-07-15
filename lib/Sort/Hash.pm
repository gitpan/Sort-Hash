use strict;
use warnings FATAL => 'all';

package Sort::Hash;
{
  $Sort::Hash::VERSION = '2.03';
}
use Exporter 'import';
use Try::Tiny 0.13;
use Scalar::Util 1.24;

our @EXPORT = qw( sort_hash );    # symbols to export on request

# ABSTRACT: Sort the keys of a Hash into an Array without having to read the perldoc for sort!

=pod

=head1 NAME

Sort::Hash - get the keys to a hashref sorted by their values

=head1 VERSION

version 2.03

=head1 SYNOPSIS

Hash::Sort is just a convenience for returning the keys of a hashref
sorted by their values. The hash may either be passed directly or
as a hashref, numeric and alphanumeric sorting are supported, 
the sort may be either Ascending or Descending. 

  use Sort::Hash;
  my @sorted = sort_hash( \%Hash );

This does exactly the same as: 

 my @sorted = ( sort { $Hash{$a} <=> $Hash{$b} } keys %Hash ) ;

=head1 DESCRIPTION 

Sort the keys of a Hash into an Array without having to read the perldoc for sort! 

=head2 sort_hash 

Return a sorted array containing the keys of a hash.

=head3 Options to sort_hash

    nofatal      warn and return an emppty list instead of dying on
                 invalid sort
    silent       like nofatal but doesn't emit warnings either
    noempty      if the hashref is empty treat it as an error
                 instead of returning an empty list ().
    desc         sort descending instead of ascending
    asc          ascending sort is the default but you can specify it
    alpha        sort alpha (treats numbers as text)
    strictalpha  sort alpha but refuse to sort numbers as text
    numeric      sort as numbers, default is numeric

The first argument is the hashref to be sorted, followed by the arguments which may be in any order.

 sort_hash( $hashref, 'strictalpha', 'desc' );
 sort_hash( $hashref, qw/ noempty nofatal alpha desc /);

=head2 Errors

Numeric sorts will fail if given a non-number. Normally alpha sorts will
treat numbers as text. strictalpha uses Scalar::Util::looks_like_number 
to reject a hash that has any values that appear to be numbers.

When the data is illegal for the sort type in effect, (only alpha has no restriction) sort_hash will die. If you prefer it not to, use nofatal to return () and warn instead of die, silent (implies nofatal) will just return () without a warning. 

Sorting an empty hashref will return nothing (). You can make this into an error that will die or warn depending on the nofatal flag with noempty.

=head1 Changes from Version 1.x to 2.x

The API has been changed from version 1. When looking back at sort_hash I decided that I didn't like a number of things about it, I even ended up agreeing with a complaint from PerlCritic! 

=head2 If you need version1 compatibility

Version 1 is included in the version 2 distribution, renamed as Sort::Hash1, just change your use statement to C<use Sort::Hash1;>.

=cut

sub sort_hash {
    my @sorted = ();
    my $H      = shift;
    my ( $silent, $nofatal, $noempty, $desc, $alpha, $strictalpha ) = 0;
    my ( $numeric, $asc ) = 1;
    for (@_) {
        if ( $_ eq 'nofatal' ) { $nofatal = 1 }
        if ( $_ eq 'silent' )  { $silent  = 1; $nofatal = 1 }
        if ( $_ eq 'noempty' ) { $noempty = 1 }
        if ( $_ eq 'desc' )    { $desc    = 1; $asc = 0 }
        if ( $_ eq 'asc' )     { $asc     = 1; $desc = 0 }
        if ( $_ eq 'alpha' )   { $alpha   = 1; $numeric = 0; }
        if ( $_ eq 'strictalpha' ) {
            $strictalpha = 1;
            $alpha       = 1;
            $numeric     = 0;
        }
        if ( $_ eq 'numeric' ) { $strictalpha = 0; $alpha = 0; $numeric = 1; }
    }

    my $death = sub {
        if ($nofatal) { warn $_[0] unless $silent; return (); }
        else          { die $_[0]; }
    };
    if ($noempty) {
        unless ( scalar( keys %$H ) ) {
            $death->(
                'Attempt to sort an empty hash while noempty is in effect');
        }
    }
    if ($strictalpha) {
        for ( values %{$H}) {
            if ( Scalar::Util::looks_like_number($_) ) {
                $death->(
                    'Attempt to Sort Numeric Value in Strict Alpha Sort');
                return ;
            }
        }
    }
    if ($alpha) {
        @sorted = ( sort { lc $H->{$a} cmp lc $H->{$b} } keys %{$H} );
    }
    else {
        try {
            @sorted = ( sort { $H->{$a} <=> $H->{$b} } keys %{$H} );
        }
        catch {
            $death->('Attempt to Sort non-Numeric values in a Numeric Sort');
            return ;
        }
    }
    if ( $desc ) {
        return reverse @sorted;
    }
    else { return @sorted; }
}

=pod

=head1 AUTHOR

John Karr, C<brainbuz at brainbuz.org>

=head1 BUGS

Please report any bugs or feature requests via the BitBucket issue tracker at
L<https://bitbucket.org/brainbuz/sort-hash/issues>.  I will be
notified, and then you'll automatically be notified of progress on
your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

You can also look for information at: The documentation for the 
sort command in the Perl documentation.

=head1 LICENSE AND COPYRIGHT

Copyright 2014 John Karr.

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; version 3 or at your option
any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

A copy of the GNU General Public License is available in the source tree;
if not, write to the Free Software Foundation, Inc.,
59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.

=cut

1;
