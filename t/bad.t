use Test::More ;#tests => 8;
use Test::Warn;

BEGIN { use_ok(Sort::Hash); }

my %AlphaHash = (
    utopians    => 'transferrer',
    humiliation => 'alligators',
    Woodwards   => 'shift',
    cataclysmic => 'evaluative',
    deposition  => 'ruling',
    checksummed => 'Cuzco',
    VAXes       => 'practicality',
    Knox        => 'repress',
    adhering    => 'euphemisms',
    lends       => 'symphony',
);
my %IntegerHash = (
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

my %FloatHash = (
    Bela         => 128.9,
    poses        => 6431,
    murmurer     => 311.9,
    handcuffs    => 4.274,
    drive        => 561.2,
    Emmett       => 6709,
    gayness      => 95.22,
    Ceylon       => 87.00,
    walked       => 441,
    digitization => 503
);

my %MixedHash = ( 
Jugoslavia => 'slate crater',
validating => 'screeching',
elks => 'siphoning',
Boarsh => 'Boarsh impend Kirov.',
treat => 517,
removals => 211.06,
Calais => 'symmetrically',
Boone => 'Symmetricall thumbing the Boone Harp.', );

my @floatres = sort_hash( numeric => 1, hashref => \%FloatHash );
for( @floatres ) { note( "$_ -> $FloatHash{$_}") }
ok(1);



done_testing();
