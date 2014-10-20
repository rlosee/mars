#-----------------------------------------------------------------------
# TITLE:
#    pkgModules.tcl
#
# PROJECT:
#    athena-mars - Mars Simulation Support Library
#
# DESCRIPTION:
#    app_icons(n) package modules file
#
#    Generated by Kite.
#-----------------------------------------------------------------------

#-----------------------------------------------------------------------
# Package Definition

# -kite-provide-start  DO NOT EDIT THIS BLOCK BY HAND
package provide app_icons 3.0.2
# -kite-provide-end

#-----------------------------------------------------------------------
# Required Packages

# Add 'package require' statements for this package's external 
# dependencies to the following block.  Kite will update the versions 
# numbers automatically as they change in project.kite.

# -kite-require-start ADD EXTERNAL DEPENDENCIES
package require snit 2.3
package require kiteutils 0.4.3
package require -exact marsutil 3.0.2
package require -exact marsgui 3.0.2
# -kite-require-end

namespace import ::kiteutils::*
namespace import ::marsutil::*
namespace import ::marsgui::*


#-----------------------------------------------------------------------
# Namespace definition

namespace eval ::app_icons:: {
    variable library [file dirname [info script]]
}

#-----------------------------------------------------------------------
# Modules

source [file join $::app_icons::library app.tcl]
