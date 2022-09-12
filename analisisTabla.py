#!/usr/bin/env python2
# -*- coding: utf-8 -*-
"""
Created on Thu Feb 10 19:00:06 2022

@author: ruben
"""

import numpy as np
import matplotlib.pyplot as plt
import collections
import statistics as stats
#x=7
#y=91
#z=x+y
#cadena= 'omega\tlul\nomega'
#cadena2='lollollol'
#num=0x22
#uno, *dos= [1, 3, 4, 5, 6]
#var1, *lel, var2 = (10, 20, 30, 40, 50, 60, 70)
#proof=[0, 0]
#proof[0]=3
#proof[1]=4
#proof.append(8)
#proof.append(9)
#print(proof)
dist=np.array([])
snr1=np.array([])
snr2=np.array([])
snr3=np.array([])
cts=[]
snr1list=[]
total=np.array(([0, 0, 0, 0], [0, 0, 0, 0]))

tabla='8e12_8e16_RA_1Table.txt'
f=open(tabla,'r')
cabecero=f.readline()
texto=f.readlines()
f.close()
n=0
for i in range(len(texto)):
    word=texto[i].split()
    x=float(word[16])
    y=float(word[17])
    z=float(word[18])
    d=float(word[7])
    dist=np.append(dist, [d])
    snr1=np.append(snr1, [x])
    snr2=np.append(snr2, [y])
    snr3=np.append(snr3, [z])
    #print(d)
    #total=np.vstack((total,[d, x, y, z]))
    #print("i= ",i)
    #print("longitud= ",len(snr))
    if i==0:
        cts.append(1)
        snr1list.append(word[16])
        total=np.vstack((total, [d, x, y, z]))
        total=np.delete(total, 0, 0)
        total=np.delete(total, 0, 0)
        
    else:
        total=np.vstack((total, [d, x, y, z]))
        for j in range(len(snr1list)):
            n=j
            #print("j= ", j)
            if snr1list[j]==word[16]:
                cts[j]=cts[j]+1
                #print("estoy")
                n=0
                break
        if n==len(snr1list)-1:
            #print("y continuo")
            snr1list.append(word[16])
            cts.append(1)
            

tiposDist=[[k]*v for k, v in collections.Counter(total[:, 0]).items()]
tiposDist2=np.array((tiposDist))
dist1=tiposDist2[0][0]
dist2=tiposDist2[1][0]
dist3=tiposDist2[2][0]
dist4=tiposDist2[3][0]
dist5=tiposDist2[4][0]
dist6=tiposDist2[5][0]
dist7=tiposDist2[6][0]
dist8=tiposDist2[7][0]
distancias=[dist1, dist2, dist3, dist4, dist5, dist6, dist7, dist8]
distancias=sorted(distancias)
mediaSNR1=np.array([0])
mediaSNR2=np.array([0])
mediaSNR3=np.array([0])
errorSNR1=np.array([0])
errorSNR2=np.array([0])
errorSNR3=np.array([0])
medianaSNR1=np.array([0])
medianaSNR2=np.array([0])
medianaSNR3=np.array([0])
random1=np.random.rand(4)
random2=np.random.rand(4)
#arr=np.array([1,2,4])
#arr2=np.array([0,0,0])
#arr=np.vstack(arr)
#arr2=np.vstack(arr2)
#arr3=np.array([1,1,1])
#arr3=np.vstack(arr3)
#arr4=np.append(arr, arr2, axis=1)
#arr4=np.append(arr4, arr3, axis=1)
snr1total=np.array([0])
snr2total=np.array([0])
snr3total=np.array([0])
#snr1total=np.vstack(snr1total)
#snr2total=np.vstack(snr2total)
#snr3total=np.vstack(snr3total)
with open('analisis_8e12_8e16_V2.txt', 'w') as f:
    f.write("Distancia  Media(0.5-2keV)  Error  Media(2-10keV)  Error  Media(0.5-10keV) Error Mediana(0.5-2keV) Mediana(2-10keV)  Mediana(0.5-10keV)\n")
    for i in distancias:
        snrdist1=np.array([0])
        snrdist2=np.array([0])
        snrdist3=np.array([0])
        n=0.0
        f.write(str(i))
        f.write("  ")
        for j in range(len(total)):
            if total[j, 0]==i:
                snrdist1=np.append(snrdist1, total[j, 1])
                snrdist2=np.append(snrdist2, total[j, 2])
                snrdist3=np.append(snrdist3, total[j, 3])
            
        
    
        snrdist1=np.delete(snrdist1, 0, 0)
        media1=stats.mean(snrdist1)
        stdev1=stats.stdev(snrdist1)
        error1=stdev1/np.sqrt(len(snrdist1))
        mediana1=stats.median(snrdist1)
        snrdist2=np.delete(snrdist2, 0, 0)
        media2=stats.mean(snrdist2)
        stdev2=stats.stdev(snrdist2)
        error2=stdev2/np.sqrt(len(snrdist2))
        mediana2=stats.median(snrdist2)
        snrdist3=np.delete(snrdist3, 0, 0)
        media3=stats.mean(snrdist3)
        stdev3=stats.stdev(snrdist3)
        error3=stdev3/np.sqrt(len(snrdist3))
        mediana3=stats.median(snrdist3)
        f.write(str(media1))
        f.write("  ")
        f.write(str(error1))
        f.write("  ")
        f.write(str(media2))
        f.write("  ")
        f.write(str(error2))
        f.write("  ")
        f.write(str(media3))
        f.write("  ")
        f.write(str(error3))
        f.write("  ")
        f.write(str(mediana1))
        f.write("  ")
        f.write(str(mediana2))
        f.write("  ")
        f.write(str(mediana3))
        f.write("\n")
        #snrdist1=np.vstack(snrdist1)
        #snrdist2=np.vstack(snrdist2)
        #snrdist3=np.vstack(snrdist3)
        snr1total=np.append(snr1total, snrdist1)
        snr2total=np.append(snr2total, snrdist2)
        snr3total=np.append(snr3total, snrdist3)
        #print("o", snr1total)
        #snr2total=[snr2total, snrdist2]
        #snr3total=[snr3total, snrdist3]
    
        mediaSNR1=np.append(mediaSNR1, media1)
        mediaSNR2=np.append(mediaSNR2, media2)
        mediaSNR3=np.append(mediaSNR3, media3)
        errorSNR1=np.append(errorSNR1, error1)
        errorSNR2=np.append(errorSNR2, error2)
        errorSNR3=np.append(errorSNR3, error3)
        medianaSNR1=np.append(medianaSNR1, mediana1)
        medianaSNR2=np.append(medianaSNR2, mediana2)
        medianaSNR3=np.append(medianaSNR3, mediana3)
    
