 (inFail fsw)←{opts}FixFiles(target source);Slash;cands;candLengths;name;File;d;f;e;list;Where;Begins;hideBit;hidden;RightExtn;Files;files;dirs;order;Path;RemDir;paths;Nss;DotSlash;nss;NsExpr;PadThis;Target;Parts ⍝ Load items from files in folders
 opts←DefaultOpts'opts'⎕NS ⍬

 Slash←{⍵∊'/\'}                             ⍝ Mark slashes
 Parts←{⍵⊆⍨~Slash ⍵}                          ⍝ Path parts

 source↓⍨←-Slash⊃⌽source                  ⍝ Remove slash from end
 cands←⊃⎕NINFO⍠1⊢source,'*'               ⍝ normalised source candidates
 candLengths←≢¨cands                      ⍝ their lengths

 ⍝ 3::(⍵~0)⍬                               ⍝ if unlisted

 source←cands⊃⍨candLengths⍳≢source        ⍝ first length-match
 name←⊃⌽Parts source                      ⍝ name without path

 File←{ ⍝ Prepare file by getting source or prepending prefix
     'ns' 'both'∊⍨⊂opts.watch:'file://',⍵
     ⊃⎕NGET ⍵ 1
 }

 :If 2≡1 ⎕NINFO source ⍝ if it is a file, just fix it
     2 target.⎕FIX File source
     :If 'dir' 'both'∊⍨opts.watch
         d f e←⎕NPARTS source
         inFail←⍬
         fsw←FileSystemWatcher.Watch d(f,e)
     :Else
         inFail←fsw←⍬
     :EndIf
 :Else
     source,←'/'                              ⍝ append missing slash
     list←0 1 6 ⎕NINFO⍠1⍠'Recurse' 1⊢source,'*' ⍝ recursive listing of everything

     Where←{⍵⌿⍺}                              ⍝ Filter as function
     Begins←{⊃⍺⍷⍵}                                ⍝ ⍵ starts with ⍺

     hideBit←1=3⊃list                         ⍝ mask for hidden items
     hidden←⊃list Where¨⊂hideBit              ⍝ list of hidden (files and) folders
     hidden,¨←'/'                             ⍝ protect agains similarly named items
     list←list Where¨⊂~hideBit                ⍝ keep only visible items
     list←list Where¨⊂~∨⌿hidden∘.Begins⊃list  ⍝ filter away things that come below hidden things
     list↓⍨←¯1                                ⍝ remove hideBit column

     RightExtn←{opts.codeExtensions∊⍨⊂1↓⊃⌽⎕NPARTS ⍵}                ⍝ Ends with specified extension?

     Files←{⍵ Where RightExtn¨⍵}              ⍝ Those that end with specified extension

     files←Files⊃Where/2=@2⊢list             ⍝ second column has 2 for files; first column is filename
     dirs←⊃Where/1=@2⊢list                    ⍝ second column has 1 for dirs
     dirs,¨←'/'                               ⍝ give the dirs trailing slashes
     list←dirs⍪files                          ⍝ we need to process dirs before files
     order←⍋9999999@{47=⍵}↑⎕UCS¨list          ⍝ slashes after all chars
     list←order⊃¨⊂list                        ⍝ sort the list

     Path←{⍵↓⍨-'/'⍳⍨⌽⍵}                         ⍝ Until last slash
     RemDir←{⍵↓⍨≢source}                       ⍝ Only path beginning at target source

     paths←∪RemDir∘Path¨list                  ⍝ paths of all unique items
     paths~←⊂''                               ⍝ remove empty

     Nss←,\'.',¨1↓Parts                       ⍝ Convert file path to ns path
     DotSlash←'.'@Slash                       ⍝ Convert dots to slashes

     :If ~opts.flatten                        ⍝ If we are not flattening, create nss
         nss←DotSlash¨paths                   ⍝ all necessary namespaces
         nss/⍨←(¯1=⎕NC nss)⍱('.'∊¨nss)        ⍝ keep only names that are neither invalid nor compound
         NsExpr←{'''',⍵,'''⎕NS⍬'}             ⍝ Expression to create namespace
         target.⍎∘NsExpr¨(~opts.flatten)/nss  ⍝ create namespaces in target
     :EndIf

     PadThis←{⍵,'⎕THIS'/⍨0=≢⍵}                   ⍝ Default path to here
     Target←{'.'@Slash⊢PadThis(~opts.flatten)/Path RemDir ⍵} ⍝ Determine target path

     FixThere←{ ⍝ Fix the file ⍵ in the namespace ⍺
         t←(1+opts.flatten)⊃(⍺.⍎Target ⍵)⍺         ⍝ final target
         2 t.⎕FIX File ⍵ ⍝ do it
     }

     TryFixThere←{      ⍝ Try to fix file there
         ⍵∧.=' ':⍬      ⍝ Called by each on prototype: ignore
         6 11::⍵        ⍝ return name on failure
         0⊣⍺ FixThere ⍵ ⍝ do it and return 0 on success
     }

     inFail←0~⍨target∘TryFixThere¨Files list ⍝ try it and return only failures
      ⍝ return (list of failures) and (watcher reference or zilde)
     :If 'dir' 'both'∊⍨⊂opts.watch
         fsw←FileSystemWatcher.Watch(¯1↓source)(,'*')
     :Else
         fsw←⍬
     :EndIf
 :EndIf
