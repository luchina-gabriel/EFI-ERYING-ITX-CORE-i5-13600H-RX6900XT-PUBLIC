#########################################################################
#                                                                       #
#				Thunderbolt Software Trace Instructions                 #
#				                                                        #
#########################################################################

------------
Common Trace
------------
Common trace is used for all scenarios except when a reboot is involved.

1. Run Trace.bat as administrator
   * DON'T PRESS ANY KEY AT THIS POINT!
   * A directory will be created (e.g. TBT_LOG_2018-08-02_11-27-54.63 It will store the log and additional files).
2. Run the scenario you wish to log.
3. Press any key when you wish to stop logging.
4. All files in the directory are important for analysis, don't delete any of them.

------------
Reboot Trace
------------
The common trace is stopped when the machine reboots, therefore, the machine needs to be configured to collect logs at boot.

1. If the "pre reboot" info is not required continue to step 3.
2. Run common trace (as described above). It will collect some of the "pre reboot" logs until the logging system is stopped.
3. Run StartSingleBootTrace.bat as administrator.
4. Reboot.
5. After reboot, run StopBootTrace as administrator.
   * If you don't run StopBootTrace.bat the machine will start logging again the next time you boot.
   
----------------------
Multiple Reboots Trace
----------------------
1. Run StartContinuousBootTrace.bat command. This command will start a log and append to the log after every boot.
2. Run StopBootTrace.bat to finalize the log.
   

*************************************************************************
* 		     Using The Scripts for Regression Tests                     *
*************************************************************************
   
Using the Log Scripts in Multiple Cycles Tests (No Reboot)
----------------------------------------------------------
Do the following for every cycle:
1. Call StartTrace.bat at the beginning of the cycle
2. Call StopTrace.bat at the end of the cycle.


Using the Log Scripts in Multiple Cycles Tests that involve Reboot
------------------------------------------------------------------
Do the following for every reboot cycle:
1. Call StopBootTrace.bat (it will not have any affect in the first cycle because no reboot log session is opened, but it won't cause any damage).
2. Call StartBootTrace.bat
3. Call StartTrace.bat (for logging until the reboot).