$name = $args[0]

If (Test-Path "$name.pml.trail"){
	Remove-Item "$name.pml.trail"
}

spin -a "$name.pml"
gcc_spin -O2 -o "$name.exe" pan.c
$cmd = ".\$name.exe -a"
Invoke-Expression $cmd
rm pan.*
rm "$name.exe"
