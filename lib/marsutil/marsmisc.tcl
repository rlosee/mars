#-----------------------------------------------------------------------
# TITLE:
#   marsmisc.tcl
#
# PACKAGE:
#   marsutil(n) -- Tcl Utilities
#
# PROJECT:
#   Mars Simulation Infrastructure Library
#
# AUTHOR:
#   Will Duquette
#   Dave Jaffe
#   Jon Stinzel
#
# DESCRIPTION:
#   Mars: marsutil(n) Tcl Utilities
#
#   Miscellaneous commands
#
# TODO:
#
#   * marsmisc
#     * echo (define if undefined)
#     * gettimeofday
#     * hexquote
#     * let
#     * optval
#   * money
#     * commafmt
#     * moneyfmt
#     * moneyscan
#     * moneysort
#   * prob
#     * discrete
#     * pickfrom
#     * poisson
#   * regex
#     * stringToRegexp
#     * wildToRegexp
#   * valtype
#      * count => (used in shared/bsys.tcl)
#      * hexcolor
#      * identifier
#      * ipaddress
#      * restrict
#      * roundrange
#
#-----------------------------------------------------------------------

#-----------------------------------------------------------------------
# Exported commands

namespace eval ::marsutil:: {
    namespace export    \
        commafmt        \
        count           \
        discrete        \
        echo            \
        gettimeofday    \
        hexcolor        \
        hexquote        \
        identifier      \
        ipaddress       \
        let             \
        moneyfmt        \
        moneyscan       \
        moneysort       \
        optval          \
        percent         \
        pickfrom        \
        poisson         \
        roundrange      \
        restrict        \
        stringToRegexp  \
        wildToRegexp
}

#-----------------------------------------------------------------------
# Control Structures



# restrict varname vtype defval
#
# varname - A variable name
# vtype   - A validation type
# defval  - A default value
#
# Restricts the variable's value to belong to the validation type,
# without throwing an error.
#
# If the variable is not empty, and its value is valid,
# the variable is assigned the canonicalized value as returned by
# the validation type.  Otherwise, the variable is assigned the
# default value.

proc ::marsutil::restrict {varname vtype defval} {
    upvar 1 $varname value

    if {$value eq "" ||
        [catch { set value [{*}$vtype validate $value] }]
    } {
        set value $defval
    }

    return
}



#-----------------------------------------------------------------------
# Math functions

# let varname expression
#
# varname       A variable name
# expression    An [expr] expression
#
# Evaluates the expression and assigns the value to the variable.
# 
# NOTE: Marsbin defines this as a binary command.  Define it here
# only if the binary command doesn't exist.

if {[llength [info commands ::marsutil::let]] == 0} {

    proc ::marsutil::let {varname expression} {
        upvar $varname result
        set result [uplevel 1 [list expr $expression]]
    }

}

# roundrange min max
#
# Returns a range (rmin, rmax) no narrower than (min, max)
# where rmin is rounded down and rmax is rounded up a reasonable
# amount give the size of the interval.

proc roundrange {min max} {
    set unit [expr {10.0**round(log10($max - $min))}]
    set max  [expr {$unit * ceil($max/$unit)}]
    set min  [expr {$unit * floor($min/$unit)}]

    return [list $min $max]
}

# gettimeofday
#
# Returns the current wallclock seconds as a decimal value;
# however, the decimal will always be ".0".
#
# NOTE: Marsbin defines this as a binary command which
# returns fractional using gettimeofday(2).  Define it
# here only if the binary command doesn't exist.

if {[llength [info commands ::marsutil::gettimeofday]] == 0} {

    proc ::marsutil::gettimeofday {} {
        expr {double([clock seconds])}
    }

}

# percent frac
#
# frac       A fractional number, 0.0 to 1.0
#
# Displays the fraction as a percentage.  If the fraction
# is at least 0.005, displays it as an integer percentage, e.g.,
# 1%, 10%, 25%.  If the fraction is <= 0.005 but greater than
# 0.0, displays it as "~0%".

proc ::marsutil::percent {frac} {
    if {$frac == 0.0} {
        return "  0%"
    } elseif {$frac <= 0.005} {
        return " ~0%"
    } else {
        return [format "%3.0f%%" [expr {100.0 * $frac}]]
    }
}

# commafmt value
#
# value   A number
#
# Formats the integer part of the value with commas every three digits.

