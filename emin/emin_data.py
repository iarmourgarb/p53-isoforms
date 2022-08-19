#use this script to scrape emin data from output files
#view data to ensure that energy has stabilized

import re
def emin_data(eminfile):
    regex = re.compile('( *[0-9]+)')
    E = re.compile('.*[0-9]+E.*')
    for line in open(eminfile):
        if regex.match(line) and E.match(line):
            line_cut = line[10:29]
            #print(line_cut)
            newLine = line_cut.rstrip()
            newLine += ")"
            newLine2 = newLine.replace("E+", "*(10^")
            newLine2 = newLine2.replace("    ", "")
            newLine2 = newLine2.replace("   ", "")
            print ((newLine2))

filelist = ["1tup_9_HOH_emin1.out", "1tup_9_HOH_emin2.out", "1tup_9_HOH_emin3.out", "1tup_9_HOH_emin4.out", "1tup_9_HOH_emin5.out", "1tup_9_HOH_emin6.out"]

for x in filelist:
    emin_data(x)
