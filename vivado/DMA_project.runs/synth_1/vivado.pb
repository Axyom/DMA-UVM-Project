
u
Command: %s
53*	vivadotcl2D
Bsynth_design -top axi_lite_reg_interface -part xazu1eg-sbva484-1-iZ4-113h px� 
:
Starting synth_design
149*	vivadotclZ4-321h px� 
z
@Attempting to get a license for feature '%s' and/or device '%s'
308*common2
	Synthesis2	
xazu1egZ17-347h px� 
j
0Got license for feature '%s' and/or device '%s'
310*common2
	Synthesis2	
xazu1egZ17-349h px� 
o
HMultithreading enabled for synth_design using a maximum of %s processes.4828*oasys2
2Z8-7079h px� 
a
?Launching helper process for spawning children vivado processes4827*oasysZ8-7078h px� 
N
#Helper process launched with PID %s4824*oasys2
13892Z8-7075h px� 
�
%s*synth2u
sStarting Synthesize : Time (s): cpu = 00:00:02 ; elapsed = 00:00:04 . Memory (MB): peak = 817.734 ; gain = 477.676
h px� 
�
synthesizing module '%s'638*oasys2
axi_lite_reg_interface2W
SC:/Users/Axyom/Documents/Projets Pro/DMA-UVM-Project/rtl/axi_lite_reg_interface.vhd2
548@Z8-638h px� 
�
default block is never used226*oasys2W
SC:/Users/Axyom/Documents/Projets Pro/DMA-UVM-Project/rtl/axi_lite_reg_interface.vhd2
1028@Z8-226h px� 
�
%done synthesizing module '%s' (%s#%s)256*oasys2
axi_lite_reg_interface2
02
12W
SC:/Users/Axyom/Documents/Projets Pro/DMA-UVM-Project/rtl/axi_lite_reg_interface.vhd2
548@Z8-256h px� 
v
+design %s has port %s driven by constant %s3447*oasys2
axi_lite_reg_interface2
RVALID2
0Z8-3917h px� 
�
9Port %s in module %s is either unconnected or has no load4866*oasys2
	AWADDR[2]2
axi_lite_reg_interfaceZ8-7129h px� 
�
9Port %s in module %s is either unconnected or has no load4866*oasys2
	AWADDR[1]2
axi_lite_reg_interfaceZ8-7129h px� 
�
9Port %s in module %s is either unconnected or has no load4866*oasys2
	AWADDR[0]2
axi_lite_reg_interfaceZ8-7129h px� 
�
9Port %s in module %s is either unconnected or has no load4866*oasys2
	ARADDR[2]2
axi_lite_reg_interfaceZ8-7129h px� 
�
9Port %s in module %s is either unconnected or has no load4866*oasys2
	ARADDR[1]2
axi_lite_reg_interfaceZ8-7129h px� 
�
9Port %s in module %s is either unconnected or has no load4866*oasys2
	ARADDR[0]2
axi_lite_reg_interfaceZ8-7129h px� 
�
%s*synth2u
sFinished Synthesize : Time (s): cpu = 00:00:03 ; elapsed = 00:00:06 . Memory (MB): peak = 931.848 ; gain = 591.789
h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
�
%s*synth2�
~Finished Constraint Validation : Time (s): cpu = 00:00:03 ; elapsed = 00:00:06 . Memory (MB): peak = 931.848 ; gain = 591.789
h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
D
%s
*synth2,
*Start Loading Part and Timing Information
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
<
%s
*synth2$
"Loading part: xazu1eg-sbva484-1-i
h p
x
� 
B
 Reading net delay rules and data4578*oasysZ8-6742h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
H
Loading part %s157*device2
xazu1eg-sbva484-1-iZ21-403h px� 
�
%s*synth2�
�Finished Loading Part and Timing Information : Time (s): cpu = 00:00:03 ; elapsed = 00:00:06 . Memory (MB): peak = 931.848 ; gain = 591.789
h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
z
3inferred FSM for state register '%s' in module '%s'802*oasys2
	state_reg2
axi_lite_reg_interfaceZ8-802h px� 
~
%s
*synth2f
d---------------------------------------------------------------------------------------------------
h p
x
� 
z
%s
*synth2b
`                   State |                     New Encoding |                Previous Encoding 
h p
x
� 
~
%s
*synth2f
d---------------------------------------------------------------------------------------------------
h p
x
� 
y
%s
*synth2a
_                    idle |                               00 |                               00
h p
x
� 
y
%s
*synth2a
_              write_data |                               01 |                               01
h p
x
� 
y
%s
*synth2a
_              write_resp |                               10 |                               10
h p
x
� 
y
%s
*synth2a
_               read_data |                               11 |                               11
h p
x
� 
~
%s
*synth2f
d---------------------------------------------------------------------------------------------------
h p
x
� 
�
Gencoded FSM with state register '%s' using encoding '%s' in module '%s'3353*oasys2
	state_reg2

sequential2
axi_lite_reg_interfaceZ8-3354h px� 
�
!inferring latch for variable '%s'327*oasys2
address_next_reg2W
SC:/Users/Axyom/Documents/Projets Pro/DMA-UVM-Project/rtl/axi_lite_reg_interface.vhd2
828@Z8-327h px� 
�
!inferring latch for variable '%s'327*oasys2
	RDATA_reg2W
SC:/Users/Axyom/Documents/Projets Pro/DMA-UVM-Project/rtl/axi_lite_reg_interface.vhd2
1428@Z8-327h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
�
%s*synth2�
�Finished RTL Optimization Phase 2 : Time (s): cpu = 00:00:04 ; elapsed = 00:00:07 . Memory (MB): peak = 931.848 ; gain = 591.789
h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
:
%s
*synth2"
 Start RTL Component Statistics 
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
9
%s
*synth2!
Detailed RTL Component Info : 
h p
x
� 
+
%s
*synth2
+---Registers : 
h p
x
� 
H
%s
*synth20
.	               32 Bit    Registers := 6     
h p
x
� 
H
%s
*synth20
.	               29 Bit    Registers := 1     
h p
x
� 
'
%s
*synth2
+---Muxes : 
h p
x
� 
F
%s
*synth2.
,	   2 Input   32 Bit        Muxes := 14    
h p
x
� 
F
%s
*synth2.
,	   4 Input   32 Bit        Muxes := 7     
h p
x
� 
F
%s
*synth2.
,	   2 Input   29 Bit        Muxes := 1     
h p
x
� 
F
%s
*synth2.
,	   2 Input    8 Bit        Muxes := 24    
h p
x
� 
F
%s
*synth2.
,	   2 Input    2 Bit        Muxes := 4     
h p
x
� 
F
%s
*synth2.
,	   4 Input    2 Bit        Muxes := 3     
h p
x
� 
F
%s
*synth2.
,	   2 Input    1 Bit        Muxes := 1     
h p
x
� 
F
%s
*synth2.
,	   4 Input    1 Bit        Muxes := 7     
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
=
%s
*synth2%
#Finished RTL Component Statistics 
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
6
%s
*synth2
Start Part Resource Summary
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
q
%s
*synth2Y
WPart Resources:
DSPs: 216 (col length:72)
BRAMs: 216 (col length: RAMB18 72 RAMB36 36)
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
9
%s
*synth2!
Finished Part Resource Summary
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
E
%s
*synth2-
+Start Cross Boundary and Area Optimization
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
H
&Parallel synthesis criteria is not met4829*oasysZ8-7080h px� 
v
+design %s has port %s driven by constant %s3447*oasys2
axi_lite_reg_interface2
RVALID2
0Z8-3917h px� 
�
9Port %s in module %s is either unconnected or has no load4866*oasys2
	AWADDR[2]2
axi_lite_reg_interfaceZ8-7129h px� 
�
9Port %s in module %s is either unconnected or has no load4866*oasys2
	AWADDR[1]2
axi_lite_reg_interfaceZ8-7129h px� 
�
9Port %s in module %s is either unconnected or has no load4866*oasys2
	AWADDR[0]2
axi_lite_reg_interfaceZ8-7129h px� 
�
9Port %s in module %s is either unconnected or has no load4866*oasys2
	ARADDR[2]2
axi_lite_reg_interfaceZ8-7129h px� 
�
9Port %s in module %s is either unconnected or has no load4866*oasys2
	ARADDR[1]2
axi_lite_reg_interfaceZ8-7129h px� 
�
9Port %s in module %s is either unconnected or has no load4866*oasys2
	ARADDR[0]2
axi_lite_reg_interfaceZ8-7129h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
�
%s*synth2�
�Finished Cross Boundary and Area Optimization : Time (s): cpu = 00:00:06 ; elapsed = 00:00:18 . Memory (MB): peak = 1264.285 ; gain = 924.227
h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
4
%s
*synth2
Start Timing Optimization
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
�
%s*synth2
}Finished Timing Optimization : Time (s): cpu = 00:00:06 ; elapsed = 00:00:18 . Memory (MB): peak = 1270.852 ; gain = 930.793
h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
3
%s
*synth2
Start Technology Mapping
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
�
%s*synth2~
|Finished Technology Mapping : Time (s): cpu = 00:00:06 ; elapsed = 00:00:18 . Memory (MB): peak = 1270.852 ; gain = 930.793
h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
-
%s
*synth2
Start IO Insertion
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
?
%s
*synth2'
%Start Flattening Before IO Insertion
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
B
%s
*synth2*
(Finished Flattening Before IO Insertion
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
6
%s
*synth2
Start Final Netlist Cleanup
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
9
%s
*synth2!
Finished Final Netlist Cleanup
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
�
%s*synth2y
wFinished IO Insertion : Time (s): cpu = 00:00:07 ; elapsed = 00:00:21 . Memory (MB): peak = 1423.910 ; gain = 1083.852
h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
=
%s
*synth2%
#Start Renaming Generated Instances
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
�
%s*synth2�
�Finished Renaming Generated Instances : Time (s): cpu = 00:00:07 ; elapsed = 00:00:21 . Memory (MB): peak = 1423.910 ; gain = 1083.852
h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
:
%s
*synth2"
 Start Rebuilding User Hierarchy
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
�
%s*synth2�
�Finished Rebuilding User Hierarchy : Time (s): cpu = 00:00:07 ; elapsed = 00:00:21 . Memory (MB): peak = 1423.910 ; gain = 1083.852
h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
9
%s
*synth2!
Start Renaming Generated Ports
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
�
%s*synth2�
�Finished Renaming Generated Ports : Time (s): cpu = 00:00:07 ; elapsed = 00:00:21 . Memory (MB): peak = 1423.910 ; gain = 1083.852
h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
;
%s
*synth2#
!Start Handling Custom Attributes
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
�
%s*synth2�
�Finished Handling Custom Attributes : Time (s): cpu = 00:00:07 ; elapsed = 00:00:21 . Memory (MB): peak = 1423.910 ; gain = 1083.852
h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
8
%s
*synth2 
Start Renaming Generated Nets
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
�
%s*synth2�
�Finished Renaming Generated Nets : Time (s): cpu = 00:00:07 ; elapsed = 00:00:21 . Memory (MB): peak = 1423.910 ; gain = 1083.852
h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
9
%s
*synth2!
Start Writing Synthesis Report
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
/
%s
*synth2

Report BlackBoxes: 
h p
x
� 
8
%s
*synth2 
+-+--------------+----------+
h p
x
� 
8
%s
*synth2 
| |BlackBox name |Instances |
h p
x
� 
8
%s
*synth2 
+-+--------------+----------+
h p
x
� 
8
%s
*synth2 
+-+--------------+----------+
h p
x
� 
/
%s*synth2

Report Cell Usage: 
h px� 
2
%s*synth2
+------+-------+------+
h px� 
2
%s*synth2
|      |Cell   |Count |
h px� 
2
%s*synth2
+------+-------+------+
h px� 
2
%s*synth2
|1     |BUFG   |     2|
h px� 
2
%s*synth2
|2     |CARRY8 |     4|
h px� 
2
%s*synth2
|3     |LUT1   |     3|
h px� 
2
%s*synth2
|4     |LUT2   |    50|
h px� 
2
%s*synth2
|5     |LUT3   |    37|
h px� 
2
%s*synth2
|6     |LUT4   |    11|
h px� 
2
%s*synth2
|7     |LUT5   |    48|
h px� 
2
%s*synth2
|8     |LUT6   |   122|
h px� 
2
%s*synth2
|9     |FDCE   |   223|
h px� 
2
%s*synth2
|10    |LD     |    61|
h px� 
2
%s*synth2
|11    |IBUF   |   103|
h px� 
2
%s*synth2
|12    |OBUF   |   139|
h px� 
2
%s*synth2
+------+-------+------+
h px� 
3
%s
*synth2

Report Instance Areas: 
h p
x
� 
<
%s
*synth2$
"+------+---------+-------+------+
h p
x
� 
<
%s
*synth2$
"|      |Instance |Module |Cells |
h p
x
� 
<
%s
*synth2$
"+------+---------+-------+------+
h p
x
� 
<
%s
*synth2$
"|1     |top      |       |   803|
h p
x
� 
<
%s
*synth2$
"+------+---------+-------+------+
h p
x
� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
�
%s*synth2�
�Finished Writing Synthesis Report : Time (s): cpu = 00:00:07 ; elapsed = 00:00:21 . Memory (MB): peak = 1423.910 ; gain = 1083.852
h px� 
l
%s
*synth2T
R---------------------------------------------------------------------------------
h p
x
� 
a
%s
*synth2I
GSynthesis finished with 0 errors, 0 critical warnings and 17 warnings.
h p
x
� 
�
%s
*synth2�
�Synthesis Optimization Runtime : Time (s): cpu = 00:00:07 ; elapsed = 00:00:21 . Memory (MB): peak = 1423.910 ; gain = 1083.852
h p
x
� 
�
%s
*synth2�
�Synthesis Optimization Complete : Time (s): cpu = 00:00:07 ; elapsed = 00:00:21 . Memory (MB): peak = 1423.910 ; gain = 1083.852
h p
x
� 
B
 Translating synthesized netlist
350*projectZ1-571h px� 
�
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2
Netlist sorting complete. 2

00:00:002
00:00:00.0062

1438.4612
0.000Z17-268h px� 
U
-Analyzing %s Unisim elements for replacement
17*netlist2
170Z29-17h px� 
X
2Unisim Transformation completed in %s CPU seconds
28*netlist2
0Z29-28h px� 
K
)Preparing netlist for logic optimization
349*projectZ1-570h px� 
Q
)Pushed %s inverter(s) to %s load pin(s).
98*opt2
02
0Z31-138h px� 
�
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2
Netlist sorting complete. 2

00:00:002
00:00:00.0012

1494.8752
0.000Z17-268h px� 
�
!Unisim Transformation Summary:
%s111*project2�
�  A total of 166 instances were transformed.
  BUFG => BUFGCE: 2 instances
  IBUF => IBUF (IBUFCTRL, INBUF): 103 instances
  LD => LDCE: 61 instances
Z1-111h px� 
V
%Synth Design complete | Checksum: %s
562*	vivadotcl2

dd98b8f3Z4-1430h px� 
C
Releasing license: %s
83*common2
	SynthesisZ17-83h px� 

G%s Infos, %s Warnings, %s Critical Warnings and %s Errors encountered.
28*	vivadotcl2
182
172
02
0Z4-41h px� 
L
%s completed successfully
29*	vivadotcl2
synth_designZ4-42h px� 
�
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2
synth_design: 2

00:00:082

00:00:232

1494.8752

1156.754Z17-268h px� 
�
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2
Write ShapeDB Complete: 2

00:00:002
00:00:00.0052

1494.8752
0.000Z17-268h px� 
�
 The %s '%s' has been generated.
621*common2

checkpoint2q
oC:/Users/Axyom/Documents/Projets Pro/DMA-UVM-Project/vivado/DMA_project.runs/synth_1/axi_lite_reg_interface.dcpZ17-1381h px� 
�
Executing command : %s
56330*	planAhead2w
ureport_utilization -file axi_lite_reg_interface_utilization_synth.rpt -pb axi_lite_reg_interface_utilization_synth.pbZ12-24828h px� 
\
Exiting %s at %s...
206*common2
Vivado2
Thu May 22 20:34:46 2025Z17-206h px� 


End Record