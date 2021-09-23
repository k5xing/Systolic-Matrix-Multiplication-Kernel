#!/usr/bin/env perl

# lint_modules.pl - Lint all top level modules in a verilog file.
#
# Author: Julian Parkin
#
# Usage:
#   ./lint_modules.pl <file>
#
#   Will lint all modules in <file>.
#
# Prerequisites:
#   - Verilog::Netlist CPAN package (https://metacpan.org/pod/Verilog::Netlist)
#   - Verilator (https://www.veripool.org/wiki/verilator)

use strict;
use warnings;

use Verilog::Netlist;
use Verilog::Getopt;

die "Usage: $0 <file>\n"
  unless @ARGV == 1;

my $FILE_TO_LINT = $ARGV[0];

# Extra options to pass to verilator, adjust as needed.
my @VERILATOR_OPTIONS = (
  '-Wall',
  '-Wno-DECLFILENAME',
  '-Wno-width'
);

# Find all top (i.e. not used in another module) modules in a file.
sub get_top_modules {
  my $file = shift;

  # Set current directory as an include directory to resolve
  # references to modules outside the file being linted.
  my $opt = new Verilog::Getopt;
  $opt->parameter('+incdir+.');

  my $nl = new Verilog::Netlist(options => $opt);

  $nl->read_file(filename => $file);
  $nl->link();
  $nl->exit_if_error();

  return $nl->top_modules_sorted;
}

# Run verilator on a list of modules.
sub lint_modules {
  my $modules = shift;

  foreach (@$modules) {
    my $module = $_->name;

    print "Linting $module in $FILE_TO_LINT\n";

    # Verilator will return non zero exit status when there are warnings
    # or errors, so only check specifically for the -1 status from system()
    # (unable to execute).
    system(
      'verilator',
      '--lint-only',
      @VERILATOR_OPTIONS,
      '--top-module',
      $module,
      $FILE_TO_LINT
    ) != -1 or die "Error: Unable to execute verilator\n";
  }
}

lint_modules [get_top_modules $FILE_TO_LINT];
