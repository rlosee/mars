#-----------------------------------------------------------------------
# TITLE:
#    pkgModules.tcl
#
# PROJECT:
#    athena-mars
#
# DESCRIPTION:
#    simlib(n) package modules file
#
#    Generated by Kite.
#-----------------------------------------------------------------------

#-----------------------------------------------------------------------
# Package Definition

# -kite-provide-start  DO NOT EDIT THIS BLOCK BY HAND
package provide simlib 3.0.2a0
# -kite-provide-end

#-----------------------------------------------------------------------
# Required Packages

# -kite-require-start  REQUIRE EXTERNAL PACKAGES HERE
package require snit 2.3
package require sqlite3 3.8
package require kiteutils 0.4.0a0
package require -exact marsutil 3.0.2a0
# -kite-require-end

#-----------------------------------------------------------------------
# Namespace definition

namespace eval ::simlib:: {
    variable library [file dirname [info script]]

    namespace import ::kiteutils::*
    namespace import ::marsutil::*
}

#-----------------------------------------------------------------------
# Load simlib(n) submodules

source [file join $::simlib::library simtypes.tcl]
source [file join $::simlib::library coverage.tcl]
source [file join $::simlib::library rmf.tcl     ]
source [file join $::simlib::library mam.tcl     ]
source [file join $::simlib::library uramdb.tcl  ]
source [file join $::simlib::library ucurve.tcl  ]
source [file join $::simlib::library uram.tcl    ]

