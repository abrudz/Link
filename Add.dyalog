 msg←{opts}Add items;item;ns;name;roots;this;added;unfound;⎕IO
 :If ~×⎕NC'⎕SE.Link.DEBUG'
     ⎕SE.Link.DEBUG←0
 :ElseIf ⎕SE.Link.DEBUG=2
     (1+⊃⎕LC)⎕STOP⊃⎕SI
 :EndIf
 :Trap ⎕SE.Link.DEBUG↓0
     ⎕IO←1
     Default←(⍎'opts'⎕NS ⍬){0=⍺⍺.⎕NC ⍺:⍺⍺⍎⍺,'←⍵'}
     'filename'Default''
     items←⊆,items
     items~¨←' '
     roots←{⍵↑⍨⍵⍳'.'}¨items
     this←'.',⍨⍕⊃⌽2⍴⎕RSI
     items,¨⍨←/∘this¨~roots∊,¨'#' '⎕SE' '⎕DMX'
     added←0⍴⊂''
     unfound←0⍴⊂''
     :For item :In items
         :If ×≢⎕NC item
             (ns name)←item⊂⍨⌽≤\⌽item≠'.'
             ns name Fix''
             added,←⊂item
         :Else
             unfound,←⊂item
         :EndIf
     :EndFor
     msg←0⍴⊂''
     :If ×≢added
         msg,←⊂'Added:',∊' ',¨added
     :EndIf
     :If ×≢unfound
         msg,←⊂'Not found:',∊' ',¨unfound
     :EndIf
     msg←↑msg
 :Else
     ⎕SIGNAL⊂⎕DMX.(('EM'EM)('Message'Message))
 :EndTrap