proc ::marsutil::commafmt {value args} {
    # FIRST, default number of decimal places to 0
    set places 0

    # NEXT, see what args
    while {[llength $args] > 0} {
        set opt [lshift args]

        switch -exact -- $opt {
            -places {
                set places [lshift args]
                if {$places < 0} {
                    error "Invalid value: \"$places\" should be > 0"
                }

                if {![string is integer -strict $places]} {
                    error "Invalid value: \"$places\" should be an integer "
                }
            }

            default {
                error "Invalid option: \"$opt\""
            }
        }
    }

    # NEXT, save the sign.
    if {$value < 0} {
        set sign "-"
    } else {
        set sign ""
    }

    # NEXT, get the number of decimal places
    set fmtstr "%.$places"
    append fmtstr "f"

    lassign [split [format $fmtstr $value] .] whole dec

    # NEXT, round to the nearest integer, remove the sign, and
    # convert to a list for easy processing. tcl::mathfunc::wide() 
    # limits the value returned by round to be less than 2**63
    set old [lreverse [split [expr {abs($whole)}] ""]]

    # NEXT, build up the new string with commas.
    set new [list]

    set count 0
    foreach digit $old {
        lappend new $digit
        incr count

        if {$count % 3 == 0} {
            lappend new ,
        }
    }

    if {[lindex $new end] eq ","} {
        set new [lrange $new 0 end-1]
    }

    set num [join [lreverse $new] ""] 

    if {$places > 0} {
        append num ".$dec"
    }

    return "$sign$num"
}

# moneyfmt value
#
# value   A numeric value
#
# Formats value so that it is no longer than 9 or 10 characters:
# This is intended for display of data that can span a wide range
# of values (e.g., pennies to trillions of dollars).
#
# The formats are as follows:
#
# 0.00 to 999.99
# 1,000.00 to 9,999.99
# 10,000 to 999,999
# 1.000M to 999.999M
# 1.000B to 999.999B
# 1.000T and up
# 
proc ::marsutil::moneyfmt {value} {
    # FIRST, save the sign
    if {$value < 0} {
        set sign "-"
        set value [expr {abs($value)}]
    } else {
        set sign ""
    }

    # NEXT, handle small numbers
    if {$value < 1000.0} {
        return [format "%s%.2f" $sign $value]
    }

    # NEXT, get pennies
    if {$value < 10000} {
        return $sign[commafmt $value -places 2]
    }

    if {$value < 1e6} {
        return $sign[commafmt $value]
    } elseif {$value < 1e9} {
        set value [expr {$value / 1.0e6}]
        return [format "%s%.3fM" $sign $value]
    } elseif {$value < 1e12} {
        set value [expr {$value / 1.0e9}]
        return [format "%s%.3fB" $sign $value]
    } else {
        set value [expr {$value / 1.0e12}]
        return [format "%s%.3fT" $sign $value]
    }
}

# moneyscan value
#
# value    A formatted number, as returned by moneyfmt.
#
# Converts the number to a normal real number.  If the value
# cannot be converted, throws INVALID.

proc ::marsutil::moneyscan {value} {
    array set factor {
        "" 1.0
        K  1e3
        M  1e6
        B  1e9
        T  1e12
    }

    # FIRST, Get rid of whitespace and commas
    set value [string map [list , "" \n "" \t "" " " ""] $value]

    set lastchar [string toupper [string index $value end]]

    if {$lastchar in {"K" "M" "B" "T"}} {
        set value [string range $value 0 end-1]
    } else {
        set lastchar ""
    }

    if {![string is double -strict $value]} {
        return -code error -errorcode INVALID "Invalid input: \"$value\""
    }

    # NEXT, handle leading zeroes
    if {[string is integer $value] && $value != 0} {
        set value [string trimleft $value "0"]
    }

    return [expr {$value * $factor($lastchar)}]
}

# moneysort a b
#
# a      A value formatted by moneyfmt
# b      A value formatted by moneyfmt
#
# Returns -1 if a < b, 0 if a == b, and 1 if a > b

proc ::marsutil::moneysort {a b} {
    set a [moneyscan $a]
    set b [moneyscan $b]

    if {$a < $b} {
        return -1
    } elseif {$a > $b} {
        return 1
    } else {
        return 0
    }
}

# pickfrom list
#
# list    A list
#
# Pick a random item from the list, and returns it.

