opt="clobber=yes FetchExtensions=yes"
#echo "Central source flux (e-12):"
#read centralFlux
echo "Expossure time (s):"
read Texp
#echo "Weak flux (e-16):"
#read flux
rm sources_data.txt
rm allSrc.reg
rm region.txt
echo "# Region" >> region.txt
echo "# Region file format: DS9 version 4.1" >> allSrc.reg
echo "global color=green dashlist=8 3 width=1 font=\"helvetica 10 normal roman\" select=1 highlite=1 dash=0 fixed=0 edit=1 move=1 delete=1 include=1 source=1" >> allSrc.reg
echo "fk5" >> allSrc.reg
echo "# ID CentralSource WeakSource GalBack ExpTime RA DEC Dist BackCts_05_2 BackCts_2_10 BackCts_05_10 BackArea_arcmin2 TotalCts_05_2 TotalCts_2_10 TotalCts_05_10 TotalArea_arcmin2 SNR_05_2 SNR_2_10 SNR_05_10" >> sources_data.txt
o=0

for centralFlux in 0
do


#Crea el fits de la fuente central brillante
if [[ ${centralFlux} > 0 ]];
then
simputfile Simput="centralSource${centralFlux}.fits" \
RA=1.000000 \
Dec=0 \
srcFlux=${centralFlux}e-12 \
Emin=2. \
Emax=10. \
Elow=0.1 \
Eup=15. \
XSPECFile=source.xcm \
clobber=yes \

fi

#Crea el fits del fondo galactico
simputfile Simput="galBack.fits" \
RA=1.000000 \
Dec=0 \
srcFlux=1.9697e-14 \
Emin=2. \
Emax=10. \
Elow=0.1 \
Eup=15. \
XSPECFile=galBack.xcm \
ImageFile=paraTablaRAImg.fits \
clobber=yes

for flux in 8
do
#echo " " >> counts.txt
#echo "Source flux=${flux}e-16:" >> counts.txt
a=0
#Crea los fits de las fuentes debiles
for i in 0 1 2 3 4 5 6 7 8
do
for j in 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16
do
suma=$(($i+$j))
#Solo crea fuentes debiles cuando i+j sea par, para que se situen bien
if [[ $(($suma % 2)) == 0 ]];
then
RA=$(echo '-0.02886813889+0.00721702778*'$i |bc)
diffRA=$(echo $RA'*'$RA |bc)
RA=$(echo 'scale=6; '$RA'/1' |bc)
RA=$(echo $RA'+1.000000' |bc)
if (( $(echo "$RA < 0" | bc) ));
then
RA=$(echo $RA'+360' | bc)
fi
Dec=$(echo '-0.033333333333+0.00416666665*'$j |bc)
diffDec=$(echo $Dec'*'$Dec |bc)
Dec=$(echo 'scale=6; '$Dec'/1' |bc)
diffsq=$(echo $diffRA'+'$diffDec |bc)
diffsq=$(echo 'scale=6; '$diffsq'/1' |bc)
if (( $(echo "$diffsq < 0.001225" |bc) ));
then
RA=$(echo $RA'+0.000005' |bc)
Dec=$(echo $Dec'+0.000005' |bc)
RA=$(echo 'scale=5; '$RA'/1' |bc)
Dec=$(echo 'scale=5; '$Dec'/1' |bc)
simputfile Simput="weakSourceFlux${flux}fdet05_$a.fits" \
RA=${RA} \
Dec=${Dec} \
srcFlux=${flux}e-16 \
Emin=2. \
Emax=10. \
Elow=0.1 \
Eup=15. \
XSPECFile=source.xcm \
clobber=yes

