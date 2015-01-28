#-----------------------------------------------------------------------
# TITLE:
#    pkgModules.tcl
#
# PROJECT:
#    athena-mars
#
# DESCRIPTION:
#    marsgui(n) package modules file
#
#    Generated by Kite.
#-----------------------------------------------------------------------

#-----------------------------------------------------------------------
# Package Definition

# -kite-provide-start  DO NOT EDIT THIS BLOCK BY HAND
package provide marsgui 3.0.9
# -kite-provide-end

#-----------------------------------------------------------------------
# Required Packages

# -kite-require-start  REQUIRE EXTERNAL PACKAGES HERE
package require Tk 8.6
package require snit 2.3
package require sqlite3 3.8
package require Img 1.4.1
package require BWidget 1.9
package require treectrl 2.4
package require tablelist 5.11
package require Tktable 2.11
package require Tkhtml 3.0
package require kiteutils 0.4.5
package require -exact marsutil 3.0.9
# -kite-require-end

#-----------------------------------------------------------------------
# Namespace and packages


namespace eval ::marsgui:: {
    variable library [file dirname [info script]]
    
    # Make marsutil calls visible in marsgui
    namespace import ::marsutil::*
}

source [file join $::marsgui::library global.tcl         ]
source [file join $::marsgui::library osgui.tcl          ]
source [file join $::marsgui::library mkicon.tcl         ]
source [file join $::marsgui::library marsicons.tcl      ]
source [file join $::marsgui::library cli.tcl            ]
source [file join $::marsgui::library cmdbrowser.tcl     ]
source [file join $::marsgui::library winbrowser.tcl     ]
source [file join $::marsgui::library modeditor.tcl      ]
source [file join $::marsgui::library debugger.tcl       ]
source [file join $::marsgui::library texteditor.tcl     ]
source [file join $::marsgui::library texteditorwin.tcl  ]
source [file join $::marsgui::library menubox.tcl        ]
source [file join $::marsgui::library messageline.tcl    ]
source [file join $::marsgui::library messagebox.tcl     ]
source [file join $::marsgui::library filter.tcl         ]
source [file join $::marsgui::library finder.tcl         ]
source [file join $::marsgui::library logdisplay.tcl     ]
source [file join $::marsgui::library commandentry.tcl   ]
source [file join $::marsgui::library loglist.tcl        ]
source [file join $::marsgui::library subwin.tcl         ]
source [file join $::marsgui::library rotext.tcl         ]
source [file join $::marsgui::library databrowser.tcl    ]
source [file join $::marsgui::library datagrid.tcl       ]
source [file join $::marsgui::library scrollinglog.tcl   ]
source [file join $::marsgui::library sqlbrowser.tcl     ]
source [file join $::marsgui::library querybrowser.tcl   ]
source [file join $::marsgui::library isearch.tcl        ]
source [file join $::marsgui::library hbarchart.tcl      ]
source [file join $::marsgui::library stripchart.tcl     ]
source [file join $::marsgui::library cmsheet.tcl        ]
source [file join $::marsgui::library colorfield.tcl     ]
source [file join $::marsgui::library dispfield.tcl      ]
source [file join $::marsgui::library enumfield.tcl      ]
source [file join $::marsgui::library keyfield.tcl       ]
source [file join $::marsgui::library listfield.tcl      ]
source [file join $::marsgui::library multifield.tcl     ]
source [file join $::marsgui::library newkeyfield.tcl    ]
source [file join $::marsgui::library rangefield.tcl     ]
source [file join $::marsgui::library textfield.tcl      ]
source [file join $::marsgui::library form.tcl           ]
source [file join $::marsgui::library mapcanvas.tcl      ]
source [file join $::marsgui::library order_dialog.tcl   ]
source [file join $::marsgui::library zcurvefield.tcl    ]
source [file join $::marsgui::library htmlviewer.tcl     ]
source [file join $::marsgui::library htmlframe.tcl      ]
source [file join $::marsgui::library dynaview.tcl       ]
source [file join $::marsgui::library dynabox.tcl        ]
source [file join $::marsgui::library checkfield.tcl     ]
