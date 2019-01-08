# -------------------------------------------------------------------------
# Package
#    makeDriver.pl
#
# Dependencies
#    None
#
# Purpose
#    Use Make tool features on Electric Commander
#
# Plugin Version
#    1.0.2
#
# Date
#    04/13/2011
#
# Engineer
#    Andres Arias
#
# Copyright (c) 2011 Electric Cloud, Inc.
# All rights reserved
# -------------------------------------------------------------------------


# -------------------------------------------------------------------------
# Includes
# -------------------------------------------------------------------------
use strict;
use warnings;
$|=1;

use ElectricCommander;
use Encode;
use utf8;
use open IO => ':encoding(utf8)';# -------------------------------------------------------------------------   # Constants   # -------------------------------------------------------------------------   use constant {       SUCCESS => 0,       ERROR   => 1,              PLUGIN_NAME => 'EC-Make',       WIN_IDENTIFIER => 'MSWin32',         };

# -------------------------------------------------------------------------
# Variables
# -------------------------------------------------------------------------

################################################################################
# procedure parameter name: [file]
#
# script variable name: $::gMakeFile
#
# purpose: specify the makefile to execute
#
# implemented in this script: yes
################################################################################

################################################################################
# procedure parameter name: [target]
#
# script variable name: $::gTarget
#
# purpose: specify the target to execute
#
# implemented in this script: yes
################################################################################

################################################################################
# procedure parameter name: [directory]
#
# script variable name: $::gWorkingDirectory
#
# purpose: the directory to change to before executing the make file
#
# implemented in this script: yes
################################################################################

################################################################################
# procedure parameter name: [keepgoing]
#
# script variable name: $::gKeepGoing
#
# purpose: instructs make to keep going as much as possible after an error
#
# implemented in this script: yes
################################################################################
sub trim($) {
     my ($untrimmedString) = @_;
     my $string = $untrimmedString;
     $string =~ s/^\s+//;
     $string =~ s/\s+$//;
     return $string;
}$::gEC = new ElectricCommander();      $::gEC->abortOnError(0);$::gMakeExecutablePath = ($::gEC->getProperty("makeexecpath") )->findvalue("//value");     
$::gMakeFile = ($::gEC->getProperty("file") )->findvalue("//value");
$::gTarget = ($::gEC->getProperty("target") )->findvalue("//value");
$::gWorkingDirectory = ($::gEC->getProperty("workingdirectory") )->findvalue("//value");
$::gKeepGoing = ($::gEC->getProperty("keepgoing") )->findvalue("//value");
# -------------------------------------------------------------------------
# Main functions
# -------------------------------------------------------------------------
  ########################################################################  # createCommandLine - creates the command line for the invocation  # of the program to be executed.  #  # Arguments:  #   -arr: array containing the command name (must be the first element)   #         and the arguments entered by the user in the UI  #  # Returns:  #   -the command line to be executed by the plugin  #  ########################################################################  sub createCommandLine($) {            my ($arr) = @_;            my $commandName = @$arr[0];            my $command = $commandName;            shift(@$arr);            foreach my $elem (@$arr) {          $command .= " $elem";      }            return $command;           }

########################################################################
# setProperties - set a group of properties into the Electric Commander
#
# Arguments:
#   -propHash: hash containing the ID and the value of the properties 
#              to be written into the Electric Commander
#
# Returns:
#   -nothing
#
########################################################################
sub setProperties($) {
    my ($propHash) = @_;
    # get an EC object
    my $ec = new ElectricCommander();
    $ec->abortOnError(0);
    foreach my $key (keys % $propHash) {
        my $val = $propHash->{$key};
        $ec->setProperty("/myCall/$key", $val);
    }
}

########################################################################
# main - contains the whole process to be done by the plugin, it builds the
#        command line, sets the properties and the working directory
#
# Arguments:
#   -none
#
# Returns:
#   -nothing
#
########################################################################
sub main() {
   
	binmode STDOUT, ':encoding(utf8)';
	binmode STDIN,  ':encoding(utf8)';
	binmode STDERR, ':encoding(utf8)';
   
   
    # create args array
    my @args = ();
    my %props;    if($::gMakeExecutablePath && $::gMakeExecutablePath ne '') {        push(@args, '"' . $::gMakeExecutablePath . '"');    }        # if keepgoing: add to command string
    if($::gKeepGoing && $::gKeepGoing ne '') {
        push(@args, '--keep-going');
    }
    # if working directory: add to command string
    if($::gWorkingDirectory && $::gWorkingDirectory ne '') {
		if (utf8::is_utf8($::gWorkingDirectory)) {
			push(@args, "--directory=\"encode_utf8($::gWorkingDirectory)\"");
        }else
        {
			push(@args, "--directory=\"$::gWorkingDirectory\"");
		}
    }
    # if makefile: add to command string
    if($::gMakeFile && $::gMakeFile ne '') {
        push(@args, "--makefile=\"$::gMakeFile\"");
    }
    # if target: add to command string
    if($::gTarget && $::gTarget ne '') {
        push(@args, $::gTarget);
    }
    my $commandLine = createCommandLine(\@args);    $props{"makeCommandLine"} = $commandLine;
    setProperties(\%props);        my $content = `$commandLine`;
    print STDOUT $content;
      #evaluates if exit was successful to mark it as a success or fail the step    if($? == SUCCESS){        #todo: error validation in case execution success     }else{        #According to make doc, error exit codes are always 1 or 2.        #see http://www.gnu.org/s/make/manual/make.html#Running        $::gEC->setProperty("/myJobStep/outcome", 'error');    }
}
main();

