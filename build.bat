@echo off

if "%1" == "debug" (
    odin build aln-cli/ -collection:aln=aln/ -show-timings -microarch:native -out:bin/aln.exe -o:minimal -use-separate-modules -debug -strict-style
) else if "%1" == "run" (
    "bin/aln.exe"
) else (
    odin build aln-cli/ -collection:aln=aln/ -show-timings -microarch:native -out:bin/aln.exe -o:speed -no-bounds-check -strict-style
)
