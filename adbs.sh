# Control all your connected Android devices simultaneously using adb with one command.
# wangjiebo911@gmail.com 2013-06-20

# Get "emulator-5554" from "emulator-5554	device"
function getSerialNumber(){
    serialNumber=$(echo ${1%$'\t'*})
}

# device, offline, bootloader...
function getStatus(){
    #alternative command: deviceStatus=$(adb -s $deviceId get-state)
    deviceStatus=$(echo ${1#*$'\t'})
}

function getManufacturer(){
    manufacturer=$(adb -s $serialNumber shell getprop ro.product.manufacturer | tr -d '\r\n ')
}

function getModel(){
    model=`adb -s $serialNumber shell getprop ro.product.model | tr -d '\r\n '`
}

# os version like 4.2.2
function getRelease(){
    release=$(adb -s $serialNumber shell getprop ro.build.version.release | tr -d '\r\n ')
}

function getBrand(){
    brand=$(adb -s $serialNumber shell getprop ro.product.brand | tr -d '\r\n ')
}

function getDeviceInfo(){
	manufacturer=""
	model=""
	release=""
	brand=""
	if [ "$deviceStatus"x = "device"x ]
	then
		getManufacturer
		getModel
		getRelease
		getBrand
	fi
}


# Check if there's any arg
if [ x$1 == x ]
then
    echo
    echo "Control all your connected Android devices simultaneously using adb with one command."
    echo "Just like adb -s:"
    echo "\tinstall xxx.apk"
    echo "\tuninstall com.xxx.ooo"
    echo "\tpull filesInPhone localPath"
    echo "\tshell anyCommandInPhone"
    echo "\t..."
    echo
else
    adb start-server

    # Console output of "adb devices"
    currentDevicesInfoRaw=$(adb devices)

    # Delete useless text
    currentDevicesInfo=${currentDevicesInfoRaw#*List of devices attached}
    echo "$currentDevicesInfo"

    numberOfLines=$(echo "$currentDevicesInfo" | wc -l)
    for((i=2;i<=$numberOfLines;i++))
    do {
        deviceInfo=$(echo "$currentDevicesInfo" | awk NR==$i)

        getSerialNumber "$deviceInfo"
        getStatus "$deviceInfo"

        # Get other information
        getDeviceInfo
        
        echo "\n----- adb -s $serialNumber $*  | $manufacturer"_"$brand"_"$model"_"$release" && echo "\n<<<<< $manufacturer"_"$brand"_"$model"_"$release  $serialNumber:\n$(adb -s $serialNumber $*)"
    } &
    done

    # wait for all tasks done
    wait
    echo "\ndone"
fi