f.close()
mediaSNR1=np.delete(mediaSNR1, 0, 0)
mediaSNR2=np.delete(mediaSNR2, 0, 0)
mediaSNR3=np.delete(mediaSNR3, 0, 0)
errorSNR1=np.delete(errorSNR1, 0, 0)
errorSNR2=np.delete(errorSNR2, 0, 0)
errorSNR3=np.delete(errorSNR3, 0, 0)
medianaSNR1=np.delete(medianaSNR1, 0, 0)
medianaSNR2=np.delete(medianaSNR2, 0, 0)
medianaSNR3=np.delete(medianaSNR3, 0, 0)
snr1total=np.delete(snr1total, 0, 0)
snr2total=np.delete(snr2total, 0, 0)
snr3total=np.delete(snr3total, 0, 0)

    
#Todos los puntos de SNR en funcion de la distancia para todas las bandas juntas:
plt.plot(dist, snr1, 'ro', dist, snr2, 'g^', dist, snr3, 'bd')
plt.legend(("0.5-2 keV", "2-10 keV", "0.5-10 keV"), prop={"size": 10}, loc="best")
plt.xlabel("Distancia (grados)")
plt.ylabel("SNR")
plt.title("SNR en funcion de la distancia")
plt.axis([0.005,0.035, 0, 10])
plt.rc('xtick',top=True)
plt.rc('ytick',right=True)
plt.show()

#Medias SNR en funcion de la distancia para todas las bandas:

#0.5-2 keV
plt.errorbar(distancias, mediaSNR1, yerr=errorSNR1, fmt='o', color='r', ecolor='k')
plt.xlabel("Distancia (grados)")
plt.ylabel("SNR")
plt.title("Media SNR en funcion de la distancia (0.5-2 keV)")
plt.axis([0.005,0.035, 4, 10])
plt.rc('xtick',top=True)
plt.rc('ytick',right=True)
plt.show()

#2-10 keV
plt.errorbar(distancias, mediaSNR2, yerr=errorSNR2, fmt='^', color='g', ecolor='k')
plt.xlabel("Distancia (grados)")
plt.ylabel("SNR")
plt.title("Media SNR en funcion de la distancia (2-10 keV)")
plt.axis([0.005,0.035, 0, 4.5])
plt.rc('xtick',top=True)
plt.rc('ytick',right=True)
plt.show()

#0.5-10 keV
plt.errorbar(distancias, mediaSNR3, yerr=errorSNR3, fmt='d', color='b', ecolor='k')
plt.xlabel("Distancia (grados)")
plt.ylabel("SNR")
plt.title("Media SNR en funcion de la distancia (0.5-10 keV)")
plt.axis([0.005,0.035, 0, 10])
plt.rc('xtick',top=True)
plt.rc('ytick',right=True)
plt.show()


plt.plot(distancias, mediaSNR1,'ro')
plt.plot(distancias, mediaSNR2, 'g^')
plt.plot(distancias, mediaSNR3, 'bd')
plt.xlabel("Distancia (grados)")
plt.ylabel("SNR")
plt.title("Media SNR en funcion de la distancia")
plt.axis([0.005,0.035, 0, 11])
plt.rc('xtick', top = True)
plt.rc('ytick', right = True)
plt.show()

#snr1total.shape=(-1,1)
#snr2total.shape=(-1,1)
#snr3total.shape=(-1,1)
#mediaSNR1=np.vstack(mediaSNR1)
#mediaSNR2=np.vstack(mediaSNR2)
#mediaSNR3=np.vstack(mediaSNR3)
#data=np.append(mediaSNR1, mediaSNR2, axis=1)
#data=np.append(data, mediaSNR3, axis=1)
data=[snr1total, snr2total, snr3total]
fig, ax = plt.subplots()
ax.set_title("Boxplot")
ax.boxplot(data, flierprops=dict(markerfacecolor='b'))