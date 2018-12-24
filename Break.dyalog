 msg←Break nss;ns;linked;broken;missing;mask;⎕IO;there
 ⎕IO←1
 there←⊃⌽2⍴⎕RSI
 :If 2<10|⎕DR nss
     nss←there{⍺⍎⍣(''≡0⍴⍵)⊢⍵}¨nss
 :Else
     nss←there⍎nss
 :EndIf
 linked←⍎¨⎕SE.Link.Links.ns
 broken←0⍴⊂''
 missing←0⍴⊂''
 :For ns :In nss
     mask←linked≠ns
     :If 0∊mask
         ⎕SE.Link.Links/⍨←mask
         broken,←⊂ns
     :Else
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
