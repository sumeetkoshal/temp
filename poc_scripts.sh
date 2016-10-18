==> 10MAggTopics.sh <==
./sdkperf_java.sh -cip=10.191.247.245  -stf=5MTopics.txt -cu=nomura-du@nomura  -cp=password -q  >/dev/null 2>&1  &
./sdkperf_java.sh -cip=10.191.247.245  -stf=5MTopics.txt -cu=nomura-du@nomura  -cp=password -q  >/dev/null 2>&1  &


==> backup_pub__gm_througput.sh <==
max_pub_rate_per_pub=20000
no_of_pub=$(($((120000000/$1))/$max_pub_rate_per_pub))
if(("$no_of_pub" >20))
then
  bal_pub=$(($no_of_pub-20))
  no_of_pub=20
  max_pub_rate_per_pub=$(($max_pub_rate_per_pub+$(($((bal_pub*20))/20))))
fi
#no_of_pubs=$(($((120000000/$2))/166000))
echo "Number of publishers starting : $no_of_pub"

for ((i=1;i<=$no_of_pub;i++))
do
taskset -c $i nohup ./sdkperf_java.sh -cip=10.191.247.245 -ptl=test/gm/$i -mn=1000000000 -mr=$max_pub_rate_per_pub  -cu=nomura-gu@nomura  -cp=password -msa=$1 -psm -mt=persistent -q -nagle &
done


==> copy_sub__gm__througput.sh <==
no_of_sub=$1
echo "Number of subs$no_of_sub"
for ((i=1;i<=$no_of_sub;i++))
do
taskset -c $((i+10)) nohup ./sdkperf_java.sh -cip=10.191.247.245 -asw=255 -stl=test/gm/$i -sql=test/gm/$i -cc=1  -pep='r' -pea=0  -cu=nomura-gu@nomura  -cp=password  -q -epl="jcsmp.CLIENT_CHANNEL_PROPERTIES.ReceiveBuffer,16777216" -nagle &
done


==> c_pub_fo_many_to_one_direct_througput.sh <==
no_of_pub=$1
no_of_topics=$3
for ((i=1;i<=$3;i++))
do
  for((j=1;j<=no_of_pub;j++))
  do
taskset -c 1-20  nohup ./sdkperf_c  -cip=10.191.247.245 -ptl=test/fo/$i -mn=1000000000 -mr=2500000  -cu=nomura-du@nomura  -cp=password -msa=$2 -psm -q >/dev/null 2>&1 &
  done
done


==> c_sub_fo_many_to_one_direct_througput.sh <==
no_of_sub=$1
for ((i=1;i<=no_of_sub;i++))
do
    taskset -c $i+21 nohup ./sdkperf_c  -cip=10.191.247.245 -stl=test/fo/$i -cu=nomura-du@nomura  -cp=password -q >/dev/null 2>&1  &
done


==> kill_sdkperf.sh <==
kill -9 `pgrep -u asbiuat1 -f sdk`

==> max_egress_flows.sh <==
./sdkperf_java.sh -cip=10.191.247.245 -tte=16000 -cu=nomura-gu@nomura  -cp=password  -q

==> max_ingress_flows.sh <==
cd /home/asbiuat1/solace/samples/classes
java -cp .:javax.jms-3.1.1.jar:commons-logging-1.1.3.jar:commons-lang-2.6.jar:sol-sdkperf-jms-7.2.1.13.jar:sol-jms-7.2.1.148.jar:sol-common-7.2.1.148.jar:sol-jcsmp-7.2.1.148.jar com.solacesystems.jms.samples.SolJMSProducer -host smf://10.191.247.245  -username nomura-gu -password password -vpn nomura -flowCount 16000
cd /home/asbiuat1/solace/sdkperf

==> max_subs.sh <==
./sdkperf_java.sh -cip=10.191.247.245 -stf=5MTopics.txt -cu=nomura-du@nomura  -cp=password -q


