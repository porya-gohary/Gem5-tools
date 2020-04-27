#!/bin/bash
## Script By : PORYA GOHARY
#Colors
RED='\033[0;31m' #RED
NC='\033[0m' # No Color
GR='\033[0;32m' # GREEN
BL='\033[0;34m' # BLUE

MCPAT=/home/ansmoh00/mcpat

echo -e "${BL}■■■■■■■   McPAT Started    ■■■■■■■${NC}"
	mkdir ./results
	k=0;
	cd stats/
	u=`ls -1q * | wc -l`
	cd ..
	for file in stats/*.txt; 
        do
	    python GEM5ToMcPAT.py stats/stats${k}.txt ./config.json ./arm0_v.xml
	    #python GEM5ToMcPAT.py  -s stats/stats${k}.txt -c ./config.json -t ./arm0.xml
	    echo -e "${RED}[↯↯↯↯     【 $((k+1))  / $u  】    ↯↯↯↯]${NC}"
        #  /home/porya/McPAT/mcpat/mcpat  -infile ./config.xml > results/result${k}.txt
        $MCPAT/mcpat  -infile ./mcpat-out.xml > results/result${k}.txt
		k=$((k+1))
	done;
echo -e "${BL}■■■■■■■   McPAT Finished   ■■■■■■■${NC}"
