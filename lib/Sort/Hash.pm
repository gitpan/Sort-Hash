use warnings;
use strict;
package Sort::Hash;
use Exporter 'import';    # gives you Exporter's import() method directly
our @EXPORT = qw( sort_hash );    # symbols to export on request

our $VERSION = '1.00';

# ABSTRACT: Hash Sorting.

=head1 NAME

Sort::Hash

=head1 VERSION 

1.00

=head1 SYNOPSIS

Hash::Sort is just a convenience for returning the keys of a hashref
sorted by their values. The hash may either be passed directly or
as a hashref, numeric and alphanumeric sorting are supported, 
the sort may be either Ascending or Descending. 

  use Sort::Hash;
  my @sorted = sort_hash( %some_hash );
  
=head1 Description  
  
A single method B<sort_hash> is exported.  
  
=head2 sort_hash 

Return a sorted array containing the keys of a hash.

 my @sorted = sort_hash( 
    direction => 'desc' , # default is asc
    alpha     => 1 , # Sort alpha, default is numeric
    numeric   => 1, # sort as numbers.
    hashref   => $hashref , # pass a hashref instead of a hash.
    );

Arguments are passed in with the hash, keys matching argument
names will be interpreted as arguments. To avoid this use a 
hashref instead.  

=cut

sub sort_hash {
    my %H      = @_;
    my @sorted = ();
    my $direction = delete $H{direction} || 'asc';
    my $alpha     = delete $H{alpha}     || 0;
    my $numeric   = delete $H{numeric}   || 1;
    if ( defined $H{hashref} ) { %H = %{ $H{hashref} } }
    if ($alpha) {
        foreach my $name ( sort { lc $H{$a} cmp lc $H{$b} } keys %H ) {
            push @sorted, $name;    }
        }
    else {
        foreach my $name ( sort { $H{$a} <=> $H{$b} } keys %H ) {
            push @sorted, $name;
        }
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

You can also look for information at:

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