proc ::marsutil::pickfrom {list} {
    lindex $list [expr {int(rand()*[llength $list])}]
}

# discrete vec
#
# vec       A vector of probabilities summing to 1.0
#
# Does a random draw for the vector of probabilities, returning an
# integer number n where 0 <= n < [llength $vec].

proc ::marsutil::discrete {vec} {
    # FIRST, get a uniform(0,1) value
    let u {rand()}

    # NEXT, find the matching value, using the CDF.
    set sum 0.0

    set len [llength $vec]

    for {set i 0} {$i < $len} {incr i} {
        let sum {$sum + [lindex $vec $i]}

        if {$u <= $sum} {
            return $i
        }
    }

    # NEXT, we shouldn't get here...but if we do, we want the
    # last bin anyway.
    return [expr {$len - 1}]
}

# poisson rate
#
# rate    The Poisson rate, events per unit of time
#
# Does a random draw, returning the number of events in one unit of time.

proc ::marsutil::poisson {rate} {
    # FIRST, generate a Uniform(0,1) value
    let T {rand()}

    # NEXT, prepare for the loop:
    set N 0
    let P {exp(-$rate)}
    set Sum $P

    while {$Sum < $T} {
        incr N
        let P {$P * $rate/$N}
        let Sum {$Sum + $P}
    }
    
    return $N
}

#-----------------------------------------------------------------------
# String functions

