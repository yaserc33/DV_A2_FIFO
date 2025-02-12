verdiSetActWin -dock widgetDock_<Decl._Tree>
debImport "dump.vcd"
wvCreateWindow
wvConvertFile -win $_nWave2 -o "/home/Yasir_Alqulayti/DV/a2_fifo/dump.vcd.fsdb" \
           "dump.vcd"
wvSetPosition -win $_nWave2 {("G1" 0)}
schSetOptions -win $_nSchema1 -annotate off
wvOpenFile -win $_nWave2 {/home/Yasir_Alqulayti/DV/a2_fifo/dump.vcd.fsdb}
wvSetPosition -win $_nWave2 {("G1" 0)}
nMemSetPreference
srcSetDisplayAttr -font {-fromGUI}
srcSetDisplayAttr -annotFont {DejaVu Sans Mono 8}
verdiWindowResize -win $_Verdi_1 "985" "521" "900" "700"
verdiSetActWin -win $_nWave2
verdiWindowResize -win $_Verdi_1 "985" "521" "900" "700"
srcDrag -win $_nTrace1
verdiSetActWin -dock widgetDock_MTB_SOURCE_TAB_1
wvSetCursor -win $_nWave2 518.339107
verdiSetActWin -win $_nWave2
verdiSetActWin -dock widgetDock_MTB_SOURCE_TAB_1
srcDrag -win $_nTrace1
verdiSetActWin -dock widgetDock_<Inst._Tree>
wvSetCursor -win $_nWave2 944.665355
verdiSetActWin -win $_nWave2
srcShowCalling -win $_nTrace1
srcShowCalling -win $_nTrace1
srcShowCalling -win $_nTrace1
srcShowCalling -win $_nTrace1
wvSetCursor -win $_nWave2 1846.391376
wvScrollDown -win $_nWave2 0
wvSelectGroup -win $_nWave2 {G1}
wvSetCursor -win $_nWave2 1233.094731
wvSetCursor -win $_nWave2 1233.094731
wvSetCursor -win $_nWave2 1233.094731
verdiSetActWin -dock widgetDock_MTB_SOURCE_TAB_1
srcDrag -win $_nTrace1
verdiSetActWin -dock widgetDock_<Inst._Tree>
verdiDockWidgetSetCurTab -dock widgetDock_<Decl._Tree>
verdiSetActWin -dock widgetDock_<Decl._Tree>
wvSelectGroup -win $_nWave2 {G1}
verdiSetActWin -win $_nWave2
wvSelectGroup -win $_nWave2 {G1}
wvSelectGroup -win $_nWave2 {G1}
wvSelectGroup -win $_nWave2 {G1}
srcDrag -win $_nTrace1
verdiSetActWin -dock widgetDock_MTB_SOURCE_TAB_1
