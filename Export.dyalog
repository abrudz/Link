 (outFail)←{opts}Export(source dir) ⍝ Write items to file in folders
 ;Enclose;Path;Into;Last;AbsSaveFn;nss;No0;SaveFn;OnEach;SaveNs;unscripted;failed;paths;ok;fns
 DefaultOpts'opts'⎕NS ⍬

 dir,←'/'/⍨~'/\'∊⍨⊃⌽dir ⍝ append trailing slash if missing
 dir←⊃1 ⎕NPARTS dir     ⍝ normalise ─ '' means current dir

 Path←{ ⍝ Ns path → full path
     path←⍺⊃'/'extn ⍝ Append appropriate tail (⍺=1:dir; ⍺=2:file)
     dir,'/'@('.'=⍵)⊢path
 }
 Into←{ ⍝ Put vtv into file
     22::⍵                  ⍝ no file access
     _←3 ⎕MKDIR⊃1 ⎕NPARTS ⍵ ⍝ create dir if needed
     0⊣1 ⎕NPUT ⍵ ⍺⍺         ⍝ overwrite
 }
 Last←{⍵↑⍨1-'.'⍳⍨⌽⍵} ⍝ Item name without ns path
 AbsSaveFn←{ ⍝ Save single fn into target
     nr←⎕NR ⍵
     nr Into 2 Path Last ⍵
 }

 :If ''≡0⍴source
     outFail←0⍴⊂0⍴AbsSaveFn source ⍝ single fn/op
 :Else
     OnEach←{ ⍝ ¨ without prototype call on empty
         0∊⍴⍵:⍬ ⍝ if empty return empty
         ⍺←⊢    ⍝ ambivalent
         ⍺ ⍺⍺¨⍵ ⍝ call
     }

     SaveNs←{ ⍝ Save namespace whether scripted or not
         0=≡⍵:0                ⍝ prototype means
         16::0 ⍵               ⍝ problem: no script
         src←⎕SRC source.⍎⍵    ⍝ get source from its location
         22::⍵ 0               ⍝ failed: no file access
         0 0⊣src Into 2 Path ⍵ ⍝ save as namespace and report OK
     }

     nss←source.⎕NL ¯9.1 ¯9.4 ¯9.5 namespaces

     No0←{⍵~0} ⍝ Remove fills
     SaveFn←{source.⎕NR Into 2 Path ⍵} ⍝ Save function there

     (failed unscripted)←No0¨↓⍉↑SaveNs OnEach nss ⍝ go through them
     paths←1 Path¨unscripted                      ⍝ needed dirs
     3 ⎕MKDIR paths                               ⍝ make them if they don't exist
     ok←⎕NEXISTS paths                            ⍝ did it work?
     fns←source.⎕NL-3.1 3.2 4.1 4.2               ⍝ tradfn, dfn, tradop, dop
     failed,←No0 SaveFn OnEach fns                ⍝ try to save the functions
     failed,←paths/⍨~ok                           ⍝ also remember failed paths for nss
     paths/⍨←ok                                   ⍝ the good paths
     unscripted/⍨←ok                              ⍝ and their namespaces

     outFail←failed,⊃,/unscripted{opts Export(source.⍎⍺)⍵}OnEach paths  ⍝ recurse and collect failures
 :EndIf
