# MercuryTool
Don't want to use Orion?
Here is a small batch-skript helping you cloning and testing your Artemis-Submissions to correct and test them properly.

## Usage
1. Just clone this repo to your directory of choice.
2. Select the project-folder containing the tests in an folder named 'behavior'.
3. Insert the git link to the students submission.
4. Let the tests run.

## Notice
- The submission is cloned into a `test-folder\assignment\src` and the tests are run with `mvn clean test` in `test-folder\behavior`.
- You can even open the assignment-folder in your desired IDE like Eclipse as an Java-Project (create new java-project > disable: use default location > choose assignment folder) to browse, edit and run the submission-code. And if you use the tool to update the students solution to a new one you just have to refresh the package-explorer in your IDE to see the new files. (Normally you don't even have to close the file tabs)

## Contribute
Use, test and report. 
I would be glad to get some feedback so I can add additional features or implement more convenient ways of usage.