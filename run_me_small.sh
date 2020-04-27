#!/bin/bash
## Script By : PORYA GOHARY
#Colors
RED='\033[0;31m' #RED
NC='\033[0m' # No Color
GR='\033[0;32m' # GREEN
BL='\033[0;34m' # BLUE

St_Time=`date`

GEM5=/home/ansmoh00/gem5
RESULTS=/home/ansmoh00/gem5_r3
MCPAT=/home/ansmoh00/mcpat
IMAGE_PATH=/home/ansmoh00/full_system_images

NP=--num-cpus=1

CACHE=--caches
L1DSIZE=--l1d_size=32kB
L1DASSOC=--l1d_assoc=4
L1ISIZE=--l1i_size=32kB
L1IASSOC=--l1i_assoc=4
L2=--l2cache
L2SIZE=--l2_size=512kB
L2ASSOC=--l2_assoc=16
LINESIZE=--cacheline_size=32

MEMTYP=--mem-type=LPDDR3_1600_1x32
#MEMCHAN=--mem-channels=1
#MEMRNK=--mem-ranks=2
MEMSIZE=--mem-size=1GB

##
CPUTYPE=--cpu-type=ex5_big
#CPUTYPE=--cpu-type=O3_ARM_v7a_3
DTB=--dtb=$IMAGE_PATH/binaries/armv7_gem5_v1_1cpu.dtb
MACH_TYPE=--machine-type=VExpress_GEM5_V1
BOOT=--boot=$IMAGE_PATH/binaries/boot_emm.arm
KERNEL=--kernel=$IMAGE_PATH/binaries/vmlinux.vexpress_gem5_v1
#KERNEL=--kernel=$IMAGE_PATH/binaries/vmlinux.aarch64.20140821
#DISK_IMAGE=--disk-image=$IMAGE_PATH/disks/linaro-minimal-aarch64.img
DISK_IMAGE=--disk-image=$IMAGE_PATH/disks/linux-aarch32-ael.img


SYSVOLT=(--sys-voltage=0.9995V) 
CPUCLK=(--cpu-clock=2.0GHz )
SYSCLK=--sys-clock=2GHz

mibench=(basicmath_small bitcount_small crc32_small dijkstra_small FFT_small jpeg_small patricia_small qsort_small sha_small stringsearch_small susan_small)

rm -rf /home/ansmoh00/gem5/m5out/*

for i in ${!CPUCLK[@]}
do
		mkdir $RESULTS/f_$i
		cd ~/gem5
		echo -e "${GR}► ► ► ►   ${CPUCLK[$i]}   •••••   ${SYSVOLT[$i]}   ◄ ◄ ◄ ◄${NC}"
        for j in ${!mibench[@]}
        do
            echo -e "${GR}>>>>>>>>>>>>>>>> ${mibench[$j]} Started <<<<<<<<<<<<<<<<<<<<<${NC}"
            $GEM5/build/ARM/gem5.opt $GEM5/configs/example/fs.py \
            $CPUTYPE ${CPUCLK[$i]} $FFINSTR $NP ${SYSVOLT[$i]} $DTB $SYSCLK $MEMTYP $MEMCHAN $MEMRNK $MEMSIZE \
            --script=$GEM5/mibench/${mibench[$j]}.rcS \
            $CACHE $L1DSIZE $L1DASSOC $L1ISIZE $L1IASSOC $L2 $L2SIZE $L2ASSOC $LINESIZE \
            $KERNEL $BOOT $DISK_IMAGE $MACH_TYPE
            
            #Make folder for this benchmark result
            mkdir $RESULTS/f_$i/${mibench[$j]}
            cp -r $GEM5/m5out/* $RESULTS/f_$i/${mibench[$j]}
            cp -r $RESULTS/GEM5ToMcPAT.py $RESULTS/f_$i/${mibench[$j]}/
            cp -r $RESULTS/separate_stat.py $RESULTS/f_$i/${mibench[$j]}/
            cp -r $RESULTS/dynamic.py $RESULTS/f_$i/${mibench[$j]}/
            cp -r $RESULTS/static.py $RESULTS/f_$i/${mibench[$j]}/
            cp -r $RESULTS/makeResult.sh $RESULTS/f_$i/${mibench[$j]}/
            cp -r $RESULTS/arm${i}_v.xml $RESULTS/f_$i/${mibench[$j]}/
            cd $RESULTS/f_$i/${mibench[$j]}/
            ./separate_stat.py
            
            echo -e "${BL}■■■■■■■   McPAT Started ■■■■■■■${NC}"
            mkdir $RESULTS/f_$i/${mibench[$j]}/results
            k=0;
            cd stats/
            u=`ls -1q * | wc -l`
            cd ..
                for file in stats/*.txt; 
                do
                    python GEM5ToMcPAT.py stats/stats${k}.txt ./config.json ./arm${i}_v.xml
                    echo -e "${RED}[↯↯↯↯     【 $((k+1))  / $u  】    ↯↯↯↯]${NC}"
                    $MCPAT/mcpat  -infile ./mcpat-out.xml > results/result${k}.txt
                    k=$((k+1))
                done
            echo -e "${BL}${BL}■■■■■■■   McPAT Finished   ■■■■■■■${NC}"
            echo -e "${GR}•••••   Creating Result   •••••${NC}"
            cp -r $RESULTS/getAllPowerResult $RESULTS/f_$i/${mibench[$j]}/results/
            
            chmod +x $RESULTS/f_$i/${mibench[$j]}/results/getAllPowerResult
            cd $RESULTS/f_$i/${mibench[$j]}/results
            ./getAllPowerResult
            
            chmod +x ./makeResult.sh
            ./makeResult.sh
            
            rm -rf $GEM5/m5out/*
            cd $GEM5
            echo -e "${GR}>>>>>>>>>>>>>>>> ${mibench[$j]} Finished <<<<<<<<<<<<<<<<<<<<${NC}"
        done
done

En_time=`date`

echo "██████╗  ██████╗ ███╗   ██╗███████╗██╗"
echo "██╔══██╗██╔═══██╗████╗  ██║██╔════╝██║"
echo "██║  ██║██║   ██║██╔██╗ ██║█████╗  ██║"
echo "██║  ██║██║   ██║██║╚██╗██║██╔══╝  ╚═╝"
echo "██████╔╝╚██████╔╝██║ ╚████║███████╗██╗"
echo "╚═════╝  ╚═════╝ ╚═╝  ╚═══╝╚══════╝╚═╝"
echo -e "${RED} Start Time -> $St_Time ${NC}"
echo -e "${RED} End Time -> $En_Time ${NC}"
echo "SCRIPT BY : POURYA GOHARI [Email:gohary@ce.sharif.edu]"
