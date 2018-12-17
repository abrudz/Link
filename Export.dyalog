 msg←Export(ns path)
 opts←⎕NS ⍬
 opts.watch←'none'
 opts.source←'ns'
 opts WriteFiles ns path
