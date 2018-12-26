 list←List ns;nss;lineages;there;ref
 :If ~×⎕NC'⎕SE.Link.DEBUG'
     ⎕SE.Link.DEBUG←0
 :ElseIf ⎕SE.Link.DEBUG=2
     (1+⊃⎕LC)⎕STOP⊃⎕SI
 :EndIf
 :Trap ⎕SE.Link.DEBUG↓0
     :If ×⎕NC'⎕SE.Link.Links'
     :AndIf ×≢⎕SE.Link.Links
         list←↑⎕SE.Link.Links.(ns dir)
         :If ×≢ns
             there←⊃⌽2⍴⎕RSI
             ref←9∊⎕NC'ns'
         :AndIf ref∨×there.⎕NC⍕ns
             ns←⍕there⍎⍣(~ref)⊢ns
             nss←⍕¨⎕SE.Link.Links.ns
             list⌿⍨←ns∘(⊃⍷)¨nss
         :EndIf
         lineages←{⍕¨{∪(⊃⍵).##,⍵}⍣≡2⊃⍵}¨5177⌶⍬
         list,←+/lineages∘.∊⍨⊂¨⊣/list
         list⍪⍨←'Namespace' 'Directory' 'Scripts'
     :Else
         list←'No active links'
     :EndIf
 :Else
     ⎕SIGNAL⊂⎕DMX.(('EM'EM)('Message'Message))
 :EndTrap