namespace eval ::marsutil:: {
    variable hexquoteMap \
        [list \
             \x00 {\x00} \x01 {\x01} \x02 {\x02} \x03 {\x03} \
             \x04 {\x04} \x05 {\x05} \x06 {\x06} \x07 {\x07} \
             \x08 {\x08} \x09 {\x09} \x0A {\x0A} \x0B {\x0B} \
             \x0C {\x0C} \x0D {\x0D} \x0E {\x0E} \x0F {\x0F} \
             \x10 {\x10} \x11 {\x11} \x12 {\x12} \x13 {\x13} \
             \x14 {\x14} \x15 {\x15} \x16 {\x16} \x17 {\x17} \
             \x18 {\x18} \x19 {\x19} \x1A {\x1A} \x1B {\x1B} \
             \x1C {\x1C} \x1D {\x1D} \x1E {\x1E} \x1F {\x1F} \
             \x20 {\x20} \x21 {\x21} \x22 {\x22} \x23 {\x23} \
             \x24 {\x24} \x25 {\x25} \x26 {\x26} \x27 {\x27} \
             \x28 {\x28} \x29 {\x29} \x2A {\x2A} \x2B {\x2B} \
             \x2C {\x2C} \x2D {\x2D} \x2E {\x2E} \x2F {\x2F} \
             \x30 {\x30} \x31 {\x31} \x32 {\x32} \x33 {\x33} \
             \x34 {\x34} \x35 {\x35} \x36 {\x36} \x37 {\x37} \
             \x38 {\x38} \x39 {\x39} \x3A {\x3A} \x3B {\x3B} \
             \x3C {\x3C} \x3D {\x3D} \x3E {\x3E} \x3F {\x3F} \
             \x40 {\x40} \x41 {\x41} \x42 {\x42} \x43 {\x43} \
             \x44 {\x44} \x45 {\x45} \x46 {\x46} \x47 {\x47} \
             \x48 {\x48} \x49 {\x49} \x4A {\x4A} \x4B {\x4B} \
             \x4C {\x4C} \x4D {\x4D} \x4E {\x4E} \x4F {\x4F} \
             \x50 {\x50} \x51 {\x51} \x52 {\x52} \x53 {\x53} \
             \x54 {\x54} \x55 {\x55} \x56 {\x56} \x57 {\x57} \
             \x58 {\x58} \x59 {\x59} \x5A {\x5A} \x5B {\x5B} \
             \x5C {\x5C} \x5D {\x5D} \x5E {\x5E} \x5F {\x5F} \
             \x60 {\x60} \x61 {\x61} \x62 {\x62} \x63 {\x63} \
             \x64 {\x64} \x65 {\x65} \x66 {\x66} \x67 {\x67} \
             \x68 {\x68} \x69 {\x69} \x6A {\x6A} \x6B {\x6B} \
             \x6C {\x6C} \x6D {\x6D} \x6E {\x6E} \x6F {\x6F} \
             \x70 {\x70} \x71 {\x71} \x72 {\x72} \x73 {\x73} \
             \x74 {\x74} \x75 {\x75} \x76 {\x76} \x77 {\x77} \
             \x78 {\x78} \x79 {\x79} \x7A {\x7A} \x7B {\x7B} \
             \x7C {\x7C} \x7D {\x7D} \x7E {\x7E} \x7F {\x7F} \
             \x80 {\x80} \x81 {\x81} \x82 {\x82} \x83 {\x83} \
             \x84 {\x84} \x85 {\x85} \x86 {\x86} \x87 {\x87} \
             \x88 {\x88} \x89 {\x89} \x8A {\x8A} \x8B {\x8B} \
             \x8C {\x8C} \x8D {\x8D} \x8E {\x8E} \x8F {\x8F} \
             \x90 {\x90} \x91 {\x91} \x92 {\x92} \x93 {\x93} \
             \x94 {\x94} \x95 {\x95} \x96 {\x96} \x97 {\x97} \
             \x98 {\x98} \x99 {\x99} \x9A {\x9A} \x9B {\x9B} \
             \x9C {\x9C} \x9D {\x9D} \x9E {\x9E} \x9F {\x9F} \
             \xA0 {\xA0} \xA1 {\xA1} \xA2 {\xA2} \xA3 {\xA3} \
             \xA4 {\xA4} \xA5 {\xA5} \xA6 {\xA6} \xA7 {\xA7} \
             \xA8 {\xA8} \xA9 {\xA9} \xAA {\xAA} \xAB {\xAB} \
             \xAC {\xAC} \xAD {\xAD} \xAE {\xAE} \xAF {\xAF} \
             \xB0 {\xB0} \xB1 {\xB1} \xB2 {\xB2} \xB3 {\xB3} \
             \xB4 {\xB4} \xB5 {\xB5} \xB6 {\xB6} \xB7 {\xB7} \
             \xB8 {\xB8} \xB9 {\xB9} \xBA {\xBA} \xBB {\xBB} \
             \xBC {\xBC} \xBD {\xBD} \xBE {\xBE} \xBF {\xBF} \
             \xC0 {\xC0} \xC1 {\xC1} \xC2 {\xC2} \xC3 {\xC3} \
             \xC4 {\xC4} \xC5 {\xC5} \xC6 {\xC6} \xC7 {\xC7} \
             \xC8 {\xC8} \xC9 {\xC9} \xCA {\xCA} \xCB {\xCB} \
             \xCC {\xCC} \xCD {\xCD} \xCE {\xCE} \xCF {\xCF} \
             \xD0 {\xD0} \xD1 {\xD1} \xD2 {\xD2} \xD3 {\xD3} \
             \xD4 {\xD4} \xD5 {\xD5} \xD6 {\xD6} \xD7 {\xD7} \
             \xD8 {\xD8} \xD9 {\xD9} \xDA {\xDA} \xDB {\xDB} \
             \xDC {\xDC} \xDD {\xDD} \xDE {\xDE} \xDF {\xDF} \
             \xE0 {\xE0} \xE1 {\xE1} \xE2 {\xE2} \xE3 {\xE3} \
             \xE4 {\xE4} \xE5 {\xE5} \xE6 {\xE6} \xE7 {\xE7} \
             \xE8 {\xE8} \xE9 {\xE9} \xEA {\xEA} \xEB {\xEB} \
             \xEC {\xEC} \xED {\xED} \xEE {\xEE} \xEF {\xEF} \
             \xF0 {\xF0} \xF1 {\xF1} \xF2 {\xF2} \xF3 {\xF3} \
             \xF4 {\xF4} \xF5 {\xF5} \xF6 {\xF6} \xF7 {\xF7} \
             \xF8 {\xF8} \xF9 {\xF9} \xFA {\xFA} \xFB {\xFB} \
             \xFC {\xFC} \xFD {\xFD} \xFE {\xFE} \xFF {\xFF} ]
}

# hexquote text
#
# text           A text string
#
# Quotes all characters in the string in \xNN format.  This is 
# useful for turning binary strings into printable strings.

proc ::marsutil::hexquote {text} {
    string map $::marsutil::hexquoteMap $text
}


# wildToRegexp pattern
# 
# Converts a wildcard match pattern to a regular expression.  Returns
# the converted pattern.

