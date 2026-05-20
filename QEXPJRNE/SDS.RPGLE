**free
/if not defined(SDS)
/define SDS

dcl-ds sds qualified psds;
  pgmName       char(10);
  pgmStat       zoned(5);
  prevStat      zoned(5);
  lastSeq       char(8);
  lastSubr      char(8);
  nbrParm       zoned(3);
  excType       char(3);
  excNbr        char(4);
  miInstruction char(4);
  workArea      char(30);
/if defined(SDS_EXTENDED)
  pgmLib        char(10);
  excData       char(80);
  rnx9001Exc    char(4);
  lastFileLong  char(10);
  unused_1      char(6);
  datFmt        char(8);
  year          zoned(2);
  lastFileShort char(8);
  fileStat      char(35);
  job           char(10);
  user          char(10);
  nbr           zoned(6);
  startDate     zoned(6);
  runDate       zoned(6);
  runTime       zoned(6);
  compDate      char(6);
  compTime      char(6);
  compLevel     char(4);
  srcFile       char(10);
  srcLib        char(10);
  srcMbr        char(10);
  pgmContProc   char(10);
  modContProc   char(10);
  unused_2      char(76);
/endif
end-ds;
/endif
