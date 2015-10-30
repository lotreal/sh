#!/usr/bin/env python
#coding=utf-8
import binascii,os

filesizes={}
samefiles=[]
def filesize(path):
    if os.path.isdir(path):
        files=os.listdir(path)
        for file in files:
            filesize(path+"/"+file)
    else:
        size=os.path.getsize(path)
        if not filesizes.has_key(size):
            filesizes[size]=[]
        filesizes[size].append(path)

def filecrc(files):
    filecrcs={}
    for file in files:
        f=open(file,'r')
        crc = binascii.crc32(f.read())
        f.close()
        if not filecrcs.has_key(crc):
            filecrcs[crc]=[]
        filecrcs[crc].append(file)
    for filecrclist in filecrcs.values():
        if len(filecrclist)>1:
            samefiles.append(filecrclist)
            
if __name__ == "__main__":
    filesize("/home/lot/Music")
    for sizesamefilelist in filesizes.values():
        if len(sizesamefilelist)>1:
            filecrc(sizesamefilelist)
    for samefile in samefiles:
        #print "******* same files group **********"
        for file in samefile[1:]:
            print 'rm "%s"' % file
