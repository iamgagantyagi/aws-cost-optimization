#! /bin/bash

echo -e "MENU
1. GP2 to GP3 Conversion
2. Quit
Enter your option: \c"
read choice
case "$choice" in
1) echo -e "Regions
    1. us-east-1
    2. us-east-2
    3. us-west-1
    4. us-west-2
Enter your option: \c"
read choice
case "$choice" in
    1) region=us-east-1 ;;
    2) region=us-west-2 ;;
    *) exit ;;
esac

# Find all gp2 volumes within the given region

volume_ids=$(aws ec2 describe-volumes --region "${region}" --filters Name=volume-type,Values=gp2 --query 'Volumes[].VolumeId' --output text)

# Iterate all gp2 volumes and change its type to gp3

for volume_id in ${volume_ids};do

result=$(aws ec2 modify-volume --region "${region}" --volume-type=gp3 --volume-id "${volume_id}" --query 'VolumeModification.ModificationState' --output text)
if [ $? -eq 0 ] && [ "${result}" == "modifying" ];then
echo "OK: volume ${volume_id} changed to state 'modifying'"
else
echo "ERROR: couldn't change volume ${volume_id} type to gp3!"
fi
done
