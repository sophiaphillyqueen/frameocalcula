use strict;
use argola;
use me::parc;
use Scalar::Util qw(looks_like_number);

my $time_needle_main;
my $time_needle_fram;
my @sublayers = ( );
my $max_set = 0;
my $max_is;
my $yet_intag;
my $fram_per_sec = 24;
my $final_note = '';

#my $last_key_nom = '0f';
my $last_key_nom = 'bamboozle';

$time_needle_main = ( 0 - 1 );
$time_needle_fram = ( 0 - 1 );

sub zen_func {
  # A convenient place-holder for functions that must be
  # ignored in the present mode.
}

sub func__n__do {
  $final_note = "\n\n##" . $_[0];
} &me::parc::setfunc('n',\&func__n__do);

sub func__kfram__do {
  my $lc_rg;
  my $lc_org;
  my $lc_raw_key;
  my $lc_time_we_have;
  $lc_rg = $_[0]; $lc_org = $lc_rg;
  $lc_raw_key = &me::parc::fetcho($lc_rg);
  &me::parc::minutize($lc_raw_key);
  if ( $lc_raw_key <= $time_needle_main )
  {
    die( $final_note . "\n\n/kfram/" . $lc_org . "\n    Time must always move forward.\n\n");
  }
  $time_needle_main = $lc_raw_key;
  $lc_time_we_have = &frameloc($lc_raw_key);
  if ( $lc_time_we_have eq $last_key_nom )
  {
    die( $final_note . "\n\n/kfram/" . $lc_org . "\n    Please comment-out - keyframe same.\n\n");
  }
  $last_key_nom = $lc_time_we_have;

  print '<keyframe time="';
  print $lc_time_we_have;
  print '" active="true"/>';
  print "\n";
  
} &me::parc::setfunc('kfram',\&zen_func);

sub func__max__do {
  my $lc_rg;
  $lc_rg = $_[0];
  $max_set = 10;
  $max_is = &me::parc::fetcho($lc_rg);
  &me::parc::minutize($max_is);
} &me::parc::setfunc('max',\&func__max__do);

sub func__ctalk__do {
  # The 'ctalk' function is a modified version of the 'talk'
  # function where the new talk segment rather than having
  # its beginning specified in the directive instead simply
  # picks up where the previous 'talk' or 'ctalk' instance
  # left off.
  my $lc_rg;
  my $lc_time_start;
  my $lc_time_stop;
  my $lc_sylb_remain;
  my $lc_time_remain;
  my $lc_origin;

  $lc_rg = $_[0]; $lc_origin = $lc_rg;
  $lc_time_start = $time_needle_main;
  $lc_time_stop = &me::parc::fetcho($lc_rg);
  &me::parc::minutize($lc_time_stop);
  $lc_sylb_remain = &me::parc::fetcho($lc_rg);
  $lc_time_remain = ( $lc_time_stop - $lc_time_start );

  # Now, without the Sonic Screwdriver, we will deal with
  # all Time Anomilies.
  if ( $lc_time_stop <= $lc_time_start )
  {
    die("\n/ctalk/" . $lc_origin . "\n\nAnd time must ALWAYS move forward.\n");
  }
  if ( ! ( looks_like_number($lc_sylb_remain) ) )
  {
    die("\n/ctalk/" . $lc_origin . "\n\nIt seems like you forgot to specify the number of sylables.\n\n");
  }
  $time_needle_main = $lc_time_stop;


  while ( $lc_sylb_remain > 1.5 )
  {
    my $lc2_neosylb;
    my $lc2_time_rem;
    my $lc2_time_neo;

    $lc2_neosylb = int($lc_sylb_remain - 0.8);
    $lc2_time_rem = ( $lc_time_remain * ( $lc2_neosylb / $lc_sylb_remain ) );
    $lc2_time_neo = ( $lc_time_stop - $lc2_time_rem );

    &talk_a_flower($lc_time_start,$lc2_time_neo);

    $lc_time_start = $lc2_time_neo;
    $lc_time_remain = $lc2_time_rem;
    $lc_sylb_remain = $lc2_neosylb;
  }
  &talk_a_flower($lc_time_start,$lc_time_stop);
} &me::parc::setfunc('ctalk',\&func__ctalk__do);

sub func__talk__do {
  my $lc_rg;
  my $lc_origin;
  my $lc_time_start;
  my $lc_time_stop;
  my $lc_sylb_remain;
  my $lc_time_remain;

  $lc_rg = $_[0]; $lc_origin = $lc_rg;
  $lc_time_start = &me::parc::fetcho($lc_rg);
  $lc_time_stop = &me::parc::fetcho($lc_rg);
  &me::parc::minutize($lc_time_start);
  &me::parc::minutize($lc_time_stop);
  $lc_sylb_remain = &me::parc::fetcho($lc_rg);
  $lc_time_remain = ( $lc_time_stop - $lc_time_start );

  # Now, without the Sonic Screwdriver, we will deal with
  # all Time Anomilies.
  if ( $lc_time_start < $time_needle_main )
  {
    die("\n/talk/" . $lc_origin . "\n\nTime may only move forward, not backward.\n\n");
  }
  if ( $lc_time_stop <= $lc_time_start )
  {
    die("\n/talk/" . $lc_origin . "\n\nAnd time must ALWAYS move forward.\n");
  }
  if ( ! ( looks_like_number($lc_sylb_remain) ) )
  {
    die("\n/talk/" . $lc_origin . "\n\nIt seems like you forgot to specify the number of sylables.\n\n");
  }
  $time_needle_main = $lc_time_stop;


  while ( $lc_sylb_remain > 1.5 )
  {
    my $lc2_neosylb;
    my $lc2_time_rem;
    my $lc2_time_neo;

    $lc2_neosylb = int($lc_sylb_remain - 0.8);
    $lc2_time_rem = ( $lc_time_remain * ( $lc2_neosylb / $lc_sylb_remain ) );
    $lc2_time_neo = ( $lc_time_stop - $lc2_time_rem );

    &talk_a_flower($lc_time_start,$lc2_time_neo);

    $lc_time_start = $lc2_time_neo;
    $lc_time_remain = $lc2_time_rem;
    $lc_sylb_remain = $lc2_neosylb;
  }
  &talk_a_flower($lc_time_start,$lc_time_stop);
} &me::parc::setfunc('talk',\&func__talk__do);

