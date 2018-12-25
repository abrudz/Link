 list←List ns;nss;lineages;there;ref
 :If ×⎕NC'⎕SE.Link.Links'
 :AndIf ×≢⎕SE.Link.Links
     list←↑⎕SE.Link.Links.(ns dir)
     :If ×≢ns
     there←⊃⌽2⍴⎕RSI
     ref←9∊⎕NC'ns'
     :andif ref∨×there.⎕NC⍕ns
         ns←⍕there⍎⍣(~ref)⊢ns
         nss←⍕¨⎕SE.Link.Links.ns
         list⌿⍨←ns∘(⊃⍷)¨nss
     :EndIf
     lineages←{⍕¨{∪(⊃⍵).##,⍵}⍣≡2⊃⍵}¨5177⌶⍬
     list,←+/lineages∘.∊⍨⊂¨⊣/list
     list⍪⍨←'Namespace' 'Directory' 'Names'
 :Else
     list←'No active links'
 :EndIf
