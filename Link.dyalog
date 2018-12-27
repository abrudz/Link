:Namespace Link ⍝ V 2.00
⍝ 2018 12 17 Adam: Rewrite to thin covers
    ⎕IO←1 ⋄ ⎕ML←1
    ∇ r←List
      ⍝ Name, group, short description and parsing rules
      r←'['
      r,←'{"Name":"Add",         "args":"item",   "Parse":"1 -extension=", "Desc":"Add item to linked namespace"},'
      r,←'{"Name":"Break",       "args":"ns",     "Parse":"1",  "Desc":"Stop namespace from being linked"},'
      r,←'{"Name":"CaseCode",    "args":"file",   "Parse":"1L", "Desc":"Add case code to file name"},'
      r,←'{"Name":"Create",      "args":"ns dir", "Parse":"2L -source=ns dir both -watch=none ns dir both -flatten -casecode -forceextensions -forcefilenames -beforeread= -beforewrite= -typeextensions=","Desc":"Link a namespace to a directory"},'
      r,←'{"Name":"Export",      "args":"ns dir", "Parse":"2L", "Desc":"One-off save"},'
      r,←'{"Name":"GetFileName", "args":"item",   "Parse":"1",  "Desc":"Get name of file linked to item"},'
      r,←'{"Name":"GetItemName", "args":"file",   "Parse":"1L",  "Desc":"Get name of item linked to file"},'
      r,←'{"Name":"Import",      "args":"ns dir", "Parse":"2L", "Desc":"One-off load"},'
      r,←'{"Name":"List",        "args":"[ns]",   "Parse":"1S", "Desc":"List link(s) with name count(s)"},'
      r,←'{"Name":"Refresh",     "args":"ns",     "Parse":"1  -source=ns dir both", "Desc":"Resynchronise including items created without editor"},'
      r←⎕JSON']',⍨¯1↓r
      r.Group←⊂'Link'
      r/⍨←×⎕NC'⎕SE.Link'
    ∇
    ∇ Û←Run(Ûcmd Ûargs);Ûriu
     ⍝ Simulate calling directly from the original ns
      Ûriu←{6::0 ⋄ ##.RIU}0
     ⍝ We can't use :With because if a space is returned
     ⍝ as result it will be lost in :endwith
      Ûargs.('opts'⎕NS ⎕NL 2)
      ⎕CS ##.THIS  ⍝ We know THIS has been set for us
      Û←Ûargs.opts(⎕SE.Link⍎Ûcmd)Ûargs.Arguments ⍝ Û vars for Snap
    ∇
    ∇ r←level Help cmd;args;list;info;Means
      list←List
      info←list⊃⍨list.Name⍳⊢/'.'(≠⊆⊢)cmd
      r←⊂info.Desc
      r,←⊂']LINK.',cmd,' ',info.args
      Means←info.args{(∨/⍺⍺⍷⍨⍺~' ')/⊂'  ',⍺,'  ',⍵}
      r,←'ns  'Means'target namespace of link'
      r,←'dir 'Means'target directory of link'
      r,←'file'Means'filename where item source is stored'
      r,←'item'Means'name of APL item to process'
      r,←⊂'See https://github.com/abrudz/Link/wiki/Link.',cmd,' for full details'
    ∇
:EndNamespace
