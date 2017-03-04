##Troubleshooting

1. Partition are not listed. The entire disk is represented as a single unallocated space
<br>
*Solution 1:*
<br>

This problem occurs due to the fact that GPT data are larger in size than MBR tables. So if GPT is overwritten by MBR table, stray GUID partition table(GPT) data is left behind. Although such leftover data should not technically be a problem because GPT specification clearly states that such disks are not GPT disks and therefore be treated as MBR disks, some utilities can be confused by the presence of both MBR and GPT data. Thus, fixparts checks for this condition when it starts.
<br>
Open the terminal and run the following command<br>

    sudo fixparts /dev/sdx
<br>
Here sdx is the device you want to install your Ubuntu on. Usually, it is sda. If you are not sure, then run 

    lsblk
which will list all your devices<br>
If it finds leftover GPT data, it warns you of this fact and asks you what to do<br>

    NOTICE: GPT signatures detected on the disk, but no 0xEE protective partition!
    The GPT signatures are probably left over from a previous partitiontable. Do you want ot delete them (if you answer 'Y', this will happen
    immediately)? (Y/N):

Press 'Y'<br>
Then press 'w' to write the changes and exit<br>
Restart and it should work like a charm!

*Reference : [Fixparts](http://www.rodsbooks.com/fixparts/)*

<br><br>

*Solution 2:*
<br>
Leftover software RAID data : <br>
 If the disk has been (or is being) used with software RAID, leftover RAID data can confuse the Ubuntu installer. Run the following command to fix this problem
     sudo dmraid -E -r /dev/sdx
<br>
Replace /dev/sdx with the device name
<br>
*Caution* : Be very sure that the disk is currently not using software RAID.If you erase the RAID data when the system is using RAID, there may be problems accessing your disk


