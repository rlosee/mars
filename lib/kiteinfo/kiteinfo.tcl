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
        require-kiteutils {version 0.1.2 local 1}
        require-snit {version 2.3 local 0}
        build-Marsbin {make -f MakeTEA clean all}
        clean-libGeotrans {make clean}
        apptype-mars kit
        binary-marsutil 0
        clean-Marsbin {make -f MakeTEA clean}
        build-libGeostars {make clean all}
        description {Mars Simulation Support Library}
        provides {marsutil marsgui Marsbin}
        build-libTiff {make clean all}
        require-tablelist {version 5.11 local 0}
        require-treectrl {version 2.4 local 0}
        require-Img {version 1.4.1-1.4.1 local 0}
        clean-libGTiff {make clean}
        clean-libGeostars {make clean}
        includes {}
        require-BWidget {version 1.9 local 0}
        clean-libTiff {make clean}
        pkgversion 3.0a4
        requires {snit sqlite3 comm Img BWidget treectrl tablelist Tktable Tkhtml kiteutils}
        shell {
    package require marsutil 3.0
    namespace import -force marsutil::*
}
        require-Tktable {version 2.11 local 0}
        name athena-mars
        binary-marsgui 0
        poc William.H.Duquette@jpl.nasa.gov
        srcs {libGeotrans libGeostars libTiff libGTiff Marsbin}
        build-libGTiff {make clean all}
        apps mars
        gui-mars 0
        require-Tkhtml {version 3.0 local 0}
        require-comm {version 4.6 local 0}
        binary-Marsbin 1
        version 3.0a4
        require-sqlite3 {version 3.8 local 0}
        build-libGeotrans {make clean all}
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

# require name
#
# name  - Name of a "require"'d teapot package.
#
# Does a Tcl [package require] on the given package, using the
# version specified by the "require" statement in project.kite.
#
# DEPRECATED

proc ::kiteinfo::require {name} {
    variable kiteInfo
    
    if {$name ni $kiteInfo(requires)} {
        error "unknown package name: \"$name\""
    }
    set version [dict get $kiteInfo(require-$name) version]
}