a=$(($a+1))
fi
fi
done
done
#Combina los fits de todas las fuentes y el fondo galactico en uno llamado mergedAllFlux${flux}fdet05.fits
rm weakSourceFlux${flux}fdet05_30.fits
simputmerge $opt Infile1=weakSourceFlux${flux}fdet05_0.fits Infile2=weakSourceFlux${flux}fdet05_1.fits   Outfile=mergedWeakSources0.fits
a=0
for ((i=2; i<61; i++));
do
if [[ $i != 30 ]];
then
j=$(($a+1))
simputmerge $opt Infile1=mergedWeakSources$a.fits Infile2=weakSourceFlux${flux}fdet05_$i.fits   Outfile=mergedWeakSources$j.fits
simputmerge $opt Infile1=mergedWeakSources$a.fits Infile2=weakSourceFlux${flux}fdet05_$i.fits   Outfile=mergedSources.fits
rm mergedWeakSources$a.fits
a=$(($a+1))
fi
done
#Si el flujo de la fuente central es 0, mergedSources se queda únicamente con las weakSources, como se ve arriba. Si es mayor que 0, mergedSources se elimina y pasa a ser las weakSources más la fuente central
if [[ ${centralFlux} > 0 ]];
then
rm mergedSources.fits
simputmerge $opt Infile1=mergedWeakSources$a.fits Infile2=centralSource${centralFlux}.fits   Outfile=mergedSources.fits
fi
simputmerge $opt Infile1=mergedSources.fits Infile2=galBack.fits   Outfile=mergedAllFlux${flux}fdet05.fits
rm mergedWeakSources$a.fits
rm mergedSources.fits
xmldir=/home/ruben/software/simput-2.4.5/share/sixte/instruments/athena-xifu/

xifupipeline XMLFile=${xmldir}xifu_baseline.xml \
	AdvXml=${xmldir}xifu_detector_lpa_75um_AR0.5_pixoffset_mux40_pitch275um.xml \
	Exposure=${Texp} \
	RA=1.000000 Dec=0 \
	EvtFile=mergedAll_CF${centralFlux}_WF${flux}_${Texp}sfdet05Evt.fits \
	Simput=mergedAllFlux${flux}fdet05.fits clobber=yes Background=yes
	
imgev EvtFile="mergedAll_CF${centralFlux}_WF${flux}_${Texp}sfdet05Evt.fits" Image="mergedAll_CF${centralFlux}_WF${flux}_${Texp}sfdet05Img.fits" NAXIS1=80 NAXIS2=80 CUNIT1=deg CUNIT2=deg CRVAL1=1.000000 CRVAL2=0 CRPIX1=40.5 CRPIX2=40.5 CDELT1=-0.0011888874248538006 CDELT2=0.0011888874248538006 CoordinateSystem=0 Projection=TAN history=true clobber=yes

rm mergedAll_CF${centralFlux}_WF${flux}_${Texp}sfdet05_spec*
specR1=mergedAll_CF${centralFlux}_WF${flux}_${Texp}sfdet05_spec_r1
specR2=mergedAll_CF${centralFlux}_WF${flux}_${Texp}sfdet05_spec_r2
specRing=mergedAll_CF${centralFlux}_WF${flux}_${Texp}sfdet05_spec_ring
a=1
for i in 0 1 2 3 4 5 6 7 8
do
for j in 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16
do
suma=$(($i+$j))
#Solo crea fuentes debiles cuando i+j sea par, para que se situen bien
if [[ $(($suma % 2)) == 0 ]];
then
RA=$(echo '-0.02886813889+0.00721702778*'$i |bc)
diffRA=$(echo $RA'*'$RA |bc)
RA=$(echo 'scale=6; '$RA'/1' |bc)
RA=$(echo $RA'+1.000000' |bc)
#if (( $(echo "$RA < 0" | bc) ));
#then
#RA=$(echo $RA'+360' | bc)
#fi
Dec=$(echo '-0.033333333333+0.00416666665*'$j |bc)
diffDec=$(echo $Dec'*'$Dec |bc)
Dec=$(echo 'scale=6; '$Dec'/1' |bc)
if (( $(echo "$RA==1.000000"|bc) ));
then
if (( $(echo "$Dec==0"|bc) ));
then
continue
fi
fi
diffsq=$(echo $diffRA'+'$diffDec |bc)
diff=$(echo 'sqrt('$diffsq')' |bc )
diff=$(echo 'scale=6; '$diff'/1' |bc)
if (( $(echo "$diffsq < 0.001225" |bc) ));
then
RA=$(echo $RA'+0.000005' |bc)
Dec=$(echo $Dec'+0.000005' |bc)
diff=$(echo $diff'+0.000005' |bc)
RA=$(echo 'scale=5; '$RA'/1' |bc)
Dec=$(echo 'scale=5; '$Dec'/1' |bc)
diff=$(echo 'scale=5; '$diff'/1' |bc)
CIRCLER1="circle(${RA},${Dec},0.00139, RA, DEC)"
CIRCLER2="circle(${RA},${Dec},0.00417, RA, DEC)"
circR1="circle(${RA},${Dec},5\")"
if (( $(echo "$o==0"|bc) ));
then
echo "$circR1" >> allSrc.reg
echo "$CIRCLER1" >> region.txt
fi

