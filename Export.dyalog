 msg←Export(ns path)
 :If ~×⎕NC'⎕SE.Link.DEBUG'
     ⎕SE.Link.DEBUG←0
 :ElseIf ⎕SE.Link.DEBUG=2
     (1+⊃⎕LC)⎕STOP⊃⎕SI
 :EndIf
 :Trap ⎕SE.Link.DEBUG↓0
     opts←⎕NS ⍬
     opts.watch←'none'
     opts.source←'ns'
     opts WriteFiles ns path
 :Else
     ⎕SIGNAL⊂⎕DMX.(('EM'EM)('Message'Message))
 :EndTrap
