# Mac Prototype Installation Instructions

## 0. Install `First Aid Game Prototype.zip`
* https://github.com/chuahxinyu/FirstAidGameDesignAndPrototype/releases/download/prototype/FirstAidGamePrototype-Mac.zip
## 1. Open you `Downloads` folder
* double click the `.zip` file
![](/doc_images/Step1.jpeg)
* another application file should appear like thos:
![](/doc_images/Step3.jpeg)
## 2. Try to open the application
* if the application runs fine, then great - if you get a warnin like this, move onto step 3
![](/doc_images/Step2.jpeg)

## 3. `control + click` or `left-click` the application file and click 'New Terminal at Folder'
* that should bring a drop down menu like this
![](/doc_images/Step4.jpeg)

## 4. type `xattr -rd com.apple.quarantine .` in the terminal and then press `Enter`
* so it should look like this:
![](/doc_images/Step5.jpeg)
* after pressing enter, it should look like this:
![](/doc_images/Step6.jpeg)
* it is safest to try copy and paste the command (if possible): `xattr -rd com.apple.quarantine .`
* if the command fails (ie. a lot of text appeared and you have no idea what any of it means, try to type the command in again and check that every character is correct - note that:
  * there is a full stop (`.`) at the end
  * where the spaces are matter a lot: `xattr[SPACE]-rd[SPACE]com.apple.quarantine[SPACE].`

## 5. close the terminal and now you should be able to open the application
