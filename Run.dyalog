 r←Run(cmd input)
 :Select cmd
 :Case 'Link'
     :If 0=⎕NC'⎕SE.Link'
         'Link'⎕SE.⎕NS ⎕THIS
         ⎕SE.Link.DEBUG←0
     :EndIf
     r←⎕SE.Link.UCMD.Run cmd input
 :EndSelect
