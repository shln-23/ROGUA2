5 _FullScreen
10 Cls: Screen 0: Color 7, 0: Randomize Timer
15 LVL = 1: PHP = 20: MAXHP = 20: ' Начальные статы

20 Cls: Color 14
25 Print "************************************"
30 Print "*           SHLN PRESENTS          *"
40 Print "*             ROGUA II             *"
50 Print "************************************"
60 Color 7: Print "LEVEL:"; LVL; " | MAX HP:"; MAXHP
70 Print: Print "PRESS ANY KEY TO START..."
80 If InKey$ = "" Then GoTo 80

105 Rem --- MAP RE-SIZE LOGIC ---
110 If LVL = 1 Then MW = 20: MH = 12 Else MW = 60: MH = 18
120 If MW > 78 Then MW = 78
130 If MH > 20 Then MH = 20
140 If LVL > 1 Then ReDim MAP(MW, MH) Else Dim MAP(MW, MH)
160 For Y = 1 To MH: For X = 1 To MW
        170 MAP(X, Y) = 0: If X = 1 Or X = MW Or Y = 1 Or Y = MH Then MAP(X, Y) = 1
        180 If Rnd < .15 And X > 2 And X < MW - 2 Then MAP(X, Y) = 1
190 Next X: Next Y

200 Rem --- PLACEMENT ---
210 PX = 2: PY = 2: MAP(PX, PY) = 0
220 EX = MW - 1: EY = MH - 1: MAP(EX, EY) = 0
230 MX = MW - 5: MY = MH - 5: MHP = 5 + (LVL * 5)
240 HX = Int(Rnd * (MW - 4)) + 2: HY = Int(Rnd * (MH - 4)) + 2: MAP(HX, HY) = 0
250 HEALED = 0: MSG$ = "LEVEL" + Str$(LVL) + " STARTED!"

300 Rem --- DRAWING ---
310 Cls: Color 7
320 For Y = 1 To MH: For X = 1 To MW
        330 Locate Y, X
        340 If X = PX And Y = PY Then Color 11: Print "@";: GoTo 390
        350 If X = MX And Y = MY And MHP > 0 Then Color 12: Print "M";: GoTo 390
        360 If X = EX And Y = EY Then Color 14: Print "E";: GoTo 390
        365 If X = HX And Y = HY And HEALED = 0 Then Color 10: Print "+";: GoTo 390
        370 If MAP(X, Y) = 1 Then Color 7: Print Chr$(178); Else Print ".";
390 Next X: Next Y
400 Color 7: Locate MH + 2, 1
410 Print "LVL:"; LVL; " | HP:"; PHP; "/"; MAXHP; " | MONSTER HP:"; MHP
420 Print "LOG: "; MSG$
430 Print "ARROWS TO MOVE | Q TO QUIT"

500 Rem --- INPUT ---
510 K$ = InKey$: DX = 0: DY = 0
520 If K$ = Chr$(0) + "H" Or K$ = "w" Or K$ = "W" Then DY = -1
530 If K$ = Chr$(0) + "P" Or K$ = "s" Or K$ = "S" Then DY = 1
540 If K$ = Chr$(0) + "K" Or K$ = "a" Or K$ = "A" Then DX = -1
550 If K$ = Chr$(0) + "M" Or K$ = "d" Or K$ = "D" Then DX = 1
560 If K$ = "q" Or K$ = "Q" Then End
570 If DX = 0 And DY = 0 Then GoTo 510

600 Rem --- LOGIC ---
610 NX = PX + DX: NY = PY + DY
620 If NX = MX And NY = MY And MHP > 0 Then
    630 DMG = Int(Rnd * 4) + 2: MHP = MHP - DMG
    640 MSG$ = "YOU HIT MONSTER FOR" + Str$(DMG): Beep: GoTo 680
650 End If
660 If MAP(NX, NY) = 0 Then PX = NX: PY = NY
670 If PX = HX And PY = HY And HEALED = 0 Then
    672 PHP = PHP + 15: If PHP > MAXHP Then PHP = MAXHP
    674 HEALED = 1: MSG$ = "HEALED +15 HP!": Beep
675 End If
676 If PX = EX And PY = EY Then GoTo 1000

680 Rem --- MONSTER TURN ---
690 If MHP <= 0 Then MSG$ = "MONSTER IS DEAD!": GoTo 730
700 MDX = 0: MDY = 0
710 If MX < PX Then MDX = 1 Else If MX > PX Then MDX = -1
720 If MY < PY Then MDY = 1 Else If MY > PY Then MDY = -1
722 If MX + MDX = PX And MY + MDY = PY Then
    724 DMG = Int(Rnd * (2 + LVL / 3)) + 1: PHP = PHP - DMG
    726 MSG$ = "MONSTER HITS YOU FOR" + Str$(DMG): Beep
728 Else If MAP(MX + MDX, MY + MDY) = 0 Then MX = MX + MDX: MY = MY + MDY
729 End If

730 If PHP <= 0 Then GoTo 900
740 GoTo 300

900 Color 12: Print: Print "YOU DIED AT LEVEL"; LVL: Beep: Sleep: _KeyClear
910 Color 7: Erase MAP: GoTo 10

1000 Color 10: Print: Print "LEVEL"; LVL; " COMPLETED! MAX HP UP!"
1010 Beep: Sleep: _KeyClear: Color 7
1020 LVL = LVL + 1: MAXHP = MAXHP + 5: PHP = PHP + 5: Erase MAP: GoTo 105

