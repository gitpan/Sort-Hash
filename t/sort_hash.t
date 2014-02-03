use Test::More tests => 4;

BEGIN { use_ok( Sort::Hash ); }

my %H1 = (
  utopians => 'transferrer',
  humiliation => 'alligators',
  Woodwards => 'shift',
  cataclysmic => 'evaluative',
  deposition => 'ruling',
  checksummed => 'Cuzco',
  VAXes => 'practicality',
  Knox => 'repress',
  adhering => 'euphemisms',
  lends => 'symphony',
);
my %H2 = (
    Bela         => 1289,
    poses        => 6431,
    murmurer     => 3119,
    handcuffs    => 4274,
    drive        => 5612,
    Emmett       => 6709,
    gayness      => 9522,
    Ceylon       => 87,
    walked       => 441,
    digitization => 503
);

    my @H1Result = sort_hash( %H1, alpha => 1 );
    my @H1Expect = (
        qw /humiliation checksummed adhering cataclysmic
          VAXes Knox deposition Woodwards lends utopians/);
    is( "@H1Result", "@H1Expect", 'default sort for %H1' );
    my @H2Result = sort_hash( %H2, direction => 'Asc' );
    my @H2Expect = (
        qw/Ceylon walked digitization Bela murmurer handcuffs 
          drive poses Emmett gayness/ );
    is( "@H2Result", "@H2Expect", 'Asc sort for %H2' );
    @H2Result = sort_hash( hashref => \%H2, direction => 'desc' );
    @H2Expect = (
        qw/ gayness Emmett poses drive handcuffs murmurer Bela 
            digitization walked Ceylon/ );  
    is( "@H2Result", "@H2Expect", 'desc sort for %H2 passed as hash' );    


done_testing();
