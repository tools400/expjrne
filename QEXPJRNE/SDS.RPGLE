      /if not defined(SDS)
      /define SDS

     d sds            sds                  qualified
     d  pgmName                1     10a
     d  pgmStat               11     15s 0
     d  prevStat              16     20s 0
     d  lastSeq               21     28a
     d  lastSubr              29     36a
     d  nbrParm               37     39s 0
     d  excType               40     42a
     d  excNbr                43     46a
     d  miInstruction         47     50a
     d  workArea              51     80a
      /if defined(SDS_EXTENDED)
     d  pgmLib                81     90a
     d  excData               91    170a
     d  rnx9001Exc           171    174a
     d  lastFileLong         175    184a
     d  unused_1             185    190a
     d  datFmt               191    198a
     d  year                 199    200s 0
     d  lastFileShort        201    208a
     d  fileStat             209    243a
     d  job                  244    253a
     d  user                 254    263a
     d  nbr                  264    269s 0
     d  startDate            270    275s 0
     d  runDate              276    281s 0
     d  runTime              282    287s 0
     d  compDate             288    293a
     d  compTime             294    299a
     d  compLevel            300    303a
     d  srcFile              304    313a
     d  srcLib               314    323a
     d  srcMbr               324    333a
     d  pgmContProc          334    343a
     d  modContProc          344    353a
     d  unused_2             354    429a
      /endif
      /endif
