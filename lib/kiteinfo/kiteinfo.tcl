#-----------------------------------------------------------------------
# TITLE:
#   kiteinfo.tcl
#
# PROJECT:
#   athena-mars - Mars Simulation Support Library
#
# DESCRIPTION:
#   Kite: kiteinfo(n) Package
#
#   This package was auto-generated by Kite to provide the 
#   project athena-mars's code with access to the contents of its 
#   project.kite file at runtime.
#
#   Generated by Kite.
#-----------------------------------------------------------------------

namespace eval ::kiteinfo:: {
    variable kiteInfo

    array set kiteInfo {
        reqver-BWidget 1.9
        reqver-Tktable 2.11
        build-Marsbin {make -f MakeTEA clean all}
        clean-libGeotrans {make clean}
        binary-simlib 0
        binary-marsutil 0
        apptype-mars kit
        local-tablelist 0
        clean-Marsbin {make -f MakeTEA clean}
        build-libGeostars {make clean all}
        description {Mars Simulation Support Library}
        provides {marsutil marsgui simlib Marsbin}
        local-treectrl 0
        local-Img 0
        build-libTiff {make clean all}
        reqver-Tkhtml 3.0
        local-BWidget 0
        reqver-comm 4.6
        local-Tktable 0
        reqver-sqlite3 3.8
        clean-libGTiff {make clean}
        clean-libGeostars {make clean}
        reqver-kiteutils 0.4.0a0
        reqver-snit 2.3
        clean-libTiff {make clean}
        requires {snit sqlite3 comm Img BWidget treectrl tablelist Tktable Tkhtml kiteutils}
        shell {}
        distpat-install-win32-ix86 {
    README.md
    %apps
    %libs
    docs/*.html
    docs/man*/*.html
    %get {
        docs/mag.docx 
        https://pepper.jpl.nasa.gov/kite/xdocs/mars/3.0/mag-20140826.docx
    }
}
        name athena-mars
        binary-marsgui 0
        poc William.H.Duquette@jpl.nasa.gov
        srcs {libGeotrans libGeostars libTiff libGTiff Marsbin}
        local-Tkhtml 0
        local-comm 0
        build-libGTiff {make clean all}
        apps mars
        local-sqlite3 0
        gui-mars 0
        local-kiteutils 1
        reqver-tablelist 5.11
        local-snit 0
        binary-Marsbin 1
        version 3.0.2a0
        reqver-treectrl 2.4
        reqver-Img 1.4.1
        build-libGeotrans {make clean all}
        dists install-win32-ix86
    }

    namespace export \
        project      \
        version      \
        description  \
        includes     \
        gui          \
        require

    namespace ensemble create
}

#-----------------------------------------------------------------------
# Commands

# project
#
# Returns the project name.
# FIXME: should be kiteinfo(project) when project.tcl is updated.

proc ::kiteinfo::project {} {
    variable kiteInfo

    return $kiteInfo(name)
}

# version
#
# Returns the project version number.

proc ::kiteinfo::version {} {
    variable kiteInfo

    return $kiteInfo(version)
}

# description
#
# Returns the project description.

proc ::kiteinfo::description {} {
    variable kiteInfo

    return $kiteInfo(description)
}

# includes
#
# Returns the names of the "include" libraries.

proc ::kiteinfo::includes {} {
    variable kiteInfo

    return $kiteInfo(includes)
}

# gui app
#
# app  - An application name
#
# Returns 1 if the app is supposed to have a GUI, and 0 otherwise.

proc ::kiteinfo::gui {app} {
    variable kiteInfo

    return $kiteInfo(gui-$app)
}
