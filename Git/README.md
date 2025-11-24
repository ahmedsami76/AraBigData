# Git and Github

[Git Official Site](https://www.git-scm.com/)

## Resources
[A Visual Git Reference](https://marklodato.github.io/visual-git-guide/index-en.html)
[Pro Git 2nd Edition (2014)](https://git-scm.com/book/en/v2)

## Git-Mindmaps

This mindmap is designed to serve as a quick reference and to simplify Git's architecture. It visualizes the High-Level Architecture, highlights what makes Git a successful VCS, and details the Low-Level Mechanics. It explains how the 3-Tree Architecture operates, tracing the data flow from the Index down to the internal .git directory structure, and finally illustrates Remote Workflows.

You can find the full mindmaps in the `images` folder.  
For better viewing (zoom in/out), open the images directly from the `images` folder in VS Code in a new tab.


### About Theme

The visualization is designed using the **Catppuccin Mocha** color palette.

> **Recommendation:** For the most seamless visual experience while studying this repo, it is highly recommended to use the **[Catppuccin Mocha Theme](https://github.com/catppuccin/vscode)** in VS Code.

  
### How to Edit / Contribute
If you wish to modify or improve the mindmaps, please note the following technical requirement:

- The source files are **Obsidian-embedded Excalidraw** file (Markdown wrapper).

- You **cannot** open it directly on the Excalidraw website.

- **To edit:** You must use [Obsidian](https://obsidian.md/) with the **Excalidraw Community Plugin** installed.

- The Markdown source files for the mindmaps are located in the `mind-maps-markdown` folder.


## To customize the prompt with Git branching information
**Download the below shell script and place it in your home directory**  
https://github.com/git/git/blob/master/contrib/completion/git-prompt.sh

**Add the content of following script to the end of the ~/.bashrc file and reload your shell using ``$source ./~bashrc``**  
https://gist.github.com/danielalvarenga/2df8cabbd6f3041c2378#file-terminal-colors-branch-sh

