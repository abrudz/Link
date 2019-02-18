# How to bootstrap `Link`

In Dyalog APL versions before 17.1, Link must be bootstrapped manually.

**Warning:** This will break any other functionality that relies on the `WorkspaceLoaded` event, for example, SALT, the font and font-size selectors, and the "Boxing on/off" button.

1. Copy the **Link** directory's files into **[DYALOG]/Library/Link**

1. Copy **Link/Bootstrap/startup.dyalog** into **[DYALOG]**

1. Load all files from **Link/Bootstrap** into the workspace, for example with:

   ````apl
   2⎕FIX¨'file://'∘,¨⊃⎕NINFO⍠1⊢'<path>/Link/Bootstrap/*.dyalog'
   ````

1. Run `BUILD_DYALOGSPACE`

1. Save the session