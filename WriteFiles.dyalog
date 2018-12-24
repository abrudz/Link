 outFail←{opts}WriteFiles(source dir);nc;okFn;okNs ⍝ Write items to file in folders
 ;Enclose;Path;Into;AbsSaveFn;nss;No0;SaveFn;OnEach;SaveNs;unscripted;failed;paths;ok;fns
 opts←DefaultOpts'opts'⎕NS ⍬

 dir,←'/'/⍨~'/\'∊⍨⊃⌽dir ⍝ append trailing slash if missing
 dir←⊃1 ⎕NPARTS dir     ⍝ normalise ─ '' means current dir

 Path←{ ⍝ Ns path → full path
     ⍺←'/'
     (types exts)←↓{⍵,⌊@1⊢⍵}⍉opts.typeExtensions
     tail←(types⍳⍺)⊃'/',⍨'.',¨exts
     '/'@{'.'=⍵}dir,⍵,tail  ⍝ append appropriate tail and convert / to .
 }
 Into←{ ⍝ Put vtv into file
     22::⍵                  ⍝ no file access
     _←3 ⎕MKDIR⊃1 ⎕NPARTS ⍵ ⍝ create dir if needed
     0⊣⍵ 1 ⎕NPUT⍨⊂⍺         ⍝ overwrite
 }
 AbsSaveFn←{ ⍝ Save single fn into target
     nr←source.⎕NR ⍵
     nc←⊃source.⎕NC ⍵
     nr Into nc Path ⍵↑⍨1-'.'⍳⍨⌽⍵ ⍝ Item name without ns path
 }
 nc←⎕NC⊂,⍕source
 okFn←3.1 3.2 4.1 4.2 ⍝ tradfn/dfn/tradop/dop
 okNs←9.1 9.4 9.5 ⍝ ns/class/interface
 :If nc=0 ⍝ undef
 :ElseIf nc∊okFn
     outFail←0⍴⊂0⍴AbsSaveFn source ⍝ single fn/op
 :ElseIf nc∊okNs
     OnEach←{ ⍝ ¨ without prototype call on empty
         0∊⍴⍵:⍬ ⍝ if empty return empty
         ⍺←⊢      ⍝ ambivalent
         ⍺ ⍺⍺¨⍵ ⍝ call
     }

     SaveNs←{ ⍝ Save namespace whether scripted or not
         0=≡⍵:0                ⍝ prototype means
         16::0 ⍵               ⍝ problem: no script
         src←⎕SRC source.⍎⍵    ⍝ get source from its location
         22::⍵ 0               ⍝ failed: no file access
         nc←⊃source.⎕NC ⍵
         0 0⊣src Into nc Path ⍵ ⍝ save as namespace and report OK
     }

     nss←source.⎕NL-okNs

     No0←{⍵~0} ⍝ Remove fills
     SaveFn←{  ⍝ Save function there
         nr←source.⎕NR ⍵
         nc←⊃source.⎕NC ⍵
         nr Into nc Path ⍵
     }
     (failed unscripted)←No0¨↓⍉↑SaveNs OnEach nss ⍝ go through them
     paths←Path OnEach unscripted              ⍝ needed dirs
     ok←{⎕NEXISTS ⍵⊣3 ⎕MKDIR ⍵}OnEach paths ⍝ Try and make sure dir exists
     fns←source.⎕NL-okFn                          ⍝ tradfn, dfn, tradop, dop
     failed,←No0 SaveFn OnEach fns                ⍝ try to save the functions
     failed,←paths/⍨~ok                           ⍝ also remember failed paths for nss
     paths/⍨←ok                                   ⍝ the good paths
     unscripted/⍨←ok                              ⍝ and their namespaces

     outFail←failed,⊃,/unscripted{opts WriteFiles(source.⍎⍺)⍵}OnEach paths  ⍝ recurse and collect failures
 :Else ⍝ invalid type
     outFail←,⊂source
 :EndIf