==> pub__direct_througput.sh <==
no_of_pub=$1
for ((i=1;i<=no_of_pub;i++))
do
taskset -c $i nohup ./sdkperf_java.sh  -cip=10.191.247.245 -ptl=test/$i -mn=1000000000 -mr=2500000  -cu=nomura-du@nomura  -cp=password -msa=$2 -psm -q &
done


==> pub_fo_direct_througput.sh <==
no_of_pub=$1
for ((i=1;i<=no_of_pub;i++))
do
taskset -c $i nohup ./sdkperf_java.sh -cc=$3 -cip=10.191.247.245 -ptl=test/fo/$i -mn=1000000000 -mr=2500000  -cu=nomura-du@nomura  -cp=password -msa=$2 -psm -q &
done


==> pub_fo_many_to_one_direct_througput.sh <==
no_of_pub=$1
no_of_topics=$3
for ((i=1;i<=$3;i++))
do
  for((j=1;j<=no_of_pub;j++))
  do
taskset -c 1-20  nohup ./sdkperf_java.sh  -cip=10.191.247.245 -ptl=test/fo/$i -mn=1000000000 -mr=2500000  -cu=nomura-du@nomura  -cp=password -msa=$2 -psm -q >/dev/null 2>&1 &
  done
done


==> pub_fo_one_to_many_direct_througput.sh <==
no_of_pub=$1
for ((i=1;i<=no_of_pub;i++))
do
taskset -c $i nohup ./sdkperf_java.sh  -cip=10.191.247.245 -ptl=test/fo/$i -mn=1000000000 -mr=2500000  -cu=nomura-du@nomura  -cp=password -msa=$2 -psm -q &
done


==> pub__gm_througput.sh <==
no_of_pub=$1
for ((i=1;i<=$no_of_pub;i++))
do
taskset -c $i nohup ./sdkperf_java.sh -cip=10.191.247.245 -ptl=test/gm/$i -mn=1000000000 -mr=$3  -cu=nomura-gu@nomura  -cp=password -msa=$2 -psm -mt=persistent -q &
done


==> sub__direct_througput.sh <==
no_of_sub=$1
for ((i=1;i<=no_of_sub;i++))
do
taskset -c $((i+20)) nohup ./sdkperf_java.sh -cip=10.191.247.245 -stl=test/$i -cu=nomura-du@nomura  -cp=password -q &
done


==> sub_fo_direct_througput.sh <==
no_of_sub=$1
for ((i=1;i<=no_of_sub;i++))
do
    taskset -c 5-39 nohup ./sdkperf_java.sh --cc=$2 -cip=10.191.247.245 -stl=test/fo/$i -cu=nomura-du@nomura  -cp=password -q &
done


==> sub_fo_many_to_one_direct_througput.sh <==
no_of_sub=$1
for ((i=1;i<=no_of_sub;i++))
do
    taskset -c $i+21 nohup ./sdkperf_java.sh  -cip=10.191.247.245 -stl=test/fo/$i -cu=nomura-du@nomura  -cp=password -q >/dev/null 2>&1  &
done


==> sub_fo_one_to_many_direct_througput.sh <==
no_of_sub=$1
for ((i=1;i<=no_of_sub;i++))
do
    taskset -c $i+20 nohup ./sdkperf_java.sh -cc=10 -cip=10.191.247.245 -stl=test/fo/$i -cu=nomura-du@nomura  -cp=password -q &
done


==> sub__gm__througput.sh <==
no_of_sub=$1
echo "Number of subs$no_of_sub"
for ((i=1;i<=$no_of_sub;i++))
do
taskset -c $((i+15)) nohup ./sdkperf_java.sh -cip=10.191.247.245 -asw=255 -stl=test/gm/$i -tte=1 -pep='r' -pea=0  -cu=nomura-gu@nomura  -cp=password  -q &
done
