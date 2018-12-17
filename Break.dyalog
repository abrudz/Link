 msg←Break nss;ns;linked;broken;missing;mask;⎕IO
 ⎕IO←1
 :If 2<10|⎕DR ns
     ns←(⊃⌽2⍴⎕RSI){⍺⍎⍣(''≡0⍴⍵)⊢⍵}¨ns
 :Else
     ns←⍎ns
 :EndIf
 linked←⍎¨⎕SE.Link.Links.ns
 broken←0⍴⊂''
 missing←0⍴⊂''
 :For ns :In nss
     mask←linked≠ns
     :If 0∊mask
         ⎕SE.Link.Links.ns/⍨←mask
         broken,←⊂ns
     :Else
         ⎕SE.Link.Links.ns/⍨←ns{~(⍳≢⍵)∊⍵⍳⍺}
         missing,←⊂ns
     :EndIf
 :EndFor
 msg←0⍴⊂''
 :If ×≢broken
     msg,←⊂'Unlinked:',∊' ',¨broken
 :EndIf
 :If ×≢missing
     msg,←⊂'Not found:',∊' ',¨missing
 :EndIf
 msg←↑msg
