
�
No cells matched '%s'.
180*	planAhead2u
aget_cells -hierarchical -regexp -filter {REF_NAME=~JDY_ip_top_.* || ORIG_REF_NAME=~JDY_ip_top_.*}2default:defaultZ12-180h px� 
�
No cells matched '%s'.
180*	planAhead2�
mget_cells [get_cells -hierarchical -regexp -filter {REF_NAME=~JDY_ip_top_.* || ORIG_REF_NAME=~JDY_ip_top_.*}]2default:defaultZ12-180h px� 
O
Command: %s
53*	vivadotcl2

opt_design2default:defaultZ4-113h px� 
�
@Attempting to get a license for feature '%s' and/or device '%s'
308*common2"
Implementation2default:default2
	xc7vx690t2default:defaultZ17-347h px� 
�
0Got license for feature '%s' and/or device '%s'
310*common2"
Implementation2default:default2
	xc7vx690t2default:defaultZ17-349h px� 
n
,Running DRC as a precondition to command %s
22*	vivadotcl2

opt_design2default:defaultZ4-22h px� 
R

Starting %s Task
103*constraints2
DRC2default:defaultZ18-103h px� 
P
Running DRC with %s threads
24*drc2
82default:defaultZ23-27h px� 
U
DRC finished with %s
272*project2
0 Errors2default:defaultZ1-461h px� 
d
BPlease refer to the DRC report (report_drc) for more information.
274*projectZ1-462h px� 
�

%s
*constraints2�
�Time (s): cpu = 00:00:05 ; elapsed = 00:00:04 . Memory (MB): peak = 2785.012 ; gain = 64.035 ; free physical = 320 ; free virtual = 444632default:defaulth px� 
g

Starting %s Task
103*constraints2,
Cache Timing Information2default:defaultZ18-103h px� 
E
%Done setting XDC timing constraints.
35*timingZ38-35h px� 
P
;Ending Cache Timing Information Task | Checksum: 2a3fd9163
*commonh px� 
�

%s
*constraints2�
�Time (s): cpu = 00:00:03 ; elapsed = 00:00:01 . Memory (MB): peak = 2785.012 ; gain = 0.000 ; free physical = 299 ; free virtual = 444422default:defaulth px� 
a

Starting %s Task
103*constraints2&
Logic Optimization2default:defaultZ18-103h px� 
�

Phase %s%s
101*constraints2
1 2default:default27
#Generate And Synthesize Debug Cores2default:defaultZ18-101h px� 
k
)Generating Script for core instance : %s 214*	chipscope2
dbg_hub2default:defaultZ16-329h px� 
�
Generating IP %s for %s.
1712*coregen2+
xilinx.com:ip:xsdbm:3.02default:default2

dbg_hub_CV2default:defaultZ19-3806h px� 
�
r%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s ; free physical = %s ; free virtual = %s
480*common2.
Netlist sorting complete. 2default:default2
00:00:00.132default:default2
00:00:00.142default:default2
2785.0122default:default2
0.0002default:default2
20692default:default2
431022default:defaultZ17-722h px� 
W
BPhase 1 Generate And Synthesize Debug Cores | Checksum: 1f91ce6b7
*commonh px� 
�

%s
*constraints2�
�Time (s): cpu = 00:03:55 ; elapsed = 00:12:28 . Memory (MB): peak = 2785.012 ; gain = 0.000 ; free physical = 2068 ; free virtual = 431012default:defaulth px� 
i

Phase %s%s
101*constraints2
2 2default:default2
Retarget2default:defaultZ18-101h px� 
u
)Pushed %s inverter(s) to %s load pin(s).
98*opt2
22default:default2
22default:defaultZ31-138h px� 
K
Retargeted %s cell(s).
49*opt2
02default:defaultZ31-49h px� 
<
'Phase 2 Retarget | Checksum: 168f350d8
*commonh px� 
�

