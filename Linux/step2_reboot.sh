# check hana db state
echo "Checking if Hana DB is running"
HANADBSTATUS=`sudo /usr/sap/hostctrl/exe/sapcontrol -nr 00 -function GetProcessList`
sleep 5
if [[ "$HANADBSTATUS" =~ "GRAY" ]]
then
    echo "Hana DB is stopped. Rebooting."
	sleep 2
	sudo reboot
    exit 10
else
	echo "Hana DB is running. Abort." 
	exit 0
fi