makespec \
EvtFile=mergedAll_CF${centralFlux}_WF${flux}_${Texp}sfdet05Evt.fits \
Spectrum=${specR1}_$a.pha \
EventFilter="${CIRCLER1}" \
RSPPath=${xmldir} clobber=yes


makespec \
EvtFile=mergedAll_CF${centralFlux}_WF${flux}_${Texp}sfdet05Evt.fits \
Spectrum=${specR2}_$a.pha \
EventFilter="${CIRCLER2}" \
RSPPath=${xmldir} clobber=yes

mathpha "${specR2}_$a.pha - ${specR1}_$a.pha" outfil=${specRing}_$a.pha properr='no' clobber=yes units='C' exposure=${specR2}_$a.pha areascal=${specR2}_$a.pha ncomments=0
fparkey fitsfile=${specRing}_$a.pha keyword=BACKSCAL val=8
fparkey fitsfile=${specR1}_$a.pha keyword=BACKFILE val=${specRing}_$a.pha
grppha ${specR1}_$a.pha ${specR1}_$a.grp20 clobber=yes "group min 20 & exit"

T1=`python spec_counts.py --infile=${specR1}_$a.pha --emin=0.5 --emax=2. --outinfo='totalcts' 2>&1 >/dev/null`
S1=`python spec_counts.py --infile=${specR1}_$a.pha --emin=0.5 --emax=2. --outinfo='netcts' 2>&1 >/dev/null`
B1=$(($T1-$S1))
TmasB1=$(echo $T1'+'$B1 |bc)
sqr1=$(echo 'sqrt('$TmasB1')' |bc)
SNR1=$(echo 'scale=4; '$S1'/'$sqr1 |bc)
T2=`python spec_counts.py --infile=${specR1}_$a.pha --emin=2. --emax=10. --outinfo='totalcts' 2>&1 >/dev/null`
S2=`python spec_counts.py --infile=${specR1}_$a.pha --emin=2. --emax=10. --outinfo='netcts' 2>&1 >/dev/null`
B2=$(($T2-$S2))
TmasB2=$(echo $T2'+'$B2 |bc)
sqr2=$(echo 'sqrt('$TmasB2')' |bc)
SNR2=$(echo 'scale=4; '$S2'/'$sqr2 |bc)
T3=`python spec_counts.py --infile=${specR1}_$a.pha --emin=0.5 --emax=10. --outinfo='totalcts' 2>&1 >/dev/null`
S3=`python spec_counts.py --infile=${specR1}_$a.pha --emin=0.5 --emax=10. --outinfo='netcts' 2>&1 >/dev/null`
B3=$(($T3-$S3))
TmasB3=$(echo $T3'+'$B3 |bc)
sqr3=$(echo 'sqrt('$TmasB3')' |bc)
SNR3=$(echo 'scale=4; '$S3'/'$sqr3 |bc)
id=$a
printf -v id '%02d' $((10#$id))
#HE PUESTO EL ÁREA DE R2-R1 CON LAS CUENTAS DEL FONDO DE R1 CON BACKFILE Y EL AREA DE R2 CON LAS CUENTAS TOTALES DE R1 CON BACKFILE (CAMBIAR)
#Central source, weak source, galactic background, expossure time, RA, DEC, distance, back counts (0.5-2keV), back counts (2-10keV), back counts (0.5-10keV), back area, total counts (0.5-2keV), total counts (2-10keV), total counts (0.5-10keV), total area, SNR (0.5-2keV), SNR (2-10keV), SNR (0.5-10keV)
echo "  ${id}  ${centralFlux}e-12  ${flux}e-16  1.9697e-14  ${Texp}  ${RA}  ${Dec}  ${diff}  ${B1}  ${B2}  ${B3}  0.1745  ${T1}  ${T2}  ${T3}  0.1963  ${SNR1}  ${SNR2}  ${SNR3}" >> sources_data.txt

a=$(($a+1))
fi
fi
done
done
o=$(echo $o'+1' |bc)
done
done
