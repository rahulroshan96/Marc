# Copyright (c) 1997 Regents of the University of California.
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
# 3. All advertising materials mentioning features or use of this software
#    must display the following acknowledgement:
#      This product includes software developed by the Computer Systems
#      Engineering Group at Lawrence Berkeley Laboratory.
# 4. Neither the name of the University nor of the Laboratory may be used
#    to endorse or promote products derived from this software without
#    specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ``AS IS'' AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED.  IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
# OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
# HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
# LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
# OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
# SUCH DAMAGE.
#
# simple-wireless.tcl
# A simple example for wireless simulation
# THIS FILE IS THE BY DEFAULT FILE FOR WIRELESS SIMULATION
# ======================================================================
# Define options
# ======================================================================
# Define options
set val(chan)           Channel/WirelessChannel    ;# channel type
set val(prop)           Propagation/TwoRayGround   ;# radio-propagation model
set val(netif1)          Phy/WirelessPhy            ;# network interface type
set val(netif2)          Phy/WirelessPhy            ;# network interface type
set val(mac)            Mac/802_11                 ;# MAC type
set val(ifq)            Queue/DropTail/PriQueue    ;# interface queue type
set val(ll)             LL                         ;# link layer type
set val(ant)            Antenna/OmniAntenna        ;# antenna model
set val(ifqlen)         50                         ;# max packet in ifq
set val(nn)             10                      ;# number of mobilenodes
set val(rp)             AODV                       ;# routing protocol
set val(x)              600   			   ;# X dimension of topography
set val(y)              600   			   ;# Y dimension of topography  
set val(stop)		10.0			   ;# time of simulation end
set val(energymodel)    EnergyModel			;#Energy set up


# ======================================================================
# Main Program
# ======================================================================


#
# Initialize Global Variables
#
set ns		[new Simulator]
set namtrace      [open wireless1.nam w] 
set tracefd     [open simple.tr w]
$ns trace-all $tracefd
$ns namtrace-all-wireless $namtrace 500 500

# set up topography object
set topo       [new Topography]

$topo load_flatgrid 500 500

#
# Create God
#
create-god $val(nn)

#Transmission range setup

#**********************************       UNITY GAIN, 1.5m HEIGHT OMNI DIRECTIONAL ANTENNA SET UP      **************

Antenna/OmniAntenna set X_ 0
Antenna/OmniAntenna set Y_ 0
Antenna/OmniAntenna set Z_ 1.5
Antenna/OmniAntenna set Gt_ 1.0
Antenna/OmniAntenna set Gr_ 1.0



#**********************************     SET UP COMMUNICATION AND SENSING RANGE       ***********************************

#default communication range 250m

# Initialize the SharedMedia interface with parameters to make
# it work like the 914MHz Lucent WaveLAN DSSS radio interface
$val(netif1) set CPThresh_ 10.0
$val(netif1) set CSThresh_ 2.28289e-11  ;#sensing range of 500m
$val(netif1) set RXThresh_ 2.28289e-11  ;#communication range of 500m
$val(netif1) set Rb_ 2*1e6
$val(netif1) set Pt_ 0.2818
$val(netif1) set freq_ 914e+6 
$val(netif1) set L_ 1.0

# Initialize the SharedMedia interface with parameters to make
# it work like the 914MHz Lucent WaveLAN DSSS radio interface
$val(netif2) set CPThresh_ 10.0
$val(netif2) set CSThresh_ 8.91754e-10  ;#sensing range of 200m
$val(netif2) set RXThresh_ 8.91754e-10  ;#communication range of 200m
$val(netif2) set Rb_ 2*1e6
$val(netif2) set Pt_ 0.2818
$val(netif2) set freq_ 914e+6 
$val(netif2) set L_ 1.0

#
#  Create the specified number of mobilenodes [$val(nn)] and "attach" them
#  to the channel. 
#  Here two nodes are created : node(0) and node(1)

