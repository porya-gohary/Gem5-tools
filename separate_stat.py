#!/usr/bin/env python
import os
newpath = r'stats' 
if not os.path.exists(newpath):
    os.makedirs(newpath)

x=open('stats.txt','r')
f=open('stats.txt','r')
a=b=c=d=i=j=l=k=0
k=[0]*1000
while not a=='':
        d=c
        c=b
        b=a
        a=x.read(1)
        i+=1
        if a=='d' and b=='n' and c=='E' and d==' ':
            fo= open('stats/stats%s.txt'%j,'w')
            j+=1
            k=i
            k+=35
            z=f.read(k-l)
            fo.write(z)
            l=k
