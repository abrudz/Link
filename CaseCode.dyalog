 name←CaseCode name;bin;len;digits;⎕IO;path;ext
 :If ~×⎕NC'⎕SE.Link.DEBUG'
     ⎕SE.Link.DEBUG←0
 :ElseIf ⎕SE.Link.DEBUG=2
     (1+⊃⎕LC)⎕STOP⊃⎕SI
 :EndIf
 :Trap ⎕SE.Link.DEBUG↓0
     ⎕IO←0
     (path name ext)←⎕NPARTS name
     bin←name≠819⌶name
     len←⌈3÷⍨≢bin
     digits←2⊥⌽⍉⌽len 3⍴bin↑⍨3×len
     digits↓⍨←+/∧\0=digits
     name,←'-',⎕D[digits,0/⍨⍬≡digits]
     path,←'/'⍴⍨×≢path
     name←path,name,ext
 :Else
     ⎕SIGNAL⊂⎕DMX.(('EM'EM)('Message'Message))
 :EndTrap
