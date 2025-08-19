# Sleep_Scoring-SliderDefinition
This repository is designed to update the Drew Lab sleep scoring pipeline. Rather than defining sleep state using binned intervals, use a dynamic slider to more efficiently define arousal state regions.

**GitHub** 
- *git* commands will not work unless you are in the directory of the repository. Go to powershell and type *cd ...* to move up a folder or *cd "(FilePath)"* to change to the folder containing the local repository.
- Always on start use *git pull origin main*
    - This retrieves all updates from the online repository to your local machine. If an error has occured, it will say *fatal* and not pull any updates to your computer. Typically this should not be an issue unless you have unstaged commits. This means that you committed updates but have not yet pushed to the online repository (more simply, your local machine is ahead of the online data and needs to send the local data before retrieving any new online data).

- To send your updates to the online repository:
    - *git add (FilePath)*
        - This says 'I have a new file or new updates to an existing file and need to prepare to upload this to the online repository.'
    - *git commit -m '(Your commit message)'*
        - Every update to the online repository is associated with a commit ID, this is how you can roll back code if you need to undo code or return to a stable version of the code.
        - The commit message can be anything you want but is useful to say what was updated since the last *git add*.
    - *git push origin main*
        - This actually updates the online repository by sending the commited messages and added files from the local computer to the online repository.