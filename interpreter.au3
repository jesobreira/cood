#NoTrayIcon
#include <WinAPI.au3>


#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=icon.ico
#AutoIt3Wrapper_Outfile=../interpreter-x86.exe
#AutoIt3Wrapper_Outfile_x64=../interpreter-x64.exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_UseUpx=y
#AutoIt3Wrapper_Compile_Both=y
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_Res_Comment=jefrey.ml/cood/
#AutoIt3Wrapper_Res_Description=Cood interpreter
#AutoIt3Wrapper_Res_Fileversion=1.0.0.0
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#cs
	Cood language
#ce

If $CmdLine[0] <> 1 And $CmdLine[0] <> 2 Then
	ConsoleWrite("Pardon monsieur, but we can't understand you." & @CRLF)
	Exit
EndIf

Local $cells[65536]
For $i = 0 To 65535
	$cells[$i] = 0
Next

Local $pointer = 32767

$file = $CmdLine[1]

If Not FileExists($file) Then
	ConsoleWrite("Pardon monsieur, but we can't understand you.")
	Exit
EndIf

$c = FileReadToArray($file)
$j = UBound($c)-1
$n = 0

For $i = 0 To $j
	$n += 1
	$l = StringStripWS($c[$i], 3)
	If wildcard("Know a joke*", $l) Then ContinueLoop
	If wildcard("The bill*please", $l) Then Exit
	If wildcard("I want this*", $l) Then $cells[$pointer] += 1
	If wildcard("I don*t want this*", $l) Then $cells[$pointer] -= 1
	If wildcard("What do you have for dessert*", $l) Then $pointer += 1
	If wildcard("What do you have for tidbit*", $l) Then $pointer -= 1
	If wildcard("May I ask something*", $l) Then $cells[$pointer] = gets()
	If wildcard("I*m hungry*", $l) Then ConsoleWrite(Chr($cells[$pointer]) & @CRLF)
	If wildcard("I*m very hungry*", $l) Then ConsoleWrite(Chr($cells[$pointer]))
	If wildcard("I hate this*", $l) Then $cells[$pointer] = 0

	; get number
	If wildcard("I want * of this", $l) Then
		$num = StringReplace($l, "I want ", Null)
		$num = StringReplace($num, " of this.", Null)
		$num = StringReplace($num, " of this", Null)
		$cells[$pointer] = Int($num)
	EndIf

	; add number
	If wildcard("More * of this*", $l) Then
		$num = StringReplace($l, "More ", Null)
		$num = StringReplace($num, " of this.", Null)
		$num = StringReplace($num, " of this", Null)
		$cells[$pointer] += Int($num)
	EndIf

	; subtract number
	If wildcard("Less * of this*", $l) Then
		$num = StringReplace($l, "More ", Null)
		$num = StringReplace($num, " of this.", Null)
		$num = StringReplace($num, " of this", Null)
		$cells[$pointer] += Int($num)
	EndIf

	; loop
	If $l = "What do you suggest?" Then
		$loop_line = $i
	EndIf


	If $l = "Nothing more?" Then
		If $cells[$pointer] >0 And IsDeclared("loop_line") Then
			$i = $loop_line
		EndIf
	EndIf

	If $CmdLine[0] = 2 And $CmdLine[2] = "--debug" Then ConsoleWrite(@CRLF & "Pointer: " & $pointer & " / Value: " & $cells[$pointer] & " / Line " & $i & ": " & $l & @CRLF)
Next

Func wildcard($pattern, $string)
	$pattern = preg_quote($pattern)
	$pattern = StringReplace($pattern, "\*", ".*")
	$pattern = StringReplace($pattern, "\?", ".")
	Return StringRegExp($string, $pattern)
EndFunc

Func preg_quote($string)
	$chars = StringSplit(". \ + * ? [ ^ ] $ ( ) { } = ! < > | : -", " ")
	For $i = 1 To $chars[0]
		$string = StringReplace($string, $chars[$i], "\" & $chars[$i])
	Next
	Return $string
EndFunc

Func gets()
	If Not @Compiled Then Return SetError(1, 0, 0) ; Not compiled

    Local $tBuffer = DllStructCreate("char"), $nRead, $sRet = ""
    Local $hFile = _WinAPI_CreateFile("CON", 2, 2)

    While 1
        _WinAPI_ReadFile($hFile, DllStructGetPtr($tBuffer), 1, $nRead)
        If DllStructGetData($tBuffer, 1) = @CR Then ExitLoop
        If $nRead > 0 Then $sRet &= DllStructGetData($tBuffer, 1)
    WEnd

    _WinAPI_CloseHandle($hFile)
    Return $sRet
EndFunc
