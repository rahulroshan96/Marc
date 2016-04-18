# use this script with command ns wireless3.tcl 12
if {$argc != 1} {
       error "\nCommand: ns wireless1.tcl <no.of.mobile-nodes>\n\n " 
}

# Define options
set val(chan) Channel/WirelessChannel    ;# channel type
set val(prop) Propagation/TwoRayGround   ;# radio-propagation model

set val(netif)          Phy/WirelessPhy            ;# network interface type
set val(mac)            Mac/802_11                 ;# MAC type
set val(ifq)            Queue/DropTail/PriQueue    ;# interface queue type
set val(ll)             LL                         ;# link layer type
set val(ant)            Antenna/OmniAntenna        ;# antenna model
set val(ifqlen)         50                         ;# max packet in ifq
set val(nn)             [lindex $argv 0]       ;# number of mobilenodes
set val(rp)             AODV                       ;# routing protocol
set val(x)              500   			   ;# X dimension of topography
set val(y)              400   			   ;# Y dimension of topography  
set val(stop)		10.0			   ;# time of simulation end


#-------Event scheduler object creation--------#

set ns              [new Simulator]

#creating the trace file and nam file

set tracefd       [open wireless1.tr w]
set namtrace      [open wireless1.nam w]   

$ns trace-all $tracefd
$ns namtrace-all-wireless $namtrace $val(x) $val(y)

# set up topography object
set topo [new Topography]

$topo load_flatgrid $val(x) $val(y)

set god_ [create-god $val(nn)]

# configure the nodes
        $ns node-config -adhocRouting $val(rp) \
                   -llType $val(ll) \
                   -macType $val(mac) \
                   -ifqType $val(ifq) \
                   -ifqLen $val(ifqlen) \
                   -antType $val(ant) \
                   -propType $val(prop) \
                   -phyType $val(netif) \
                   -channelType $val(chan) \
                   -topoInstance $topo \
                   -agentTrace ON \
                   -routerTrace ON \
                   -macTrace OFF \
                   -movementTrace ON
      
## Creating node objects..                
      for {set i 0} {$i < $val(nn) } { incr i } {
            set node_($i) [$ns node]      
      }
      for {set i 0} {$i < $val(nn) } {incr i } {
            $node_($i) color yellow
            $ns at 0.0 "$node_($i) color yellow"
      }
            
# Provide initial location of mobilenodes
$node_(0) set X_ 27.0
      $node_(0) set Y_ 260.0
      $node_(0) set Z_ 0.0

      $node_(1) set X_ 137.0
      $node_(1) set Y_ 348.0
      $node_(1) set Z_ 0.0

      $node_(2) set X_ 294.0
      $node_(2) set Y_ 235.0
      $node_(2) set Z_ 0.0

      $node_(3) set X_ 414.0
      $node_(3) set Y_ 342.0
      $node_(3) set Z_ 0.0

      $node_(4) set X_ 562.0
      $node_(4) set Y_ 267.0
      $node_(4) set Z_ 0.0

      $node_(5) set X_ 279.0
      $node_(5) set Y_ 447.0
      $node_(5) set Z_ 0.0

      $node_(6) set X_ -128.0
      $node_(6) set Y_ 260.0
      $node_(6) set Z_ 0.0

$node_(7) set X_ 727.0
$node_(7) set Y_ 269.0
$node_(7) set Z_ 0.0
      
$node_(8) set X_ 130.0
$node_(8) set Y_ 126.0
$node_(8) set Z_ 0.0

$node_(9) set X_ 318.0
$node_(9) set Y_ 45.0
$node_(9) set Z_ 0.0

$node_(10) set X_ 505.0
$node_(10) set Y_ 446.0
$node_(10) set Z_ 0.0

$node_(11) set X_ 421.0
$node_(11) set Y_ 158.0
$node_(11) set Z_ 0.0

 

# Define node initial position in nam
for {set i 0} {$i < $val(nn)} { incr i } {
# 30 defines the node size for nam
$ns initial_node_pos $node_($i) 30
}

# Telling nodes when the simulation ends
for {set i 0} {$i < $val(nn) } { incr i } {
    $ns at $val(stop) "$node_($i) reset";
}

# ending nam and the simulation 
$ns at $val(stop) "$ns nam-end-wireless $val(stop)"
$ns at $val(stop) "stop"
$ns at 10.01 "puts \"end simulation\" ; $ns halt"
proc stop {} {
    global ns tracefd namtrace
    $ns flush-trace
    close $tracefd
    close $namtrace
exec nam wireless1.nam &
}

$ns run