proc ::marsutil::wildToRegexp {pattern} {

    # Neutralize regexp/grep significant characters.
    regsub -all -- {[\\]}  $pattern  &&   pattern
    regsub -all -- {[.]}   $pattern  {\.} pattern
    regsub -all -- {[+]}   $pattern  {\+} pattern
    regsub -all -- {[(]}   $pattern  {\(} pattern
    regsub -all -- {[)]}   $pattern  {\)} pattern
    regsub -all -- {[|]}   $pattern  {\|} pattern
    regsub -all -- {\^}    $pattern  {\^} pattern
    regsub -all -- {[$]}   $pattern  {\$} pattern   
    regsub -all -- {[[]}   $pattern  {\[} pattern
    regsub -all -- {[]]}   $pattern  {\]} pattern

    # Make wildcard to regexp substitutions.  These must be done last or "."s
    # will be substituted with "\."s.
    regsub -all -- {[?]}   $pattern  {.}  pattern
    regsub -all -- {[*]}   $pattern  {.*} pattern
	
    return $pattern    
}

# stringToRegexp pattern
#
# Converts a normal string to a regular expression by inserting "\"s 
# before all regexp/grep significant characters.

proc ::marsutil::stringToRegexp {pattern} {

    # Neutralize all regexp sigificant characters.
    regsub -all -- {[\\]}  $string  &&   string  
    regsub -all -- {[.]}   $string  {\.} string    
    regsub -all -- {[+]}   $string  {\+} string    
    regsub -all -- {[?]}   $string  {\?} string    
    regsub -all -- {[(]}   $string  {\(} string    
    regsub -all -- {[)]}   $string  {\)} string    
    regsub -all -- {[|]}   $string  {\|} string    
    regsub -all -- {\^}    $string  {\^} string    
    regsub -all -- {[$]}   $string  {\$} string    
    regsub -all -- {[*]}   $string  {\*} string    
    regsub -all -- {[[]}   $string  {\[} string    
    regsub -all -- {[]]}   $string  {\]} string    

    return $string    
}

# optval argvar option ?defvalue?
#
# Looks for the named option in the named variable.  If found,
# it and its value are removed from the list, and the value
# is returned.  Otherwise, the default value is returned.

proc ::marsutil::optval {argvar option {defvalue ""}} {
    upvar $argvar argv

    set ioption [lsearch -exact $argv $option]

    if {$ioption == -1} {
        return $defvalue
    }

    set ivalue [expr {$ioption + 1}]
    set value [lindex $argv $ivalue]
    
    set argv [lreplace $argv $ioption $ivalue] 

    return $value
}


# echo  args
# 
# args  Some arguments to be sent to stdout
#
# Takes the supplied args and calls puts with them as the
# argument

proc ::marsutil::echo {args} {
    puts $args
}


#-------------------------------------------------------------------
# Type-Definition Ensembles
#
# The following are snit type-definition types.

# identifier: a name consisting of names, letters, and underscores

snit::stringtype ::marsutil::identifier \
    -regexp {^[0-9A-Za-z_]+$}


# ipaddress: An IP Address

snit::type ::marsutil::ipaddress {
    pragma -hastypedestroy 0 -hasinstances 0 -hastypeinfo 0
        
    typemethod validate {value} {
        if {![regexp {^\d+\.\d+\.\d+\.\d+$} $value]} {
            error "invalid value \"$value\", not an IP address"
        }

        foreach num [split $value "."] { 
            if {![string is integer -strict $num]
                || $num < 0
                || $num > 255} {
                error "invalid value \"$value\", not an IP address"
            }
        }
    }
}


# count: a non-negative integer

snit::integer ::marsutil::count \
    -min 0

# a 24bit RGB hexadecimal color string: "#RRGGBB"
snit::type ::marsutil::hexcolor {
    # Make it a singleton
    pragma -hasinstances no

    #-------------------------------------------------------------------
    # Public Type Methods

    # validate color
    #
    # color    A Tk color spec
    #
    # Validates the color using [winfo rgb], and converts the result
    # to a 24-bit hex color string.

    typemethod validate {value} {
        set value [string toupper $value]
        set len [string length $value]

        if {[regexp {^#[[:xdigit:]]+$} $value] &&
            ($len == 7 || $len == 13)
        } {
            return $value
        }

        return -code error -errorcode INVALID \
            "Invalid hex color specifier, should be \"#RRGGBB\" or \"#RRRRGGGGBBBB\""
    }
}



