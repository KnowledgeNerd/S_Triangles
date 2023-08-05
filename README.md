# S_Triangles or Sierpiński Triangle
A PowerShell script to produce a set of Windows batch files to print Sierpiński Triangles of a range of ranks.

Sierpiński Triangle is hard to type... so I call them S Triangles.  This is a simple-ish script to produce S Triangles iteratively, or in this case recursively.  It uses a base triangle and rules to "stack" the previous rank's S Triangle to produce the next rank's S Triangle.  It will also place them into 'templated' batch files and create a launcher batch file in a folder of your choosing.  Plase modify the folder in the command to your environment.

S_Triangle.ps1 is the primary file and produces the files seen in the Triangles folder.


A Wikipedia entry on Sierpiński Triangles
[link](https://en.wikipedia.org/wiki/Sierpi%C5%84ski_triangle)

Here is a screenshot of the output for the first four ranks
![S_Triangles Ranks 1-4](https://github.com/KnowledgeNerd/S_Triangles/blob/main/images/S_Triangle-Rank-1-4.png)



## __Warning__
This code was more or less whipped together on a whim.  It should not be expected to be perfect.  Review it yourself.  I tried my "somewhat" best! 😁


## Recommended Viewer and Font
- __Terminal Emulator:__ Windows Terminal
- __Font:__ mononoki NF
Getting the "viewer' set up right using the right font is one of the biggest challenges to make this work.


## To-Do
[] Switch all function to one style of parameters -> cmdlet-style
[] Add more comments to code
[] Add links for terminal viewer and font