%s
*constraints2�
�Time (s): cpu = 00:04:00 ; elapsed = 00:12:31 . Memory (MB): peak = 2785.012 ; gain = 0.000 ; free physical = 2078 ; free virtual = 431132default:defaulth px� 
�
.Phase %s created %s cells and removed %s cells267*opt2
Retarget2default:default2
02default:default2
02default:defaultZ31-389h px� 
u

Phase %s%s
101*constraints2
3 2default:default2(
Constant propagation2default:defaultZ18-101h px� 
u
)Pushed %s inverter(s) to %s load pin(s).
98*opt2
02default:default2
02default:defaultZ31-138h px� 
G
2Phase 3 Constant propagation | Checksum: f6a8d924
*commonh px� 
�

%s
*constraints2�
�Time (s): cpu = 00:04:01 ; elapsed = 00:12:32 . Memory (MB): peak = 2785.012 ; gain = 0.000 ; free physical = 2078 ; free virtual = 431132default:defaulth px� 
�
.Phase %s created %s cells and removed %s cells267*opt2(
Constant propagation2default:default2
02default:default2
922default:defaultZ31-389h px� 
f

Phase %s%s
101*constraints2
4 2default:default2
Sweep2default:defaultZ18-101h px� 
9
$Phase 4 Sweep | Checksum: 105fcddd8
*commonh px� 
�

%s
*constraints2�
�Time (s): cpu = 00:04:06 ; elapsed = 00:12:38 . Memory (MB): peak = 2785.012 ; gain = 0.000 ; free physical = 2071 ; free virtual = 431062default:defaulth px� 
�
.Phase %s created %s cells and removed %s cells267*opt2
Sweep2default:default2
02default:default2
20372default:defaultZ31-389h px� 
r

Phase %s%s
101*constraints2
5 2default:default2%
BUFG optimization2default:defaultZ18-101h px� 
E
0Phase 5 BUFG optimization | Checksum: 105fcddd8
*commonh px� 
�

%s
*constraints2�
�Time (s): cpu = 00:04:07 ; elapsed = 00:12:39 . Memory (MB): peak = 2785.012 ; gain = 0.000 ; free physical = 2073 ; free virtual = 431092default:defaulth px� 
�
EPhase %s created %s cells of which %s are BUFGs and removed %s cells.395*opt2%
BUFG optimization2default:default2
02default:default2
02default:default2
02default:defaultZ31-662h px� 
|

Phase %s%s
101*constraints2
6 2default:default2/
Shift Register Optimization2default:defaultZ18-101h px� 
N
9Phase 6 Shift Register Optimization | Checksum: ccfbdbad
*commonh px� 
�

%s
*constraints2�
�Time (s): cpu = 00:04:09 ; elapsed = 00:12:40 . Memory (MB): peak = 2785.012 ; gain = 0.000 ; free physical = 2067 ; free virtual = 431022default:defaulth px� 
�
.Phase %s created %s cells and removed %s cells267*opt2/
Shift Register Optimization2default:default2
02default:default2
02default:defaultZ31-389h px� 
x

Phase %s%s
101*constraints2
7 2default:default2+
Post Processing Netlist2default:defaultZ18-101h px� 
J
5Phase 7 Post Processing Netlist | Checksum: ccfbdbad
*commonh px� 
�

%s
*constraints2�
�Time (s): cpu = 00:04:09 ; elapsed = 00:12:41 . Memory (MB): peak = 2785.012 ; gain = 0.000 ; free physical = 2062 ; free virtual = 430982default:defaulth px� 
�
.Phase %s created %s cells and removed %s cells267*opt2+
Post Processing Netlist2default:default2
02default:default2
02default:defaultZ31-389h px� 
a

Starting %s Task
103*constraints2&
Connectivity Check2default:defaultZ18-103h px� 
�

%s
*constraints2�
�Time (s): cpu = 00:00:00.08 ; elapsed = 00:00:00.08 . Memory (MB): peak = 2785.012 ; gain = 0.000 ; free physical = 2065 ; free virtual = 431012default:defaulth px� 
I
4Ending Logic Optimization Task | Checksum: ccfbdbad
*commonh px� 
�

%s
*constraints2�
�Time (s): cpu = 00:04:10 ; elapsed = 00:12:41 . Memory (MB): peak = 2785.012 ; gain = 0.000 ; free physical = 2061 ; free virtual = 430972default:defaulth px� 
a

Starting %s Task
103*constraints2&
Power Optimization2default:defaultZ18-103h px� 
s
7Will skip clock gating for clocks with period < %s ns.
114*pwropt2
2.002default:defaultZ34-132h px� 
E
%Done setting XDC timing constraints.
35*timingZ38-35h px� 
=
Applying IDT optimizations ...
9*pwroptZ34-9h px� 
?
Applying ODC optimizations ...
10*pwroptZ34-10h px� 
�
(%s %s Timing Summary | WNS=%s | TNS=%s |333*physynth2
	Estimated2default:default2
 2default:default2
1.0772default:default2
0.0002default:defaultZ32-619h px� 
K
,Running Vector-less Activity Propagation...
51*powerZ33-51h px� 
P
3
Finished Running Vector-less Activity Propagation
1*powerZ33-1h px� 


*pwropth px� 
e

Starting %s Task
103*constraints2*
PowerOpt Patch Enables2default:defaultZ18-103h px� 
�
�WRITE_MODE attribute of %s BRAM(s) out of a total of %s has been updated to save power.
    Run report_power_opt to get a complete listing of the BRAMs updated.
129*pwropt2
592default:default2
642default:defaultZ34-162h px� 
E
%Done setting XDC timing constraints.
35*timingZ38-35h px� 
e
+Structural ODC has moved %s WE to EN ports
155*pwropt2
582default:defaultZ34-201h px� 
�
CNumber of BRAM Ports augmented: %s newly gated: %s Total Ports: %s
65*pwropt2
582default:default2
742default:default2
1282default:defaultZ34-65h px� 
N
9Ending PowerOpt Patch Enables Task | Checksum: 1e8fc4855
*commonh px� 
�

%s
*constraints2�
�Time (s): cpu = 00:00:04 ; elapsed = 00:00:02 . Memory (MB): peak = 3365.980 ; gain = 0.000 ; free physical = 1912 ; free virtual = 429602default:defaulth px� 
J
5Ending Power Optimization Task | Checksum: 1e8fc4855
*commonh px� 
�

%s
*constraints2�
�Time (s): cpu = 00:00:48 ; elapsed = 00:00:28 . Memory (MB): peak = 3365.980 ; gain = 580.969 ; free physical = 1929 ; free virtual = 429762default:defaulth px� 
\

Starting %s Task
103*constraints2!
Final Cleanup2default:defaultZ18-103h px� 
a

Starting %s Task
103*constraints2&
Logic Optimization2default:defaultZ18-103h px� 
E
%Done setting XDC timing constraints.
35*timingZ38-35h px� 
J
5Ending Logic Optimization Task | Checksum: 106293a97
*commonh px� 
�

%s
*constraints2�
�Time (s): cpu = 00:00:07 ; elapsed = 00:00:04 . Memory (MB): peak = 3365.980 ; gain = 0.000 ; free physical = 1928 ; free virtual = 429762default:defaulth px� 
E
0Ending Final Cleanup Task | Checksum: 106293a97
*commonh px� 
�

%s
*constraints2�
�Time (s): cpu = 00:00:07 ; elapsed = 00:00:04 . Memory (MB): peak = 3365.980 ; gain = 0.000 ; free physical = 1927 ; free virtual = 429752default:defaulth px� 
Z
Releasing license: %s
83*common2"
Implementation2default:defaultZ17-83h px� 
�
G%s Infos, %s Warnings, %s Critical Warnings and %s Errors encountered.
28*	vivadotcl2
542default:default2
182default:default2
162default:default2
02default:defaultZ4-41h px� 
\
%s completed successfully
29*	vivadotcl2

opt_design2default:defaultZ4-42h px� 
�
r%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s ; free physical = %s ; free virtual = %s
480*common2 
opt_design: 2default:default2
00:05:132default:default2
00:13:202default:default2
3365.9802default:default2
653.0042default:default2
19282default:default2
429762default:defaultZ17-722h px� 
4
Scanning sources...
90*projectZ1-90h px� 
:
Finished scanning sources
47*projectZ1-47h px� 
>
Refreshing IP repositories
234*coregenZ19-234h px� 
G
"No user IP repositories specified
1154*coregenZ19-1704h px� 

"Loaded Vivado IP repository '%s'.
1332*coregen26
"/home/vavido/Vivado/2018.2/data/ip2default:defaultZ19-2313h px� 
�
r%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s ; free physical = %s ; free virtual = %s
480*common2"
open_project: 2default:default2
00:00:072default:default2
00:00:072default:default2
3365.9802default:default2
0.0002default:default2
18622default:default2
429102default:defaultZ17-722h px� 
{
No cells matched '%s'.
180*	planAhead2=
)get_cells -hier -filter {RAM_MODE == SDP}2default:defaultZ12-180h px� 
D
Writing placer database...
1603*designutilsZ20-1893h px� 
H
&Writing timing data to binary archive.266*timingZ38-480h px� 
=
Writing XDEF routing.
211*designutilsZ20-211h px� 
J
#Writing XDEF routing logical nets.
209*designutilsZ20-209h px� 
J
#Writing XDEF routing special nets.
210*designutilsZ20-210h px� 
�
r%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s ; free physical = %s ; free virtual = %s
480*common2)
Write XDEF Complete: 2default:default2
00:00:00.702default:default2
00:00:00.202default:default2
3365.9802default:default2
0.0002default:default2
18722default:default2
429262default:defaultZ17-722h px� 
�
 The %s '%s' has been generated.
621*common2

checkpoint2default:default2�
n/home/zhoulian/work/hxzy/cy/gen2/bypass/boards/690t/bypass_690t/bypass_690t.runs/impl_1157/bypass_690t_opt.dcp2default:defaultZ17-1381h px� 
�
r%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s ; free physical = %s ; free virtual = %s
480*common2&
write_checkpoint: 2default:default2
00:00:142default:default2
00:00:182default:default2
3365.9802default:default2
0.0002default:default2
18712default:default2
429272default:defaultZ17-722h px� 
�
%s4*runtcl2�
sExecuting : report_drc -file bypass_690t_drc_opted.rpt -pb bypass_690t_drc_opted.pb -rpx bypass_690t_drc_opted.rpx
2default:defaulth px� 
�
Command: %s
53*	vivadotcl2z
freport_drc -file bypass_690t_drc_opted.rpt -pb bypass_690t_drc_opted.pb -rpx bypass_690t_drc_opted.rpx2default:defaultZ4-113h px� 
P
Running DRC with %s threads
24*drc2
82default:defaultZ23-27h px� 
�
#The results of DRC are in file %s.
168*coretcl2�
t/home/zhoulian/work/hxzy/cy/gen2/bypass/boards/690t/bypass_690t/bypass_690t.runs/impl_1157/bypass_690t_drc_opted.rptt/home/zhoulian/work/hxzy/cy/gen2/bypass/boards/690t/bypass_690t/bypass_690t.runs/impl_1157/bypass_690t_drc_opted.rpt2default:default8Z2-168h px� 
\
%s completed successfully
29*	vivadotcl2

report_drc2default:defaultZ4-42h px� 
�
r%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s ; free physical = %s ; free virtual = %s
480*common2 
report_drc: 2default:default2
00:00:132default:default2
00:00:082default:default2
3365.9802default:default2
0.0002default:default2
18532default:default2
429152default:defaultZ17-722h px� 


End Record