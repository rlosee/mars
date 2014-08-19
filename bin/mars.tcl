#!/bin/sh
# -*-tcl-*-
# The next line restarts using tclsh \
exec tclsh "$0" "$@"

#-----------------------------------------------------------------------
# TITLE:
#    mars.tcl
#
# PROJECT:
#    athena-mars
#
# DESCRIPTION:
#    Application Launcher for mars
#
#    This script serves as the main entry point for the mars
#    tool.  The tool is invoked using 
#    the following syntax:
#
#        $ mars ?args....?
#
# TODO: Much of this boilerplate could be moved into kiteinfo(n).
#
#    Generated by Kite.
#-----------------------------------------------------------------------

#-----------------------------------------------------------------------
# Set up the auto_path, so that we can find the correct libraries.  
# In development, there might be directories loaded from TCLLIBPATH;
# strip them out.

# First, remove all TCLLIBPATH directories from the auto_path.

if {[info exists env(TCLLIBPATH)]} {
    set old_path $auto_path
    set auto_path [list]

    foreach dir $old_path {
        if {$dir ni $env(TCLLIBPATH)} {
            lappend auto_path $dir
        }
    }
}

# Next, get the project library directories.  Whether we're
# in a starkit or not, the libraries can be found relative to this
# script file.

set appdir  [file normalize [file dirname [info script]]]
set libdir  [file normalize [file join $appdir .. lib]]

# Add the project libs to the new lib path.
set auto_path [linsert $auto_path 0 $libdir]

#-----------------------------------------------------------------------
# Next, require Tcl/Tk and other required packages.

package require Tcl
package require kiteinfo

if {[kiteinfo gui mars]} {
    package require Tk
}

#-----------------------------------------------------------------------
# Next, add any includes libraries to the auto_path.
#
# This presumes that the include follows the usual project tree, with
# all Tcl packages in $root/lib/<package>.

foreach iname [kiteinfo includes] {
    set idir [file join $appdir .. includes $iname lib]
    set auto_path [linsert $auto_path 0 [file normalize $idir]]
}

#-----------------------------------------------------------------------
# NEXT, load the application code.  This should define the "main"
# command.

package require marsapp

#-----------------------------------------------------------------------
# Run the program

try {
    # Allow for interactive testing
    if {!$tcl_interactive} {
        main $argv
    }
} trap FATAL {result} {
    # A fatal application error; result is a message intended
    # for the user.
    puts $result
    puts ""
} on error {result eopts} {
    # A genuine error; report it in detail.
    puts "Unexpected Error: $result"
    puts "\nStack Trace:\n[dict get $eopts -errorinfo]"
}
