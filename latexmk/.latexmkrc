# vim: ft=perl

# -- bib2gls support ---------------------------------------------------------

# Sources:
# ctan.math.utah.edu/ctan/tex-archive/support/latexmk/example_rcfiles/bib2gls_latexmkrc
# https://tex.stackexchange.com/questions/400325

push @generated_exts, 'glstex', 'glg';

add_cus_dep('aux', 'glstex', 0, 'run_bib2gls');

sub run_bib2gls {
  my ($base, $path) = fileparse( $_[0] );
  my $silent_command = $silent ? "--silent" : "";
  if ( $path ) {
    my $ret = system("bib2gls $silent_command -d '$path' --group '$base'");
  } else {
    my $ret = system("bib2gls $silent_command --group '$_[0]'");
  };
  local *LOG;
  $LOG = "$_[0].glg";
  if (!$ret && -e $LOG) {
    open LOG, "<$LOG";
    while (<LOG>) {
      if (/^Reading (.*\.bib)\s$/) {
        rdb_ensure_file( $rule, $1 );
      }
    }
    close LOG;
  }
  return $ret;
}
