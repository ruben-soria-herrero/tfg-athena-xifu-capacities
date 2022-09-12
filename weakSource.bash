#!/bin/bash



for i in 0 1 2 3 4
do
for j in 0 1 2 3 4 5 6 7 8
do
RA=$(echo '-0.02886813889+0.01443405556*'$i |bc)
if (( $(echo "$RA < 0" | bc) ));
then
RA=$(echo $RA'+360' | bc)
fi
Dec=$(echo '-0.033333333333+0.008333333333*'$j |bc)
if (( $(echo "$RA == 0" | bc) ));
then
if (( $(echo "$Dec == 0" | bc) ));
then
simputfile Simput="weakSourceFlux8fdet05$i$j.fits" \
RA=${RA} \
Dec=${Dec} \
srcFlux=0 \
Emin=2. \
Emax=10. \
Elow=0.1 \
Eup=15. \
XSPECFile=source.xcm \
clobber=yes 
else
simputfile Simput="weakSourceFlux8fdet05$i$j.fits" \
RA=${RA} \
Dec=${Dec} \
srcFlux=8e-16 \
Emin=2. \
Emax=10. \
Elow=0.1 \
Eup=15. \
XSPECFile=source.xcm \
clobber=yes 
fi
else
simputfile Simput="weakSourceFlux8fdet05$i$j.fits" \
RA=${RA} \
Dec=${Dec} \
srcFlux=8e-16 \
Emin=2. \
Emax=10. \
Elow=0.1 \
Eup=15. \
XSPECFile=source.xcm \
clobber=yes 
fi



#xmldir=/home/ruben/software/simput-2.4.5/share/sixte/instruments/athena-xifu/

#xifupipeline XMLFile=${xmldir}xifu_baseline.xml \
	#AdvXml=${xmldir}xifu_detector_lpa_75um_AR0.5_pixoffset_mux40_pitch275um.xml \
	#Exposure=70000 \
	#RA=${RA} Dec=${Dec} \
	#EvtFile=evt_weak$i$j.fits \
	#Simput=weakSource$i$j.fits clobber=yes
done
done

for i in 0 1 2 3
do
for j in 0 1 2 3 4 5 6 7
do
RA=$(echo '-0.02165125+0.01443416667*'$i |bc)
if (( $(echo "$RA < 0" | bc) ));
then
RA=$(echo $RA'+360' | bc)
fi
Dec=$(echo '-0.02916666667+0.0083333333*'$j |bc)

simputfile Simput="weakSourceFlux8fdet052$i$j.fits" \
RA=${RA} \
Dec=${Dec} \
srcFlux=8e-16 \
Emin=2. \
Emax=10. \
Elow=0.1 \
Eup=15. \
XSPECFile=source.xcm \
clobber=yes 

#xmldir=/home/ruben/software/simput-2.4.5/share/sixte/instruments/athena-xifu/

#xifupipeline XMLFile=${xmldir}xifu_baseline.xml \
	#AdvXml=${xmldir}xifu_detector_lpa_75um_AR0.5_pixoffset_mux40_pitch275um.xml \
	#Exposure=70000 \
	#RA=${RA} Dec=${Dec} \
	#EvtFile=evt_weak2$i$j.fits \
	#Simput=weakSource2$i$j.fits clobber=yes

done
done
