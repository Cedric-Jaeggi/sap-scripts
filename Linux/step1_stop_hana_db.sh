#### errocodes
#### 0	hanadb state = OK
#### 10	hanadb state = STOPPED
#### 20	hanadb state = WARNING
#### 30	hanadb state = ERROR

# stop hana db
echo "Stopping Hana DB"
sudo /usr/sap/hostctrl/exe/sapcontrol -nr 00 -function Stop

# check hana db state
echo "Checking if Hana DB is running."
HANADBSTATUS=`sudo /usr/sap/hostctrl/exe/sapcontrol -nr 00 -function GetProcessList`
sleep 20
if [[ "$HANADBSTATUS" =~ "GRAY" ]]
then
    echo "Hana DB is stopped."
    exit 10
else
i=1
while [[ ! "$HANADBSTATUS" =~ "GRAY" ]] && [[ "$i" -lt 11 ]]
	do
		echo "Warning: HANA DB is running. Checking 10 times with 20 second intervalls until script aborts. This is check $i." 
		sudo /usr/sap/hostctrl/exe/sapcontrol -nr 00 -function Stop
		sleep 20
		# check db state again
		HANADBSTATUS=`sudo /usr/sap/hostctrl/exe/sapcontrol -nr 00 -function GetProcessList`
		((i++))
		if [ "$i" = 10 ]
			then
				echo "Error: retried $i-Times. Couldn't stop DB. Exiting Script."
				echo "Script aborts with Error 0"
				exit 0
		fi
	done
	if [[ "$HANADBSTATUS" =~ "GRAY" ]]
    then
        echo "Hana DB is stopped."
        exit 10
	fi
fi

