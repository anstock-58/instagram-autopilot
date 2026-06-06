CreateObject("Wscript.Shell").Run "powershell.exe -NonInteractive -WindowStyle Hidden -ExecutionPolicy Bypass -File """ & WScript.Arguments(0) & """", 0, False
