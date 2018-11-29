 {linked}←where Fix src;link;nss;files;file;src;nc;nosrc;fsw;old;ns;name;⎕TRAP;oldname;z
⍝ Fix a function/operator or script, preserving any existing source files
⍝   Used internally by EditorFix "afterfix" processing
⍝   May be called by other tools providing the source in ⎕NR/⎕SRC format on the right
⍝   One day, the left argument of (ns name) may be inferred, for now it must be provided

⍝ Returns 1 if a link was found for the name, else 0
⍝   NB: if 0 is returned, no ⎕FX/⎕FIX was done

 :If DEBUG=2
     ⎕TRAP←0 'S' ⋄ ∘∘∘
 :EndIf

 nosrc←0=≢src
 (ns name oldname)←3↑where,⊂''
 z←ns←⍬⍴ns

 (linked link)←0 ⍬

 :If 0≠⎕NC'⎕SE.Link.Links'
 :AndIf 0≠≢⎕SE.Link.Links
     nss←⍎¨⎕SE.Link.Links.ns
     :Repeat
         :If ~linked←z∊nss
             linked←(z←z.##)∊nss
         :EndIf
     :Until linked∨z∊# ⎕SE
     :If linked
         link←(nss⍳z)⊃⎕SE.Link.Links
     :EndIf

 :EndIf

 :If linked
     :If 0<≢file←4⊃Utils.GetLinkInfo ns name ⍝ Already saved in a file
     :AndIf name≡oldname                  ⍝ Function not renamed
              ⍝ Interpreter will do everything needed here
     :ElseIf ~link.flatten                ⍝ Not flattened

         file←(≢link.ns)↓⍕ns              ⍝ Add sub.namespace structure
         ((file='.')/file)←'/'            ⍝ Convert dots to /
         file←link.dir,file               ⍝ Add link directory
         file,←'/',name,link.extn         ⍝ And the object name

     :Else                                ⍝ New name in "flattened" link
         :If 3=link.⎕NC'onCreate'         ⍝ User exit to determine file name?
             →(0=≢file←(link⍎onCreate)ns name)⍴0 ⍝ Return file name or '' to abort
         :Else
             ⎕←'Fix: unable to determine file name for "',name'"'
                          ⍝ /// could use folder browser under Windows
         :EndIf
     :EndIf

     nc←⍬⍴ns.⎕NC name
     :If nosrc                       ⍝ Source not provided - find it
         :Select nc
         :Case 2
             src←ns⍎name
         :CaseList 3 4
             src←ns.⎕NR name
         :Case 9
             src←⎕SRC ns⍎name
         :Else
             ⎕←'Fix: unable to handle ',(⍕ns),'.',name,' (⎕NC =',(⍕nc),')'
             →0
         :EndSelect
     :EndIf

     :If 2=⎕NC'_rename_temp' ⍝ // workaround for editor overwriting old file on rename
     :AndIf (name oldname)≡(1⊃_rename_temp)[6 5]
         (3⊃_rename_temp)⎕NPUT(2⊃_rename_temp)1 ⍝ Restore old file contents
         ⎕EX'_rename_temp' ⍝ Now leesten carefully, for I will do zis only vunce
     :EndIf

     :If 3=⎕NC link.onWrite
         →((⍎link.onWrite)ns name oldname nc src file)↓0
         →(nc=2)⍴0 ⍝ We don't do variables
     :EndIf

     :Trap 0
         :If fsw←0≠⎕NC⊂'link.fsw.Object.EnableRaisingEvents'
             old←link.fsw.Object.EnableRaisingEvents
             link.fsw.Object.EnableRaisingEvents←0
         :EndIf
         3 ⎕MKDIR 1⊃⎕NPARTS file ⍝ make sure folder is there
         (⊂src)⎕NPUT file 1
     :Else
         old←0
         ⎕←'Fix: Unable to write "',name,'" to file ',file
         ⎕TRAP←0 'S' ⋄ ∘∘∘
         ⎕←'     '⎕DMX
     :EndTrap
     :If fsw ⋄ link.fsw.Object.EnableRaisingEvents←old ⋄ :EndIf

     :Trap 0
         2 ns.⎕FIX'file://',file
     :Else
         ⎕←'Fix: Unable to re-fix "',name,'" from file ',file
         ⎕TRAP←0 'S' ⋄ ∘∘∘
         ⎕←'     '⎕DMX
     :EndTrap
 :EndIf
