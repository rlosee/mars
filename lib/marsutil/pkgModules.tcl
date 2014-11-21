#-----------------------------------------------------------------------
# TITLE:
#    pkgModules.tcl
#
# PROJECT:
#    athena-mars
#
# DESCRIPTION:
#    marsutil(n) package modules file
#
#    Generated by Kite.
#-----------------------------------------------------------------------

#-----------------------------------------------------------------------
# Package Definition

# -kite-provide-start  DO NOT EDIT THIS BLOCK BY HAND
package provide marsutil 3.0.5
# -kite-provide-end

#-----------------------------------------------------------------------
# Required Packages

# -kite-require-start  REQUIRE EXTERNAL PACKAGES HERE
package require snit 2.3
package require sqlite3 3.8
package require comm 4.6
package require kiteutils 0.4.3

catch {
    # Marsbin isn't availble on all platforms.
    package require -exact Marsbin 3.0.5
}
# -kite-require-end

#-----------------------------------------------------------------------
# Namespace definition

namespace eval ::marsutil:: {
    variable library [file dirname [info script]]

    namespace import ::kiteutils::*
}

#-----------------------------------------------------------------------
# Modules

source [file join $::marsutil::library marsmisc.tcl       ]
source [file join $::marsutil::library logger.tcl         ]
source [file join $::marsutil::library logreader.tcl      ]
source [file join $::marsutil::library simclock.tcl       ]
source [file join $::marsutil::library zulu.tcl           ]
source [file join $::marsutil::library notifier.tcl       ]
source [file join $::marsutil::library enum.tcl           ]
source [file join $::marsutil::library quality.tcl        ]
source [file join $::marsutil::library range.tcl          ]
source [file join $::marsutil::library vec.tcl            ]
source [file join $::marsutil::library mat.tcl            ]
source [file join $::marsutil::library parmset.tcl        ]
source [file join $::marsutil::library commserver.tcl     ]
source [file join $::marsutil::library commclient.tcl     ]
source [file join $::marsutil::library gtclient.tcl       ]
source [file join $::marsutil::library gtserver.tcl       ]
source [file join $::marsutil::library zcurve.tcl         ]
source [file join $::marsutil::library sqlib.tcl          ]
source [file join $::marsutil::library sqldocument.tcl    ]
source [file join $::marsutil::library statecontroller.tcl]
source [file join $::marsutil::library timeout.tcl        ]
source [file join $::marsutil::library lazyupdater.tcl    ]
source [file join $::marsutil::library eventq.tcl         ]
source [file join $::marsutil::library cmdinfo.tcl        ]
source [file join $::marsutil::library tabletext.tcl      ]
source [file join $::marsutil::library cellmodel.tcl      ]
source [file join $::marsutil::library dynaform.tcl       ]
source [file join $::marsutil::library dynaform_fields.tcl]
source [file join $::marsutil::library order.tcl          ]
source [file join $::marsutil::library undostack.tcl      ]
source [file join $::marsutil::library gradient.tcl       ]
source [file join $::marsutil::library geometry.tcl       ]
source [file join $::marsutil::library geoset.tcl         ]
source [file join $::marsutil::library latlong.tcl        ]
source [file join $::marsutil::library mapref.tcl         ]
source [file join $::marsutil::library maprect.tcl        ]