# configure the first 5 nodes with transmission range of 500m 

        $ns node-config -adhocRouting $val(rp) \
			 -llType $val(ll) \
			 -macType $val(mac) \
			 -ifqType $val(ifq) \
			 -ifqLen $val(ifqlen) \
			 -antType $val(ant) \
			 -propType $val(prop) \
			 -phyType $val(netif1) \
			 -channelType $val(chan) \
			 -topoInstance $topo \
                   -energyModel $val(energymodel) \
			 -initialEnergy 10 \
                   -rxPower 0.5 \
			 -txPower 1.0 \
                   -idlePower 0.0 \
			 -sensePower 0.3 \
			 -agentTrace ON \
			 -routerTrace ON \
			 -macTrace OFF \
			 -movementTrace ON			
			 
	for {set i 0} {$i < $val(nn) } {incr i} {
		set node_($i) [$ns node]	
		$node_($i) random-motion 0		;# disable random motion
	}

set energy(0) 1000

$ns node-config -initialEnergy 1000 \
                -rxPower 0.5 \
		    -txPower 1.0 \
                -idlePower 0.0 \
		    -sensePower 0.3 

	set node_(0) [$ns node]
	$node_(0) color black


# configure the remaining 5 nodes with transmission range of 200m 

        $ns node-config -adhocRouting $val(rp) \
			 -llType $val(ll) \
			 -macType $val(mac) \
			 -ifqType $val(ifq) \
			 -ifqLen $val(ifqlen) \
			 -antType $val(ant) \
			 -propType $val(prop) \
			 -phyType $val(netif2) \
			 -channelType $val(chan) \
			 -topoInstance $topo \
                   -energyModel $val(energymodel) \
			 -initialEnergy 10 \
                   -rxPower 0.5 \
			 -txPower 1.0 \
                   -idlePower 0.0 \
			 -sensePower 0.3 \
			 -agentTrace ON \
			 -routerTrace ON \
			 -macTrace OFF \
			 -movementTrace ON


for {set i 1} {$i < 3} {incr i} {

set energy($i) [expr rand()*500]

$ns node-config -initialEnergy $energy($i) \
                -rxPower 0.5 \
		    -txPower 1.0 \
                -idlePower 0.0 \
		    -sensePower 0.3 


	set node_($i) [$ns node]
	$node_($i) color black
}


#
# Provide initial (X,Y, for now Z=0) co-ordinates for mobilenodes
#
$node_(0) set X_ 5.0
$node_(0) set Y_ 2.0
$node_(0) set Z_ 0.0

$node_(1) set X_ 390.0
$node_(1) set Y_ 385.0
$node_(1) set Z_ 0.0

#
# Now produce some simple node movements
# Node_(1) starts to move towards node_(0)
#
$ns at 50.0 "$node_(1) setdest 25.0 20.0 15.0"
$ns at 10.0 "$node_(0) setdest 20.0 18.0 1.0"

# Node_(1) then starts to move away from node_(0)
$ns at 100.0 "$node_(1) setdest 490.0 480.0 15.0" 

# Setup traffic flow between nodes
# TCP connections between node_(0) and node_(1)

set tcp [new Agent/TCP]
$tcp set class_ 2
set sink [new Agent/TCPSink]
$ns attach-agent $node_(0) $tcp
$ns attach-agent $node_(1) $sink
$ns connect $tcp $sink
set ftp [new Application/FTP]
$ftp attach-agent $tcp
$ns at 10.0 "$ftp start" 

#
# Tell nodes when the simulation ends
#
for {set i 0} {$i < $val(nn) } {incr i} {
    $ns at 150.0 "$node_($i) reset";
}
$ns at 150.0 "stop"
$ns at 150.01 "puts \"NS EXITING...\" ; $ns halt"
proc stop {} {
    global ns tracefd
    $ns flush-trace
    close $tracefd
	exec nam wireless1.nam &
	exit 0
}

puts "Starting Simulation..."
$ns run

