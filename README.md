# SetupNotebook 📝

Welcome, brave soul, to **SetupNotebook** — your one-stop shop for turning a fresh Windows machine into something halfway usable (and maybe even nice).  

---

## First things first 🚀

1. **Open Terminal as Administrator**  
   Yep, go full boss mode. Then run:  

   ```powershell
   Set-ExecutionPolicy RemoteSigned
````

2. **Since you’re already elevated (fancy!)**, let’s go on a little adventure:

   a) Let Windows clean itself up and install all its *necessary nonsense*:

   ```powershell
   & .\WindowsUpdates.ps1
   ```

   b) Time for some chocolate 🍫 (finally something good!):

   ```powershell
   & .\Install-Choco.ps1
   ```

   c) Full of endorphins and happiness, let’s add some actual software to your life:

   ```powershell
   & .\InstallSoftware.ps1
   ```

   *(Remember, we’re still in elevated mode!)*

   d) And to wrap things up, a little cleanup and some extra goodies:

   ```powershell
   & .\Cleanup-and-misc.ps1
   ```

   This one does a bunch of handy tricks. 🎩✨

---

## Bonus Round 🎲

There are other scripts in this repo too. Feel free to try them out...
**BUT** don’t come crying to me if suddenly VS Code refuses to work.
(Consider this your friendly “I told you so.” 😎)

---

Happy scripting! 🛠️

```

Do you want me to also make the code blocks more *copy-paste friendly* (like including `.\` in all script calls) or keep them playful like you had?
```
