adbs
====

Control all your connected Android devices simultaneously using adb with one command.

This is a quite simple shell script. 
Useful when you have a few Android devices connected. Control all the Android devices using adb so you don't need to copy and paste these devices' serial numbers.

Use adbs.sh just the way you use adb.  

Here are some examples:  
sh adbs.sh install example.apk  
sh adbs.sh uninstall com.example.adbs  
sh adbs.sh shell rm /data/local/tmp/exampleFile

If you want to control one of your devices maybe this is your choice:  
https://github.com/ksoichiro/adbs