# <animated type="string">

sub func__olayr__do {
  my $lc_rg;
  my $lc_timeat;
  my @lc_nea;
  my @lc_neb;
  my $lc_nec;

  if ( $yet_intag > 5 )
  {
    die(
      "\nCan not have more than one 'olayr' "
    . "directive.\nPlease use a 'layer' "
    . "directive instead.\n\n"
    );
  }
  $yet_intag = 10;


  $lc_rg = $_[0];
  $lc_timeat = &me::parc::fetcho($lc_rg);
  &me::parc::trim($lc_rg);

  # BEGINNING THE START-OF-ANIMATION
  print '<animated type="string">' . "\n";
  print '<waypoint time="0s" before="clamped" after="clamped">
<string>' . $lc_rg . '</string>
</waypoint>' . "\n";
  # FINISHING THE START-OF-ANIMATION

  @lc_nea = ();
  @lc_neb = ();
  foreach $lc_nec (@sublayers)
  {
    if ( ($lc_nec->[0]) < $lc_timeat ) { @lc_nea = (@lc_nea,$lc_nec); }
    if ( ($lc_nec->[0]) > $lc_timeat ) { @lc_neb = (@lc_neb,$lc_nec); }
  }
  $lc_nec = [$lc_timeat,$lc_rg];
  @sublayers = (@lc_nea,$lc_nec,@lc_neb);

  return;
} &me::parc::setfunc('olayr',\&func__olayr__do);

sub func__layer__do {
  my $lc_rg;
  my $lc_timeat;
  my @lc_nea;
  my @lc_neb;
  my $lc_nec;

  $lc_rg = $_[0];
  $lc_timeat = &me::parc::fetcho($lc_rg);
  &me::parc::trim($lc_rg);

  @lc_nea = ();
  @lc_neb = ();
  foreach $lc_nec (@sublayers)
  {
    if ( ($lc_nec->[0]) < $lc_timeat ) { @lc_nea = (@lc_nea,$lc_nec); }
    if ( ($lc_nec->[0]) > $lc_timeat ) { @lc_neb = (@lc_neb,$lc_nec); }
  }
  $lc_nec = [$lc_timeat,$lc_rg];
  @sublayers = (@lc_nea,$lc_nec,@lc_neb);

  return;
} &me::parc::setfunc('layer',\&func__layer__do);



# #############################################


sub frameloc {
  my $lc_src;
  my $lc_ext;
  my $lc_sec;
  my $lc_mon;
  my $lc_ret;

  $lc_ret = '';
  $lc_src = $_[0];
  $lc_sec = int($lc_src);
  $lc_ext = ( $lc_src - $lc_sec );

  $lc_mon = 0;
  while ( $lc_sec > 59.5 )
  {
    $lc_mon = int($lc_mon + 1.2);
    $lc_sec = int($lc_sec - 59.8);
  }
  if ( $lc_mon > 0.5 ) { $lc_ret .= ( $lc_mon . 'm ' ); }

  if ( $lc_sec > 0.5 ) { $lc_ret .= ( $lc_sec . 's ' ); }

  $lc_mon = int(($lc_ext * $fram_per_sec) + 0.5);
  if ( $lc_mon > 0.5 ) { $lc_ret .= ( $lc_mon . 'f ' ); }

  chop($lc_ret);
  if ( $lc_ret eq '' ) { $lc_ret = '0s'; }
  return $lc_ret;
}



sub talk_a_flower {
  my $lc_diffra;
  my $lc_item;
  my $lc_elaps;
  my $lc_atto;

  #print $_[0] . ' ----- ' . $_[1] . " :\n"; # DEBUG
  $lc_diffra = ( $_[1] - $_[0] );
  foreach $lc_item (@sublayers)
  {
    $lc_elaps = ( $lc_diffra * ( $lc_item->[0] ) );
    $lc_atto = ( $lc_elaps + $_[0] );
    &talk_a_petal($lc_atto,($lc_item->[1]));
  }
}

sub talk_a_petal {
  #print "-- " . $_[0] . ' - ' . $_[1] . " :\n"; # DEBUG
  print "<waypoint time=\"" . $_[0];
  print "s\" before=\"clamped\" after=\"clamped\">\n<string>";
  print $_[1] . "</string>\n</waypoint>\n";
}


# #############################################

sub opto__kfm__do {
  # The following functions will be activated in this mode:
  &me::parc::setfunc('kfram',\&func__kfram__do);

  # The following functions will be deactivated in this mode:
  &me::parc::setfunc('layer',\&zen_func);
  &me::parc::setfunc('olayr',\&zen_func);
  &me::parc::setfunc('talk',\&zen_func);
  &me::parc::setfunc('ctalk',\&zen_func);
}

# #############################################


&me::parc::universalopts();
&argola::setopt('-kfm',\&opto__kfm__do);

&argola::runopts();

&me::parc::of_all_the_files();

if ( $yet_intag > 5 )
{
  print "</animated>\n";
}




