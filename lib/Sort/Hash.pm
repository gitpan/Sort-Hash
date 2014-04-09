package Sort::Hash;
use Exporter 'import';    # gives you Exporter's import() method directly
use Try::Tiny 0.13;
use Scalar::Util 1.24;
use strict;
use warnings FATAL => 'all';

our @EXPORT = qw( sort_hash );    # symbols to export on request

our $VERSION = '1.04';

=head1 NAME

Sort::Hash get the keys to a hashref sorted by their values

=head1 VERSION 

1.03

=head1 SYNOPSIS

Hash::Sort is just a convenience for returning the keys of a hashref
sorted by their values. The hash may either be passed directly or
as a hashref, numeric and alphanumeric sorting are supported, 
the sort may be either Ascending or Descending. 

  use Sort::Hash;
  my @sorted = sort_hash( %some_hash );
  
This does exactly the same as:
  my @sorted = ( sort { $H{$a} <=> $H{$b} } keys  %some_hash ) ;
  
=head1 Description  
  
A single method B<sort_hash> is exported.  
  
=head2 sort_hash 

Return a sorted array containing the keys of a hash.

 my @sorted = sort_hash( 
    direction   => 'desc' , # default is asc
    alpha       => 1 , # Sort alpha, will sort numbers as text
    strictalpha => 1, # refuse to sort numbers as text. implies alpha
    numeric     => 1, # sort as numbers, default is numeric
    hashref     => $hashref , # pass a hashref instead of a hash.
    );

Arguments are passed in with the hash, keys matching argument
names will be interpreted as arguments. To avoid this use a  
hashref instead.

=head2 Errors

Numeric sorts will fail if given a non-number. Normally alpha sorts will
treat numbers as text. strictalpha uses Scalar::Util::looks_like_number 
to reject a hash that has any values that appear to be numbers.

When a sort fails undef is returned and a warning emitted.

=cut

sub sort_hash {
    my %H      = @_;
    my @sorted = ();
    my $direction   = delete $H{direction}   || 'asc';
    my $alpha       = delete $H{alpha}       || 0;
    my $strictalpha = delete $H{strictalpha} || 0;
    my $numeric     = delete $H{numeric}     || 1;
    if ( defined $H{hashref} ) { %H = %{ $H{hashref} } }
    if ($strictalpha) { 
        $alpha = 1;
        for ( values %H ) {
            if (Scalar::Util::looks_like_number($_)) {
                warn 'Attempt to Sort Numeric Value in Strict Alpha Sort';
                return undef }
            }
        }
    if ($alpha) {
        @sorted = ( sort { lc $H{$a} cmp lc $H{$b} } keys %H ) ;
        }
    else {
        try { @sorted = ( sort { $H{$a} <=> $H{$b} } keys %H ) ;}
        catch { 
            warn 'Attempt to Sort non-Numeric values in a Numeric Sort';
            return undef ; }
        }
    if ( lc($direction) eq 'desc' ) {
        return reverse @sorted;
    }
    else { return @sorted; }
}

=head1 AUTHOR

John Karr, C<< <brainbuz at brainbuz.org> >>

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
