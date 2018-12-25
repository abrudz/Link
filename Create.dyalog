 msg←{opts}Create(ns dir);Default;isWin;container;z;links;Qt;fsw;ix;linkDef;outFail;inFail;nsref;win;nsrefs;link;Arrow;arrow;OsSlash

 '⎕SE.Link'⎕NS ⍬
 :If 0=⎕NC'⎕SE.Link.Links'    ⍝ Check existence of our data structure
     ⎕SE.Link.Links←⍬         ⍝ Start with no links
 ⍝ Link namespaces will record switch values
 ⍝    and also contain fsw, the FileSystemWatcher object
 :EndIf

 msg←⍕⍬⊤⍬
 opts←DefaultOpts'opts'⎕NS ⍬
 container←⊃⌽2⍴⎕RSI    ⍝ ns is relative to where we were called from
 ns←(⍕container),'.',(⍕ns)

 dir←∊1 ⎕NPARTS⊃⊃⎕NINFO⍠1⊢dir ⍝ normalise name

 win←'Windows'≡7↑⊃'.'⎕WG'APLVersion'
 OsSlash←'/'@{⍵='/'}⍣win
 dir←OsSlash dir

 Arrow←{⍵.ns,' ',('←→'/⍨2 2⊤'dir' 'ns' 'both'⍳⊂⍵.watch),' ',OsSlash ⍵.dir}
 :If ~win
 :AndIf (⊂opts.watch)∊'both' 'dir'
     msg←'Watching directories is only supported under Microsoft Windows'
 :ElseIf ((⊂ns)∊'⎕SE'(,'#')'⎕DMX')⍱0 9.1∊⍨container.⎕NC⊂,ns ⍝ must be normal namespace
     msg←'Unavailable: ',ns
 :ElseIf ×≢⎕SE.Link.Links⊣nsref←⍎ns container.⎕NS ⍬
 :AndIf nsref∊nsrefs←⍎¨⎕SE.Link.Links.ns
     link←⎕SE.Link.Links⊃⍨nsrefs⍳nsref
     msg←'Already linked: ',Arrow link
 :ElseIf {16::0 ⋄ 1⊣⎕SRC ⍵}nsref
     msg←'Scipted: ',ns
 :ElseIf ~⎕NEXISTS dir←∊1 ⎕NPARTS dir
 :AndIf ~3 ⎕MKDIR dir
     msg←'Directory not found: ',dir
 :ElseIf 0≡opts.source
 :AndIf ∧/0≠(≢nsref.⎕NL-⍳10),≢⊃(⎕NINFO⍠1)dir,'/*'
     msg←'Source must be specified when linking a non-empty namespace to a non-empty directory'
 :ElseIf opts.(flatten∧source≢'dir')
     msg←'flatten≡1 requires source≡''dir'''
 :Else

  ⍝ We're all good; do it!
     inFail←outFail←fsw←⍬
     ix←'[',(⍕1+≢⎕SE.Link.Links),']'
     msg←0⍴⊂''
     :If 'ns' 'both'∊⍨⊂opts.source
         outFail←opts WriteFiles nsref dir
     :AndIf 0≠≢outFail
         msg,←⊂(⍕≢outFail),' export(s) failed (⎕SE.Link.Links',ix,'.outFail)'
     :EndIf

     :If 'dir' 'both'∊⍨⊂opts.source
         (inFail fsw)←opts FixFiles nsref dir
     :AndIf 0≠≢inFail
         msg,←⊂(⍕≢inFail),' imports failed (⎕SE.Link.Links',ix,'.inFail)'
     :EndIf

     linkDef←⎕SE.⎕NS opts

     'linkDef'⎕NS'ns' 'dir' 'inFail' 'outFail'
     arrow←Arrow linkDef
     linkDef.⎕DF 1⌽'][',arrow
     ⎕SE.Link.Links,←linkDef
     msg←⊃{⍺,'; ',⍵}/msg,⍨⊂'Linked: ',arrow
 :EndIf
