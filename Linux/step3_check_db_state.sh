# check hana db state
echo "Checking if Hana DB is active."
HANADBSTATUS=`sudo /usr/sap/hostctrl/exe/sapcontrol -nr 00 -function GetProcessList`
sleep 5

if [[ "$HANADBSTATUS" =~ "GREEN" ]]
then
    echo "Hana DB is running. Exiting."
    exit 10
else
i=1
while [[ ! "$HANADBSTATUS" =~ "GREEN" ]] && [[ "$i" -lt 11 ]]
	do
		echo "Warning: HANA DB is not running. Checking 10 times with 20 second intervalls until script aborts. This is check $i." 
		sleep 20
		HANADBSTATUS=`sudo /usr/sap/hostctrl/exe/sapcontrol -nr 00 -function GetProcessList`
		((i++))
		if [ "$i" = 10 ]
			then
				echo "Error: Hana DB did not start after checking $i times." 
				exit 0
		fi
	done
	if [[ "$HANADBSTATUS" =~ "GREEN" ]]
    then
        echo "Hana DB is running."
        exit 10
	fi
fi

