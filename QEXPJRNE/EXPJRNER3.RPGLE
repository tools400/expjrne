**free
//=====================================================================*
//                                                                     *
//  Application . : EXPJRNE                                            *
//  Object  . . . : EXPJRNER3                                          *
//  Description . : Export Journal Entries - RCVJRN                    *
//  Author  . . . : Thomas Raddatz   <thomas.raddatz@tools400.de>      *
//  Date  . . . . : 07.02.2006                                         *
//                                                                     *
//=====================================================================*
//                                                                     *
//  This software is free software, you can redistribute it and/or     *
//  modify it under the terms of the GNU General Public License (GPL)  *
//  as published by the Free Software Foundation.                      *
//                                                                     *
//  See GNU General Public License for details.                        *
//          http://www.opensource.org                                  *
//          http://www.opensource.org/licenses/gpl-license.html        *
//                                                                     *
//=====================================================================*
//  History:                                                           *
//                                                                     *
//  Date        Name          Comment                                  *
//  ----------  ------------  ---------------------------------------  *
//  30.03.2007  Th.Raddatz    Removed prototype of ANDSTR() because    *
//                            it comes with copy book MILIB, included  *
//                            by PBASICS1.                             *
//                                                                     *
//  19.09.2008  Th.Raddatz    Added status message USR0012.            *
//                                                                     *
//  20.09.2008  Th.Raddatz    Redesigned EXPJRNE to support additional *
//                            object types, starting with *DTAARA.     *
//                                                                     *
//  12.05.2010  Th.Raddatz    Changed program to use _rOpen, _rWrite   *
//                            and _rClose instead of native RPG record *
//                            IO to ensure that the journal data is    *
//                            added to the output file as binary data. *
//                                                                     *
//  21.09.2013  Th.Raddatz    Fixed crtEntryDataInitialized() to       *
//                            properly initialize the space of         *
//                            variable length fields.                  *
//                                                                     *
//  06.10.2014  Th.Raddatz    Fixed compiler error RNF0203.            *
//                                                                     *
//  03.02.2015  Th.Raddatz    Changed to ignore the "Incomplete data"  *
//                            flag in order to export BLOB/CLOB data.  *
//                                                                     *
//  04.10.2018  Th.Raddatz    Added outfile types *TYPE4 and *TYPE5.   *
//                                                                     *
//  06.02.2022  Th.Raddatz    Prepared EXPJRNE for being converted to  *
//                            **free format.                           *
//                                                                     *
//  31.07.2023  Th.Raddatz    Caught field overflow error for field    *
//                            JOSEQN and added message USR0030.        *
//                                                                     *
//  10.04.2025  Th.Raddatz    Add long sequence number field JOSEQ2    *
//                            for output format *TYPE3 and *TYPE4.     *
//                                                                     *
//=====================================================================*
// >>PRE-COMPILER<<                                                    *
//   >>CRTCMD<< CRTRPGMOD    MODULE(&LI/&OB) +                         *
//                           SRCFILE(&SL/&SF) +                        *
//                           SRCMBR(&SM);                              *
//   >>IMPORTANT<<                                                     *
//     >>PARM<< TRUNCNBR(*NO);                                         *
//     >>PARM<< DBGVIEW(*LIST);                                        *
//     >>PARM<< OPTION(*EVENTF);                                       *
//     >>PARM<< TGTRLS(V7R3M0);                                        *
//   >>END-IMPORTANT<<                                                 *
//   >>EXECUTE<<                                                       *
// >>END-PRE-COMPILER<<                                                *
//=====================================================================*
/copy QEXPJRNE,H_SPEC
//=====================================================================*

//  Type definitions
/copy QEXPJRNE,FDQJOB
/copy QEXPJRNE,FDINFDS

dcl-ds control_t qualified based(pDummy);
  byte1 char(1);
  byte2 char(1);
  byte3 char(1);
end-ds;

dcl-ds dtaQ_data_t len(65535) qualified based(pDummy);
  apiInf char(16);
  value  char(65519);
end-ds;


//  Journal entry data (QSYSINC/QRPGLESRC.QJOURNAL: QJO00JEH00)
dcl-ds RJNE0200_t len(32766) qualified based(pDummy);
  ofsNxtHeader  int(10);
  ofsNulValInd  int(10);
  ofsEntData    int(10);
  ofsTransactID uns(10);
  ofsLglUnitWrk uns(10);
  ofsRcvInf     uns(10);
  seqNbr        uns(20);
  timestamp     uns(20);
  threadID      uns(20);
  sysSeqNbr     uns(20);
  rrn           uns(20);
  cmtCycleID    uns(20);
  ptrHandle     uns(10);
  rmtPort       uns(5);
  armNbr        uns(5);
  pgmLibASP     uns(5);
  rmtAdr        char(16);
  jrnCode       char(1);
  entryType     char(2);
  job           char(10);
  user          char(10);
  jobNbr        char(6);
  pgm           char(10);
  pgmLib        char(10);
  pgmLibASPDev  char(10);
  object        char(30);
  userProfile   char(10);
  journalID     char(10);
  adrFamily     char(1);
  system        char(8);
  indFlag       char(1);
  objnameID     char(1);
  flags         int(3);
  objType       char(10);
  reserved_1    char(3);
  nestedCmtLvl  int(10);
end-ds;

//  Null value indicator information (QSYSINC/QRPGLESRC.QJOURNAL: QJOENVIV)
dcl-ds nullValueInd_t qualified based(pDummy);
  length     int(10);
  indicators char(8000);
end-ds;

//  Receiver information (QSYSINC/QRPGLESRC.QJOURNAL: QJO200RI)
dcl-ds receiverInf_t qualified based(pDummy);
  rcvName    char(10);
  rcvLibName char(10);
  rcvASPDev  char(10);
  rcvASPNbr  uns(5);
end-ds;

//  Logical unit of work
dcl-ds luw_t qualified based(pDummy);
  id char(39);
end-ds;

//  Transaction identifier (QSYSINC/H.XA: xid_t)
dcl-ds xid_t qualified based(pDummy);
  formatID     int(10);
  gtrid_length int(10);
  bqual_length int(10);
  data         char(128);
end-ds;

dcl-c XIDDATASIZE 128;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//  External prototypes
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
/copy QEXPJRNE,CLIB2                         Prototypes of C-Library   Record IO
/copy QEXPJRNE,CEELIB                        Prototypes of CEE APIs
/copy QEXPJRNE,QUSRJOBI

//  memcpy -- Copy Bytes
//     The behavior is undefined if copying takes place
//     between objects that overlap.
//     The memcpy() function returns a pointer to dest.
//memcpy          pr              *          extproc('memcpy')
// i_pDest                        *   value
// i_pSrc                         *   value
// i_count                      10u 0 value
//
//  Convert Hex to Character (CVTHC)
//cvthc...
//                pr                  extproc('cvthc')
// pResult                        *   value
// pSource                        *   value
// sourceSize                   10i 0 value
//
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//  Exported prototypes
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
dcl-pr EXPJRNER3 extpgm('EXPJRNER3');
  gi_buffer   char(65535) options(*varsize);
  gio_control likeds(control_t);
end-pr;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//  Internal prototypes
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
dcl-pr p_main extproc('p_main');
  i_buffer   char(65535) options(*varsize);
  io_control likeds(control_t);
end-pr;

//  Shrink sequence number to 4-byte Integer.
dcl-pr shrinkSeqNbr zoned(10) extproc('shrinkSeqNbr');
  i_seqNbr    uns(20) value;
  i_fieldName char(10) value;
end-pr;

//  Converts a 4-byte hex value to an IPv4 address.
dcl-pr cvtToIPv4 char(15) extproc('cvtToIPv4');
  i_bytes char(4) const;
end-pr;

//  Converts a 16-byte hex value to an IPv6 address.
dcl-pr cvtToIPv6 char(39) extproc('cvtToIPv6');
  i_bytes char(16) value;
end-pr;

//  Returns the job number.
dcl-pr getJONBR zoned(6) extproc('getJONBR');
  i_RJNE0200 likeds(RJNE0200_t) options(*varsize) const;
end-pr;

//  Returns the name of the journal object.
dcl-pr getJOOBJ char(10) extproc('getJOOBJ');
  i_RJNE0200 likeds(RJNE0200_t) options(*varsize) const;
end-pr;

//  Returns the name of the library where the
//  journaled object is stored.
dcl-pr getJOLIB char(10) extproc('getJOOBJ');
  i_RJNE0200 likeds(RJNE0200_t) options(*varsize) const;
end-pr;

//  Returns the name of the journaled member.
dcl-pr getJOMBR char(10) extproc('getJOMBR');
  i_RJNE0200 likeds(RJNE0200_t) options(*varsize) const;
end-pr;

//  Returns the value of the 'Minimized ESD' flag.
dcl-pr getJOMINESD char(1) extproc('getJOMINESD');
  i_RJNE0200 likeds(RJNE0200_t) options(*varsize) const;
end-pr;

//  Returns the value of the 'File type indicator' flag.
dcl-pr getJOFILTYP char(1) extproc('getJOFILTYP');
  i_RJNE0200 likeds(RJNE0200_t) options(*varsize) const;
end-pr;

//  Returns the value of the 'Referential Constraint' flag.
dcl-pr getJORCST char(1) extproc('getJORCST');
  i_RJNE0200 likeds(RJNE0200_t) options(*varsize) const;
end-pr;

//  Returns the value of the 'Trigger' flag.
dcl-pr getJOTGR char(1) extproc('getJOTGR');
  i_RJNE0200 likeds(RJNE0200_t) options(*varsize) const;
end-pr;

//  Returns the value of the 'Incomplete data' flag.
dcl-pr getJOINCDAT char(1) extproc('getJOINCDAT');
  i_RJNE0200 likeds(RJNE0200_t) options(*varsize) const;
end-pr;

//  Returns the value of the
//  'Ignored during APYJRNCHG or RMVJRNCHG' flag.
dcl-pr getJOIGNAPY char(1) extproc('getJOIGNAPY');
  i_RJNE0200 likeds(RJNE0200_t) options(*varsize) const;
end-pr;

//  Returns the value of the 'Null value indicator' flag.
dcl-pr getJONVI like(nullValueInd_t.indicators) extproc('getJONVI');
  i_pRJNE0200 pointer const;
end-pr;

//  Map journal entries to common format.
dcl-pr mapJrnE extproc('mapJrnE');
  i_JOCODE char(1) const;
  i_JOENTT char(2) const;
  i_pData  pointer const;
  i_length int(10) const;
end-pr;

//  Map journal entry E EB.
dcl-pr mapJrnE_E_EB extproc('mapJrnE_E_EB');
  i_pData  pointer const;
  i_length int(10) const;
end-pr;

//  Map journal entry E EA.
dcl-pr mapJrnE_E_EA extproc('mapJrnE_E_EA');
  i_pData  pointer const;
  i_length int(10) const;
end-pr;

//  Map journal entry E EE.
dcl-pr mapJrnE_E_EE extproc('mapJrnE_E_EE');
  i_pData  pointer const;
  i_length int(10) const;
end-pr;

//  Map journal entry Q QS.
dcl-pr mapJrnE_Q_QS extproc('mapJrnE_Q_QS');
  i_pData  pointer const;
  i_length int(10) const;
end-pr;

//  Map journal entry Q QR.
dcl-pr mapJrnE_Q_QR extproc('mapJrnE_Q_QR');
  i_pData  pointer const;
  i_length int(10) const;
end-pr;

//  Map journal entry Q QK.
dcl-pr mapJrnE_Q_QK extproc('mapJrnE_Q_QK');
  i_pData  pointer const;
  i_length int(10) const;
end-pr;

//  Map journal entry Q QL to common data queue journal entry.
dcl-pr mapJrnE_Q_QL extproc('mapJrnE_Q_QL');
  i_pData  pointer const;
  i_length int(10) const;
end-pr;

//  Map journal entry Q QJ to common data queue journal entry.
dcl-pr mapJrnE_Q_QJ extproc('mapJrnE_Q_QJ');
  i_pData  pointer const;
  i_length int(10) const;
end-pr;

//  Map journal entry Q QC to common data queue journal entry.
dcl-pr mapJrnE_Q_QC extproc('mapJrnE_Q_QC');
  i_pData  pointer const;
  i_length int(10) const;
end-pr;

//  Ensures that memory boundaries are noticed.
dcl-pr enforceBoundaries extproc('enforceBoundaries');
  i_pData  pointer const;
  i_length int(10) const;
  i_pValue pointer const;
  i_size   int(10) const;
end-pr;

//  Produces an initialized record for a given file.
dcl-pr crtEntryDataInitialized char(32766) extproc('crtEntryDataInitialized');
  i_file       char(10) const;
  i_lib        char(10) const;
  i_lastJrnFld char(10) const;
end-pr;

//  Produces an initialized record for a given file.
dcl-pr cvtLargeObjectFieldData extproc('cvtLargeObjectFieldData');
  i_file       char(10) const;
  i_lib        char(10) const;
  i_lastJrnFld char(10) const;
  io_data      char(32766);
end-pr;

//  Converts a DTS timestamp to an ISO timestamp.
dcl-pr cvtDtsToIso timestamp extproc('cvtDtsToIso');
  i_dtsTmStmp uns(20) value;
end-pr;

//  Returns TRUE for a batch job, else FALSE.
dcl-pr isBatchJob ind extproc('isBatchJob');
end-pr;

//  Closes the output file
dcl-pr closeOutputFile extproc('closeOutputFile');
end-pr;

//  Abnormal end procedure:   terminate export
dcl-pr AbnEnd_terminateExport extproc('AbnEnd_terminateExport');
  i_pRtxToken pointer const;
end-pr;
/if not defined(*V5R3M0)                                                              //

//  Returns the bit-wise ANDing of the arguments.
dcl-pr bitAND uns(10) extproc('bitAND');
  i_arg1 uns(10) value;
  i_arg2 uns(10) value;
end-pr;
/endif

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//  Imported prototypes
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
/copy QBASICS1,PBASICS1
/copy QRTVFLDA,PRTVFLDA
/copy QEXPJRNE,JRNETYPES

/define EXPJRNE_PROTOTYPE
/copy QEXPJRNE,EXPJRNER7                    Tool: EXPJRNE Utilities
/undefine EXPJRNE_PROTOTYPE

dcl-pr QWCCVTDT extpgm('QWCCVTDT');
  i_inFormat  char(10) const;
  i_inValue   char(65535) options(*varsize) const;
  i_outFormat char(10) const;
  o_outValue  char(65535) options(*varsize);
  io_errCode  char(65535) options(*varsize);
end-pr;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//  Global fields and constants
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
dcl-s g_nextInfoMsg timestamp inz(*loval);
dcl-s g_isBatchJob ind inz(cTrue);

dcl-ds g_file qualified;
  isOpen ind inz(cFalse);
  name   varchar(64) inz;
  pRFile pointer inz;
end-ds;

dcl-c cINFO_MSG_INTERVAL 15;

dcl-ds g_overflow qualified;
  status    int(5) inz(OVF_INIT);
  fieldName char(10);
end-ds;

dcl-c OVF_INIT 0;
dcl-c OVF_NOT_SET 1;
dcl-c OVF_SET 2;

//=====================================================================*
//  Program entry point
//  gio_control:

//  Byte 1 (Passed to the Exit Program):
//  0 - No journal entry is passed on this call of the exit program.
//  1 - A single journal entry is passed to the exit program.
//  2 - A block of one or more journal entries is passed to the exit program.
//  3 - No journal entry is passed on this call to the exit program, and no
//      more entries can be passed, because the journal receiver that was
//      attached when the receive journal entry operation started is no longer
//      attached.
//      Note: The system ends the RCVJRNE command after calling the exit
//            program once with a reason code of 3.
//  4 - No journal entry is passed on this call to the exit program, and no
//      more entries can be passed unless the remote journal is activated.
//      Note: This value can only be passed to the exit program when
//            receiving journal entries from the attached receiver of a
//            remote journal and the journal state for the journal is
//            currently *INACTIVE.

//  Byte 1 (Passed to the System from the Exit Program):
//  8 - Requests the command processing program to start passing one or
//      more journal entries in a block. If BLKLEN(*NONE) was not
//      specified, then specifying 8 in the first byte of the second
//      parameter will have no effect and the first 5 bytes of the first
//      parameter will be ignored.
//  9 - Requests the RCVJRNE command to end. The exit program returns
//      control to the system.

//  Byte 2 (Passed to the Exit Program):
//  N - Additional journal entries are not currently available to be
//      passed after this call of the exit program, or the RCVJRNE
//      command will be ending after this call of the exit program.
//  Y - Additional journal entries are currently available to be passed
//      after this call of the exit program.

//  Byte 3 (Passed to the Exit Program):
//  x'00' - One or more journal entries are being passed to the exit
//      program and the object names in the fixed length portion of
//      each journal entry do not necessarily reflect the name of the
//      object at the time the journal entry was deposited into the
//      journal.
//      Note: This value is returned only when receiving journal
//            entries from a journal receiver that was attached to a
//            journal prior to V4R2M0.
//  0 - No journal entries are currently being passed, so the
//      information normally returned in this byte is not applicable.
//  1 - One or more journal entries are being passed to the exit
//      program and the object names in the fixed length portion of
//      each journal entry reflect the name of the object at the time
//      the journal entry was deposited into the journal.
//  2 - One or more journal entries are being passed to the exit
//      program and the object names in the fixed length portion of
//      each journal entry do not necessarily reflect the name of the
//      object at the time the journal entry was deposited into the
//      journal. The object name in the fixed length portion of the
//      journal entry may be returned as a previously known name for
//      the object prior to the journal entry being deposited into the
//      journal or be returned as *UNKNOWN.
//      Note: This value will only be returned when receiving journal
//            entries from a remote journal and the remote journal is
//            currently being caught up from its source journal. A
//            remote journal is being caught up from its source journal
//            when the Change Remote Journal (CHGRMTJRN) command or
//            Change Journal State (QjoChangeJournalState) API is
//            invoked and is currently replicating journal entries to
//            the remote journal. After the call to the CHGRMTJRN
//            command or QjoChangeJournalState API returns, the remote
//            journal is maintained with a synchronous or asynchronous
//            delivery mode, and the remote journal is no longer being
//            caught up.
//  3 - One or more journal entries are being passed to the exit
//      program and the object names in the fixed length portion of
//      each journal entry do not necessarily reflect the name of the
//      object at the time the journal entry was deposited into the
//      journal. The object name in the fixed length portion of the
//      journal entry may be returned as *UNKNOWN.
//=====================================================================*
dcl-pi EXPJRNER3;
  gi_buffer   char(65535) options(*varsize);
  gio_control likeds(control_t);
end-pi;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

CEERTX(%paddr('AbnEnd_terminateExport'): *NULL: *omit);

p_main(gi_buffer: gio_control);

CEEUTX(%paddr('AbnEnd_terminateExport'): *omit);

return;

begsr *pssr;

  AbnEnd_terminateExport(*NULL);

  *inlr = *on;

endsr '*CANCL';


//====================================================================
//  Main control block with local fields
//====================================================================

dcl-proc p_main;
  dcl-pi *n;
    i_buffer   char(65535) options(*varsize);
    io_control likeds(control_t);
  end-pi;

  //  Local fields
  dcl-s offsJOESD int(10) inz;
  dcl-s fixLength int(10) inz;
  dcl-s dataLength int(10) inz;
  dcl-s maxDataLength int(10) inz;
  dcl-ds msg likeds(msg_t) inz;
  dcl-ds infoMsg likeds(msg_t) inz;

  //  Outfile attributes passed in via environment variables
  dcl-ds outFile qualified;
    name      char(10) inz;
    lib       char(10) inz;
    mbr       char(10) inz;
    outFilFmt char(10) inz;
  end-ds;

  //  Write counter
  dcl-s numWrites int(10) inz static;

  //  Error counter
  dcl-s numErrors int(10) inz static;

  //  File handle and IO feedback area
  dcl-ds rFile likeds(RFILE_t) based(g_file.pRFile);
  dcl-s pRIOFB pointer inz static;
  dcl-ds rIOFB likeds(RIOFB_t) based(pRIOFB);

  //  I-Buffer (prepared for **free)
  dcl-ds dsQADSPJRN extname('QADSPJRN') based(pdsQADSPJRN) qualified;
  end-ds;
  dcl-ds dsQADSPJR2 extname('QADSPJR2') based(pdsQADSPJR2) qualified;
  end-ds;

  // dsQADSPJR3:
  //  Journal entry header information
  dcl-ds header qualified based(pHeader);
    bytRet        uns(10);
    ofsJrnE       uns(10);
    numE          uns(10);
    contID        char(1);
    contStrRcv    char(10);
    contStrRcvLib char(10);
    contStrSeqNbr char(20);
    reserved      char(12);
  end-ds;

  //  Journal entry data
  dcl-ds RJNE0200 likeds(RJNE0200_t) based(pRJNE0200);

  //  Entry data information
  dcl-ds entryData qualified based(pEntryData);
    length   zoned(5);
    reserved char(11);
    value    char(65519);
  end-ds;

  //  Empty data structures
  dcl-ds clearEntryData likeds(entryData) inz;

  //  Receiver information
  dcl-ds receiverInf likeds(receiverInf_t) based(pReceiverInf);
  dcl-ds clearReceiverInf likeds(receiverInf_t) inz;

  //  Logical unit of work information
  dcl-ds logicalUnitOfWork likeds(luw_t) based(pLogicalUnitOfWork);
  dcl-ds clearLogicalUnitOfWork likeds(luw_t) inz;

  //  Transaction ID
  dcl-ds transactionId likeds(xid_t) based(pTransactionId);
  dcl-ds clearTransactionId likeds(xid_t) inz;

  //  O-Buffer (prepared for **free)
  dcl-s dsBuffer_O char(32766);
  dcl-s pBuffer pointer inz(%addr(dsBuffer_O));
  dcl-ds dsQADSPJRN_O extname('QADSPJRN') based(pBuffer) qualified;
  end-ds;
  dcl-ds dsQADSPJR2_O extname('QADSPJR2') based(pBuffer) qualified;
  end-ds;
  dcl-ds dsQADSPJR3_O extname('QADSPJR3') based(pBuffer) qualified;
  end-ds;
  dcl-ds dsQADSPJR4_O extname('QADSPJR4') based(pBuffer) qualified;
  end-ds;
  dcl-ds dsQADSPJR5_O extname('QADSPJR5') based(pBuffer) qualified;
  end-ds;

  dcl-s JOSEQ2 zoned(20) based(pJOSEQ2);

  //  Messages
/copy QEXPJRNE,USR0012
/copy QEXPJRNE,USR0030
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  if (g_nextInfoMsg = *LOVAL);
    g_isBatchJob  = isBatchJob();
    if (g_isBatchJob);
      g_nextInfoMsg = *HIVAL;
    else;
      g_nextInfoMsg = %timestamp() + %seconds(cINFO_MSG_INTERVAL);
    endif;
  endif;

  // Reset field overflow data structure
  if (g_overflow.status = OVF_INIT);
    clear g_overflow;
    g_overflow.status = OVF_NOT_SET;
  endif;

  // Let's look at the buffer
  pdsQADSPJRN = %addr(i_buffer);  // *TYPE1
  pdsQADSPJR2 = %addr(i_buffer);  // *TYPE2
  pHeader     = %addr(i_buffer);  // *TYPE3, *TYPE4, *TYPE5

  // Determine the outfile attributes
  outFile.name      = OutputFile_getName();
  outFile.lib       = OutputFile_getLibrary();
  outFile.mbr       = OutputFile_getMember();
  outFile.outFilFmt = OutputFile_getOutputFileFormat();

  // Open the output file
  if (not g_file.isOpen);
    g_file.name = %trimR(outFile.lib) + '/' + %trimR(outFile.name) +
                  '(' + %trimR(outFile.mbr) + ')';
    select;
    when outFile.outFilFmt = '*TYPE1';
      g_file.pRFile = Ropen(g_file.name
                            : 'ar, blkrcd=Y, ccsid=65535, secure=Y');
    when outFile.outFilFmt = '*TYPE2';
      g_file.pRFile = Ropen(g_file.name
                            : 'ar, blkrcd=Y, ccsid=65535, secure=Y');
    when outFile.outFilFmt = '*TYPE3';
      g_file.pRFile = Ropen(g_file.name
                            : 'ar, blkrcd=Y, ccsid=65535, secure=Y');
    when outFile.outFilFmt = '*TYPE4';
      g_file.pRFile = Ropen(g_file.name
                            : 'ar, blkrcd=Y, ccsid=65535, secure=Y');
    when outFile.outFilFmt = '*TYPE5';
      g_file.pRFile = Ropen(g_file.name
                            : 'ar, blkrcd=Y, ccsid=65535, secure=Y');
    endsl;
    // Remove diagnostic message CPF4011 from message queue
    f_rcvPgmMsg(cMsg_Diag: *omit: cMsg_Act_Rmv);
    // Initialize write counter
    numWrites = 0;
    // Initialize errror counter
    numErrors = 0;
    // Set open indicator
    if (g_file.pRFile <> *NULL);
      g_file.isOpen = cTrue;
    endif;
  endif;

  // A single journal entry is being passed on this call
  // of the exit program ...
  if io_control.byte1 = '1';

    // ... hence process that entry.
    pRIOFB = *null;

    select;
    when outFile.outFilFmt = '*TYPE1';

      // Clear output buffer
      dsBuffer_O = *all'x00';
      clear dsQADSPJRN_O;

      // Set output data
      fixLength  = %addr(dsQADSPJRN.JOESD) - %addr(dsQADSPJRN);
      dataLength = dsQADSPJRN.JOENTL - fixLength;
      // dsQADSPJRN_O = %subst(dsQADSPJRN: 1: dsQADSPJRN.JOENTL);
      memcpy(
       %addr(dsBuffer_O): %addr(dsQADSPJRN): dsQADSPJRN.JOENTL);
      if (dataLength > 0);
        cvtLargeObjectFieldData(
           outFile.name: outFile.lib: 'JORES': dsBuffer_O);
        maxDataLength = %size(dsBuffer_O) - dataLength;
        mapJrnE(dsQADSPJRN_O.JOCODE: dsQADSPJRN_O.JOENTT
                : %addr(dsQADSPJRN_O.JOESD): maxDataLength);
      else;
        %subst(dsBuffer_O: fixLength + 1) =
           crtEntryDataInitialized(outFile.name: outFile.lib:'JORES');
      endif;
      pRIOFB = Rwrite(g_file.pRFile
                      : %addr(dsQADSPJRN_O): rFile.bufLen);

    when outFile.outFilFmt = '*TYPE2';

      // Clear output buffer
      dsBuffer_O = *all'x00';
      clear dsQADSPJR2_O;

      // Set output data
      fixLength  = %addr(dsQADSPJR2.JOESD) - %addr(dsQADSPJR2);
      dataLength = dsQADSPJR2.JOENTL - fixLength;
      // dsQADSPJR2_O = %subst(dsQADSPJR2: 1: dsQADSPJR2.JOENTL);
      memcpy(
       %addr(dsBuffer_O): %addr(dsQADSPJR2): dsQADSPJR2.JOENTL);
      if (dataLength > 0);
        cvtLargeObjectFieldData(
           outFile.name: outFile.lib: 'JORES': dsBuffer_O);
        maxDataLength = %size(dsBuffer_O) - dataLength;
        mapJrnE(dsQADSPJR2_O.JOCODE: dsQADSPJR2_O.JOENTT
                : %addr(dsQADSPJR2_O.JOESD): maxDataLength);
      else;
        %subst(dsBuffer_O: fixLength + 1) =
           crtEntryDataInitialized(outFile.name: outFile.lib:'JORES');
      endif;
      pRIOFB = Rwrite(g_file.pRFile
                      : %addr(dsQADSPJR2_O): rFile.bufLen);

    when outFile.outFilFmt = '*TYPE3';

      // Get access to the retrieved journal entry
      pRJNE0200 = pHeader + header.ofsJrnE;

      // Get access to the entry data
      if RJNE0200.ofsEntData > 0;
        pEntryData = pRJNE0200 + RJNE0200.ofsEntData;
      else;
        pEntryData = %addr(clearEntryData);
      endif;

      // Clear output buffer
      dsBuffer_O = *all'x00';
      clear dsQADSPJR3_O;

      // Set output data
      dsQADSPJR3_O.JOENTL   = entryData.length +
                              (%addr(dsQADSPJR3_O.JOESD) -
                               %addr(dsQADSPJR3_O));
      dsQADSPJR3_O.JOSEQN   = shrinkSeqNbr(RJNE0200.seqNbr: 'JOSEQN');
      dsQADSPJR3_O.JOCODE   = RJNE0200.jrnCode;
      dsQADSPJR3_O.JOENTT   = RJNE0200.entryType;
      dsQADSPJR3_O.JOTSTP   = cvtDtsToIso(RJNE0200.timestamp);
      dsQADSPJR3_O.JOJOB    = RJNE0200.job;
      dsQADSPJR3_O.JOUSER   = RJNE0200.user;
      dsQADSPJR3_O.JONBR    = getJONBR(RJNE0200);
      dsQADSPJR3_O.JOPGM    = RJNE0200.pgm;
      dsQADSPJR3_O.JOOBJ    = getJOOBJ(RJNE0200);
      dsQADSPJR3_O.JOLIB    = getJOLIB(RJNE0200);
      dsQADSPJR3_O.JOMBR    = GETJOMBR(RJNE0200);
      dsQADSPJR3_O.JOCTRR   = RJNE0200.rrn;
      dsQADSPJR3_O.JOFLAG   = RJNE0200.indFlag;
      dsQADSPJR3_O.JOCCID   = RJNE0200.cmtCycleID;
      dsQADSPJR3_O.JOUSPF   = RJNE0200.userProfile;
      dsQADSPJR3_O.JOSYNM   = RJNE0200.system;

      dsQADSPJR3_O.JOINCDAT = getJOINCDAT(RJNE0200);
      dsQADSPJR3_O.JOMINESD = getJOMINESD(RJNE0200);
      dsQADSPJR3_O.JONVI    = getJONVI(%addr(RJNE0200));

      dsQADSPJR3_O.JORES    = '';

      pJOSEQ2 = %addr(dsQADSPJR3_O.JOESD);
      JOSEQ2 = RJNE0200.seqNbr;

      // Compute offset for entry data
      offsJOESD = %addr(dsQADSPJR3_O.JONVI)
                  - %addr(dsQADSPJR3_O)
                  + %size(dsQADSPJR3_O.JONVI)
                  + %size(JOSEQ2);

      // Set entry data
      if entryData.length = 0;
        %subst(dsBuffer_O: offsJOESD+1) =
           crtEntryDataInitialized(outFile.name:outFile.lib:'JONVI');
      else;
        %subst(dsBuffer_O: offsJOESD+1) =
           %subst(entryData.value: 1: entryData.length);
      endif;

      if // (dsQADSPJR3_O.JOINCDAT = '1') or   // Incomplete data, e.g. CLOB/BLOB
         (dsQADSPJR3_O.JOMINESD = '1');     // Minimized ESD
        numErrors = numErrors + 1;
      else;
        dataLength = entryData.length;
        if (dataLength > 0);
          cvtLargeObjectFieldData(
             outFile.name: outFile.lib: 'JORES': dsBuffer_O);
          maxDataLength = %size(dsBuffer_O) - dataLength;
          mapJrnE(dsQADSPJR3_O.JOCODE: dsQADSPJR3_O.JOENTT
                  : %addr(dsQADSPJR3_O.JOESD): maxDataLength);
        endif;
        pRIOFB = Rwrite(g_file.pRFILE
                        : %addr(dsQADSPJR3_O): rFile.bufLen);
      endif;

    when outFile.outFilFmt = '*TYPE4';

      // Get access to the retrieved journal entry
      pRJNE0200 = pHeader + header.ofsJrnE;

      // Get access to the entry data
      if RJNE0200.ofsEntData > 0;
        pEntryData = pRJNE0200 + RJNE0200.ofsEntData;
      else;
        pEntryData = %addr(clearEntryData);
      endif;

      // Clear output buffer
      dsBuffer_O = *all'x00';
      clear dsQADSPJR4_O;

      // Set output data
      dsQADSPJR4_O.JOENTL   = entryData.length +
                              (%addr(dsQADSPJR4_O.JOESD) -
                               %addr(dsQADSPJR4_O));
      dsQADSPJR4_O.JOSEQN   = shrinkSeqNbr(RJNE0200.seqNbr: 'JOSEQN');
      dsQADSPJR4_O.JOCODE   = RJNE0200.jrnCode;
      dsQADSPJR4_O.JOENTT   = RJNE0200.entryType;
      dsQADSPJR4_O.JOTSTP   = cvtDtsToIso(RJNE0200.timestamp);
      dsQADSPJR4_O.JOJOB    = RJNE0200.job;
      dsQADSPJR4_O.JOUSER   = RJNE0200.user;
      dsQADSPJR4_O.JONBR    = getJONBR(RJNE0200);
      dsQADSPJR4_O.JOPGM    = RJNE0200.pgm;
      dsQADSPJR4_O.JOOBJ    = getJOOBJ(RJNE0200);
      dsQADSPJR4_O.JOLIB    = getJOLIB(RJNE0200);
      dsQADSPJR4_O.JOMBR    = GETJOMBR(RJNE0200);
      dsQADSPJR4_O.JOCTRR   = RJNE0200.rrn;
      dsQADSPJR4_O.JOFLAG   = RJNE0200.indFlag;
      dsQADSPJR4_O.JOCCID   = RJNE0200.cmtCycleID;
      dsQADSPJR4_O.JOUSPF   = RJNE0200.userProfile;
      dsQADSPJR4_O.JOSYNM   = RJNE0200.system;

      dsQADSPJR4_O.JOINCDAT = getJOINCDAT(RJNE0200);
      dsQADSPJR4_O.JOMINESD = getJOMINESD(RJNE0200);
      dsQADSPJR4_O.JONVI    = getJONVI(%addr(RJNE0200));

      dsQADSPJR4_O.JORCST   = getJORCST(RJNE0200);
      dsQADSPJR4_O.JOTGR    = getJOTGR(RJNE0200);
      dsQADSPJR4_O.JOIGNAPY = getJOIGNAPY(RJNE0200);
      dsQADSPJR4_O.JOJID    = RJNE0200.journalID;

      dsQADSPJR4_O.JORES    = '';

      pJOSEQ2 = %addr(dsQADSPJR3_O.JOESD);
      JOSEQ2 = RJNE0200.seqNbr;

      // Compute offset for entry data
      offsJOESD = %addr(dsQADSPJR4_O.JONVI)
                  - %addr(dsQADSPJR4_O)
                  + %size(dsQADSPJR4_O.JONVI)
                  + %size(JOSEQ2);

      // Set entry data
      if entryData.length = 0;
        %subst(dsBuffer_O: offsJOESD+1) =
           crtEntryDataInitialized(outFile.name:outFile.lib:'JONVI');
      else;
        %subst(dsBuffer_O: offsJOESD+1) =
           %subst(entryData.value: 1: entryData.length);
      endif;

      if // (dsQADSPJR4_O.JOINCDAT = '1') or   // Incomplete data, e.g. CLOB/BLOB
         (dsQADSPJR4_O.JOMINESD = '1');     // Minimized ESD
        numErrors = numErrors + 1;
      else;
        dataLength = entryData.length;
        if (dataLength > 0);
          cvtLargeObjectFieldData(
             outFile.name: outFile.lib: 'JORES': dsBuffer_O);
          maxDataLength = %size(dsBuffer_O) - dataLength;
          mapJrnE(dsQADSPJR4_O.JOCODE: dsQADSPJR4_O.JOENTT
                  : %addr(dsQADSPJR4_O.JOESD): maxDataLength);
        endif;
        pRIOFB = Rwrite(g_file.pRFILE
                        : %addr(dsQADSPJR4_O): rFile.bufLen);
      endif;

    when outFile.outFilFmt = '*TYPE5';

      // Get access to the retrieved journal entry
      pRJNE0200 = pHeader + header.ofsJrnE;

      // Get access to the entry data
      if RJNE0200.ofsEntData > 0;
        pEntryData = pRJNE0200 + RJNE0200.ofsEntData;
      else;
        pEntryData = %addr(clearEntryData);
      endif;

      // Clear output buffer
      dsBuffer_O = *all'x00';
      clear dsQADSPJR5_O;

      // Set output data
      dsQADSPJR5_O.JOENTL   = entryData.length +
                              (%addr(dsQADSPJR5_O.JOESD) -
                               %addr(dsQADSPJR5_O));
      dsQADSPJR5_O.JOSEQN   = %editc(RJNE0200.seqNbr: 'X');
      dsQADSPJR5_O.JOCODE   = RJNE0200.jrnCode;
      dsQADSPJR5_O.JOENTT   = RJNE0200.entryType;
      dsQADSPJR5_O.JOTSTP   = cvtDtsToIso(RJNE0200.timestamp);
      dsQADSPJR5_O.JOJOB    = RJNE0200.job;
      dsQADSPJR5_O.JOUSER   = RJNE0200.user;
      dsQADSPJR5_O.JONBR    = getJONBR(RJNE0200);
      dsQADSPJR5_O.JOPGM    = RJNE0200.pgm;
      dsQADSPJR5_O.JOOBJ    = getJOOBJ(RJNE0200);
      dsQADSPJR5_O.JOLIB    = getJOLIB(RJNE0200);
      dsQADSPJR5_O.JOMBR    = GETJOMBR(RJNE0200);
      dsQADSPJR5_O.JOCTRR   = %editc(RJNE0200.rrn: 'X');
      dsQADSPJR5_O.JOFLAG   = RJNE0200.indFlag;
      dsQADSPJR5_O.JOCCID   = %editc(RJNE0200.cmtCycleID: 'X');
      dsQADSPJR5_O.JOUSPF   = RJNE0200.userProfile;
      dsQADSPJR5_O.JOSYNM   = RJNE0200.system;

      dsQADSPJR5_O.JOINCDAT = getJOINCDAT(RJNE0200);
      dsQADSPJR5_O.JOMINESD = getJOMINESD(RJNE0200);
      dsQADSPJR5_O.JONVI    = getJONVI(%addr(RJNE0200));

      dsQADSPJR5_O.JORCST   = getJORCST(RJNE0200);
      dsQADSPJR5_O.JOTGR    = getJOTGR(RJNE0200);
      dsQADSPJR5_O.JOIGNAPY = getJOIGNAPY(RJNE0200);
      dsQADSPJR5_O.JOJID    = RJNE0200.journalID;

      dsQADSPJR5_O.JOOBJIND = RJNE0200.objnameID;
      dsQADSPJR5_O.JOSYSSEQ = %editc(RJNE0200.sysSeqNbr: 'X');

      if RJNE0200.ofsRcvInf > 0;
        pReceiverInf = %addr(RJNE0200) + RJNE0200.ofsRcvInf;
      else;
        pReceiverInf = %addr(clearReceiverInf);
      endif;

      dsQADSPJR5_O.JORCV    = receiverInf.rcvName;
      dsQADSPJR5_O.JORCVLIB = receiverInf.rcvLibName;
      dsQADSPJR5_O.JORCVDEV = receiverInf.rcvASPDev;
      dsQADSPJR5_O.JORCVASP = receiverInf.rcvASPNbr;

      dsQADSPJR5_O.JOARM    = RJNE0200.armNbr;
      memcpy(%addr(dsQADSPJR5_O.JOTHD)
             : %addr(RJNE0200.threadID)
             : %size(dsQADSPJR5_O.JOTHD));
      cvthc(%addr(dsQADSPJR5_O.JOTHDX)
            : %addr(dsQADSPJR5_O.JOTHD)
            : %size(dsQADSPJR5_O.JOTHDX));
      dsQADSPJR5_O.JOADF    = RJNE0200.adrFamily;
      dsQADSPJR5_O.JORPORT  = RJNE0200.rmtPort;

      select;
      when dsQADSPJR5_O.JOADF = '4'; // IPv4
        if %subst(RJNE0200.rmtAdr: 5) = *ALLx'00';
          // Bug. PMR: PMR 33254,031,724
          dsQADSPJR5_O.JORADR =
             cvtToIPv4(%subst(RJNE0200.rmtAdr: 1: 4));
        else;
          dsQADSPJR5_O.JORADR = RJNE0200.rmtAdr;
        endif;
      when dsQADSPJR5_O.JOADF = '6'; // IPv6
        if %subst(RJNE0200.rmtAdr: 1: 12) =
              x'00000000000000000000FFFF';
          // Embedded IPv4 address: https://de.wikipedia.org/wiki/IPv6
          dsQADSPJR5_O.JOADF = '4';
          dsQADSPJR5_O.JORADR =
             cvtToIPv4(%subst(RJNE0200.rmtAdr: 13: 4));
        else;
          dsQADSPJR5_O.JORADR = cvtToIPv6(RJNE0200.rmtAdr);
        endif;
      other;
        dsQADSPJR5_O.JORADR = '';
      endsl;

      if RJNE0200.ofsLglUnitWrk > 0;
        pLogicalUnitOfWork = %addr(RJNE0200) + RJNE0200.ofsLglUnitWrk;
      else;
        pLogicalUnitOfWork = %addr(clearLogicalUnitOfWork);
      endif;

      dsQADSPJR5_O.JOLUW = logicalUnitOfWork.id;

      if RJNE0200.ofsTransactID > 0;
        pTransactionId = %addr(RJNE0200) + RJNE0200.ofsTransactID;
      else;
        pTransactionId = %addr(clearTransactionId);
      endif;

      dsQADSPJR5_O.JOXID = transactionId.data;

      dsQADSPJR5_O.JOOBJTYP = RJNE0200.objType;
      dsQADSPJR5_O.JOFILTYP = getJOFILTYP(RJNE0200);
      dsQADSPJR5_O.JOCMTLVL = %editc(%dec(
                                 RJNE0200.nestedCmtLvl: 7: 0): 'X');

      dsQADSPJR5_O.JORES = '';

      // Compute offset for entry data
      offsJOESD = %addr(dsQADSPJR5_O.JONVI)
                  - %addr(dsQADSPJR5_O)
                  + %size(dsQADSPJR5_O.JONVI);

      // Set entry data
      if entryData.length = 0;
        %subst(dsBuffer_O: offsJOESD+1) =
           crtEntryDataInitialized(outFile.name:outFile.lib:'JONVI');
      else;
        %subst(dsBuffer_O: offsJOESD+1) =
           %subst(entryData.value: 1: entryData.length);
      endif;

      if // (dsQADSPJR3_O.JOINCDAT = '1') or  // Incomplete data, e.g. CLOB/BLOB
         (dsQADSPJR5_O.JOMINESD = '1');       // Minimized ESD
        numErrors = numErrors + 1;
      else;
        dataLength = entryData.length;
        if (dataLength > 0);
          cvtLargeObjectFieldData(
             outFile.name: outFile.lib: 'JORES': dsBuffer_O);
          maxDataLength = %size(dsBuffer_O) - dataLength;
          mapJrnE(dsQADSPJR5_O.JOCODE: dsQADSPJR5_O.JOENTT
                  : %addr(dsQADSPJR5_O.JOESD): maxDataLength);
        endif;
        pRIOFB = Rwrite(g_file.pRFILE
                        : %addr(dsQADSPJR5_O): rFile.bufLen);
      endif;
    endsl;

    // Check for IO errors.
    if (pRIOFB = *null or rIOFB.numByt <> rFile.bufLen);
      msg = f_newMsg('USR0016': '': cMsg_Escape);
      Message_sendEscapeMsg(msg);
    else;
      numWrites = numWrites + 1;
    endif;

    // Periodically send an information message (non batch jobs).
    if (not g_isBatchJob and %timestamp() > g_nextInfoMsg);
      clear USR0012;
      USR00121 = numWrites;
      infoMsg = f_newMsg('USR0012': USR0012: cMsg_Status);
      f_sndPgmMsg(infoMsg: cMsg_Ext);
      g_nextInfoMsg = %timestamp() + %seconds(cINFO_MSG_INTERVAL);
    endif;
  endif;

  // Additional journal entries are not currently available
  // to be passed after this call of the exit program ...
  if io_control.byte2 = 'N';
    // ... hence end the RCVJRNE command.
    io_control.byte1 = '9';

    // Close the output file
    closeOutputFile();

    // Send diagnostic message due to errors
    if numErrors > 0;
      f_setEnvVar('EXPJRNE_NUM_ERRORS': %char(numErrors));
    endif;

    // Send field overflow warning message
    if (g_overflow.status = OVF_SET);
      clear USR0030;
      USR00301 = g_overflow.fieldName;
      msg = f_newMsg('USR0030': USR0030: cMsg_Info);
      f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToPgmBdy);
    endif;

    // Unload program
    *inlr = *on;
  endif;

end-proc;

//====================================================================
//  *** private ***
//  Shrink sequence number to 4-byte Integer.
//  Useed for avoiding a value overflow error when assigning a
//  8-byte unsigned integer value to a zoned(10,0) field.
//====================================================================
dcl-proc shrinkSeqNbr;
  dcl-pi *n zoned(10);
    i_seqNbr    uns(20) value;
    i_fieldName char(10) value;
  end-pi;

  dcl-c MAX_VALUE 9999999999;

  dcl-s newValue zoned(10);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  if (i_seqNbr <= MAX_VALUE);
    return i_seqNbr;
  else;
    if (g_overflow.status = OVF_NOT_SET);
      g_overflow.status = OVF_SET;
      g_overflow.fieldName = i_fieldName;
    endif;
    newValue = -1;
    return newValue;
  endif;

end-proc;

//====================================================================
//  *** private ***
//  Converts a 4-byte hex value to an IPv4 address.
//====================================================================
dcl-proc cvtToIPv4;
  dcl-pi *n char(15);
    i_bytes char(4) const;
  end-pi;

  dcl-s ipv4 varchar(15);

  dcl-s i int(10);
  dcl-ds converter qualified;
    byte char(1);
    int  uns(3) overlay(byte);
  end-ds;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  for i = 1 to 4;
    converter.byte = %subst(i_bytes: i: 1);
    if (ipv4 <> '');
      ipv4 = ipv4 + '.';
    endif;
    ipv4 = ipv4 + %editc(converter.int: 'X');
  endfor;

  return ipv4;

end-proc;

//====================================================================
//  *** private ***
//  Converts a 16-byte hex value to an IPv6 address.
//====================================================================
dcl-proc cvtToIPv6;
  dcl-pi *n char(39);
    i_bytes char(16) value;
  end-pi;

  dcl-s ipv6 varchar(39);

  dcl-s offset int(10);
  dcl-s pSource pointer;
  dcl-s chunk char(4);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  offset = 0;

  dow offset < %size(i_bytes);
    pSource = %addr(i_bytes) + offset;
    cvthc(%addr(chunk)
          : pSource
          : %size(chunk));
    if (ipv6 <> '');
      ipv6 = ipv6 + ':';
    endif;
    ipv6 = ipv6 + chunk;
    offset = offset + 2;
  enddo;

  return ipv6;

end-proc;

//====================================================================
//  *** private ***
//  Returns the job number.
//====================================================================
dcl-proc getJONBR;
  dcl-pi *n zoned(6);
    i_RJNE0200 likeds(RJNE0200_t) options(*varsize) const;
  end-pi;

  dcl-s nbr zoned(6);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  nbr = %dec(i_RJNE0200.jobNbr: 6: 0);

  return nbr;

end-proc;

//====================================================================
//  *** private ***
//  Returns the job number.
//====================================================================
dcl-proc getJOOBJ;
  dcl-pi *n char(10);
    i_RJNE0200 likeds(RJNE0200_t) options(*varsize) const;
  end-pi;

  dcl-s obj char(10);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  obj = %subst(i_RJNE0200.object:  1: 10);

  return obj;

end-proc;

//====================================================================
//  *** private ***
//  Returns the job number.
//====================================================================
dcl-proc getJOLIB;
  dcl-pi *n char(10);
    i_RJNE0200 likeds(RJNE0200_t) options(*varsize) const;
  end-pi;

  dcl-s lib char(10);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  lib = %subst(i_RJNE0200.object: 11: 10);

  return lib;

end-proc;

//====================================================================
//  *** private ***
//  Returns the job number.
//====================================================================
dcl-proc getJOMBR;
  dcl-pi *n char(10);
    i_RJNE0200 likeds(RJNE0200_t) options(*varsize) const;
  end-pi;

  dcl-s mbr char(10);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  mbr = %subst(i_RJNE0200.object: 21: 10);

  return mbr;

end-proc;

//====================================================================
//  *** private ***
//  Returns the value of the 'Minimized ESD' flag.
//====================================================================
dcl-proc getJOMINESD;
  dcl-pi *n char(1);
    i_RJNE0200 likeds(RJNE0200_t) options(*varsize) const;
  end-pi;

  dcl-s minESD char(1);
  dcl-c MINESD_BIT x'08';
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/if defined(*V5R3M0)
  if %bitand(i_RJNE0200.flags: MINESD_BIT) = MINESD_BIT; // Set minimized ESD flag
    minESD = '1'; // This entry has minimized entry specific data.
  else;
    minESD = '0'; // This entry has complete entry specific data.
  endif;
/else
if bitAND(i_RJNE0200.flags: MINESD_BIT) = MINESD_BIT;  // Set minimized ESD flag
   minESD = '1'; // This entry has minimized entry specific data.
else;
   minESD = '0'; // This entry has complete entry specific data.
endif;
/endif

  return minESD;

end-proc;

//====================================================================
//  *** private ***
//  Returns the value of the 'File type indicator' flag.
//====================================================================
dcl-proc getJOFILTYP;
  dcl-pi *n char(1);
    i_RJNE0200 likeds(RJNE0200_t) options(*varsize) const;
  end-pi;

  dcl-s filTyp char(1);
  dcl-c FILTYP_BIT x'04';
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  if (i_RJNE0200.objType = '*FILE');
    // Returning 'L' and 'P', because that is what DSPJRN writes to an
    // output file.
    // PMR: 33254,031,724 (05.10.2018)
/if defined(*V5R3M0)
    if %bitand(i_RJNE0200.flags: FILTYP_BIT) = FILTYP_BIT; // Set file type indicator flag
      filTyp = 'L'; // This entry is associated with a logical file.
    else;
      filTyp = 'P'; // This entry is not associated with a logical file
    endif;
/else
   if bitAND(i_RJNE0200.flags: FILTYP_BIT) = FILTYP_BIT;  // Set file type indicator flag
      filTyp = 'L'; // This entry is associated with a logical file.
   else;
      filTyp = 'P'; // This entry is not associated with a logical file
   endif;
/endif
  else;
    filTyp = '';
  endif;

  return filTyp;

end-proc;

//====================================================================
//  *** private ***
//  Returns the value of the 'Referential Constraint' flag.
//====================================================================
dcl-proc getJORCST;
  dcl-pi *n char(1);
    i_RJNE0200 likeds(RJNE0200_t) options(*varsize) const;
  end-pi;

  dcl-s rcst char(1);
  dcl-c RCST_BIT x'80';
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/if defined(*V5R3M0)
  if %bitand(i_RJNE0200.flags: RCST_BIT) = RCST_BIT; // Set referential constraint flag
    rcst = '1'; // This entry was created as part of a referential constraint.
  else;
    rcst = '0'; // This entry was not created as part of a referential constraint.
  endif;
/else
if bitAND(i_RJNE0200.flags: RCST_BIT) = RCST_BIT;  // Set referential constraint flag
   rcst = '1'; // This entry was created as part of a referential constraint.
else;
   rcst = '0'; // This entry was not created as part of a referential constraint.
endif;
/endif

  return rcst;

end-proc;

//====================================================================
//  *** private ***
//  Returns the value of the 'Trigger' flag.
//====================================================================
dcl-proc getJOTGR;
  dcl-pi *n char(1);
    i_RJNE0200 likeds(RJNE0200_t) options(*varsize) const;
  end-pi;

  dcl-s tgr char(1);
  dcl-c TGR_BIT x'40';
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/if defined(*V5R3M0)
  if %bitand(i_RJNE0200.flags: TGR_BIT) = TGR_BIT; // Set trigger flag
    tgr = '1'; // This entry was created as the result of a trigger program.
  else;
    tgr = '0'; // This entry was not created as the result of a trigger program.
  endif;
/else
if bitAND(i_RJNE0200.flags: TGR_BIT) = TGR_BIT;  // Set trigger flag
   tgr = '1'; // This entry was created as the result of a trigger program.
else;
   tgr = '0'; // This entry was not created as the result of a trigger program.
endif;
/endif

  return tgr;

end-proc;

//====================================================================
//  *** private ***
//  Returns the value of the 'Incomplete data' flag.
//====================================================================
dcl-proc getJOINCDAT;
  dcl-pi *n char(1);
    i_RJNE0200 likeds(RJNE0200_t) options(*varsize) const;
  end-pi;

  dcl-s incDat char(1);
  dcl-c INCDAT_BIT x'20';
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/if defined(*V5R3M0)
  if %bitand(i_RJNE0200.flags: INCDAT_BIT) = INCDAT_BIT; // Set incomplete data flag
    incDat = '1'; // This entry does have pointers included.
  else;
    incDat = '0'; // This entry does not have any pointers included.
  endif;
/else
if bitAND(i_RJNE0200.flags: INCDAT_BIT) = INCDAT_BIT;  // Set incomplete data flag
   incDat = '1'; // This entry does have pointers included.
else;
   incDat = '0'; // This entry does not have any pointers included.
endif;
/endif

  return incDat;

end-proc;

//====================================================================
//  *** private ***
//  Returns the value of the
//  'Ignored during APYJRNCHG or RMVJRNCHG' flag.
//====================================================================
dcl-proc getJOIGNAPY;
  dcl-pi *n char(1);
    i_RJNE0200 likeds(RJNE0200_t) options(*varsize) const;
  end-pi;

  dcl-s ignApy char(1);
  dcl-c IGNAPY_BIT x'10';
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/if defined(*V5R3M0)
  if %bitand(i_RJNE0200.flags: IGNAPY_BIT) = IGNAPY_BIT; // Set ignored during APYJRNCHG
    ignApy = '1'; // This entry will be ignored during APYJRNCHG or RMVJRNCHG
  else;
    ignApy = '0'; // This entry will not be ignored during APYJRNCHG or RMVJRNCHG
  endif;
/else
if bitAND(i_RJNE0200.flags: IGNAPY_BIT) = IGNAPY_BIT;  // Set ignored during APYJRNCHG
   ignApy = '1'; // This entry will be ignored during APYJRNCHG or RMVJRNCHG
else;
   ignApy = '0'; // This entry will not be ignored during APYJRNCHG or RMVJRNCHG
endif;
/endif

  return ignApy;

end-proc;

//====================================================================
//  *** private ***
//  Returns the value of the 'Null value indicator' flag.
//====================================================================
dcl-proc getJONVI;
  dcl-pi *n like(nullValueInd_t.indicators);
    i_pRJNE0200 pointer const;
  end-pi;

  dcl-s nvi like(nullValueInd_t.indicators);

  dcl-ds RJNE0200 likeds(RJNE0200_t) based(i_pRJNE0200);

  //  Null value indicator information
  dcl-ds nullValueInd likeds(nullValueInd_t) based(pNullValueIndicator);
  dcl-ds clearNullValueInd likeds(nullValueInd) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  // Get access to null value indicators
  if RJNE0200.ofsNulValInd > 0;
    pNullValueIndicator = %addr(RJNE0200) + RJNE0200.ofsNulValInd;
  else;
    pNullValueIndicator = %addr(clearNullValueInd);
  endif;

  nvi = %subst(nullValueInd.indicators: 1: nullValueInd.length);

  return nvi;

end-proc;

//====================================================================
//  *** private ***
//  Map journal entries to common format.
//====================================================================
dcl-proc mapJrnE;
  dcl-pi *n;
    i_JOCODE char(1) const;
    i_JOENTT char(2) const;
    i_pData  pointer const;
    i_length int(10) const;
  end-pi;

  //  Local fields
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  select;
  when (i_JOCODE = 'Q' and // = data queue, send
        i_JOENTT = 'QS');
    mapJrnE_Q_QS(i_pData: i_length);
  when (i_JOCODE = 'Q' and // = data queue, receive
        i_JOENTT = 'QR');
    mapJrnE_Q_QR(i_pData: i_length);
  when (i_JOCODE = 'Q' and // = data queue, clear
        i_JOENTT = 'QC');
    mapJrnE_Q_QC(i_pData: i_length);
  when (i_JOCODE = 'Q' and // = data queue, send, keyed
        i_JOENTT = 'QK');
    mapJrnE_Q_QK(i_pData: i_length);
  when (i_JOCODE = 'Q' and // = data queue, receive, keyed
        i_JOENTT = 'QL');
    mapJrnE_Q_QL(i_pData: i_length);
  when (i_JOCODE = 'Q' and // = data queue, clear, keyed
        i_JOENTT = 'QJ');
    mapJrnE_Q_QJ(i_pData: i_length);
  when (i_JOCODE = 'E' and // = data area, create
        i_JOENTT = 'EE');
    mapJrnE_E_EE(i_pData: i_length);
  when (i_JOCODE = 'E' and // = data area, before
        i_JOENTT = 'EB');
    mapJrnE_E_EB(i_pData: i_length);
  when (i_JOCODE = 'E' and // = data area, after
        i_JOENTT = 'EA');
    mapJrnE_E_EA(i_pData: i_length);
  endsl;

end-proc;

//====================================================================
//  *** private ***
//  Map Update data area (E EB) journal entry
//  to common data area journal entry data structure.
//====================================================================
dcl-proc mapJrnE_E_EB;
  dcl-pi *n;
    i_pData  pointer const;
    i_length int(10) const;
  end-pi;

  //  Local fields
  dcl-ds jrnEType_e_eb likeds(jrnEType_e_eb_t) based(i_pData);
  dcl-ds jrnEType_e likeds(jrnEType_e_t) based(i_pData);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  // no mapping required
  p_assert(%size(jrnEType_e_eb) = %size(jrnEType_e));

end-proc;

//====================================================================
//  *** private ***
//  Map Update data area (E EA) journal entry
//  to common data area journal entry data structure.
//====================================================================
dcl-proc mapJrnE_E_EA;
  dcl-pi *n;
    i_pData  pointer const;
    i_length int(10) const;
  end-pi;

  //  Local fields
  dcl-ds jrnEType_e_ea likeds(jrnEType_e_ea_t) based(i_pData);
  dcl-ds jrnEType_e likeds(jrnEType_e_t) based(i_pData);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  // no mapping required
  p_assert(%size(jrnEType_e_ea) = %size(jrnEType_e));

end-proc;

//====================================================================
//  *** private ***
//  Map Create data area (E EE) journal entry
//  to common data area journal entry data structure.
//====================================================================
dcl-proc mapJrnE_E_EE;
  dcl-pi *n;
    i_pData  pointer const;
    i_length int(10) const;
  end-pi;

  //  Local fields
  dcl-ds tmpJrnEType_e_ee likeds(jrnEType_e_ee_t);
  dcl-ds jrnEType_e_ee likeds(jrnEType_e_ee_t) based(i_pData);
  dcl-ds jrnEType_e likeds(jrnEType_e_t) based(i_pData);
  dcl-s value char(2000) based(pValue);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  tmpJrnEType_e_ee = jrnEType_e_ee;

  jrnEType_e_ee = *ALLx'00';

  jrnEType_e.start  = 1;                                 // start

  if (tmpJrnEType_e_ee.numE >= 1);                       // length
    jrnEType_e.length = tmpJrnEType_e_ee.length;
  else;
    jrnEType_e.length = 0;
  endif;

  if (tmpJrnEType_e_ee.numE >= 2);                       // decimal positions
    jrnEType_e.decPos = tmpJrnEType_e_ee.decPos;
  else;
    jrnEType_e.decPos = 0;
  endif;

  jrnEType_e.offset = %size(jrnEType_e);                 // offset

  jrnEType_e.type = tmpJrnEType_e_ee.type;               // type

  pValue = %addr(jrnEType_e) + %size(jrnEType_e);        // value
  enforceBoundaries(i_pData: i_length: pValue: %size(value));
  value  = tmpJrnEType_e_ee.value;

end-proc;

//====================================================================
//  *** private ***
//  Map Send data queue, no key (Q QS) journal entry
//  to common data queue journal entry data structure.
//====================================================================
dcl-proc mapJrnE_Q_QS;
  dcl-pi *n;
    i_pData  pointer const;
    i_length int(10) const;
  end-pi;

  //  Local fields
  dcl-ds tmpJrnEType_q_qs likeds(jrnEType_q_qs_t);
  dcl-ds jrnEType_q_qs likeds(jrnEType_q_qs_t) based(i_pData);
  dcl-ds jrnEType_q likeds(jrnEType_q_t) based(i_pData);
  dcl-s data_q char(65535) based(pData_q);
  dcl-ds data_qs likeds(dtaQ_data_t) based(pData_qs);
  dcl-ds tmpData likeds(dtaQ_data_t) based(pTmpData);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  // Save journal data
  tmpJrnEType_q_qs = jrnEType_q_qs;

  if (jrnEType_q_qs.dataLength > 0);
    pTmpData = %alloc(tmpJrnEType_q_qs.dataLength);
    pData_qs = %addr(jrnEType_q_qs) + %size(jrnEType_q_qs);
    %subst(tmpData: 1: tmpJrnEType_q_qs.dataLength) =
       %subst(data_qs: 1: jrnEType_q_qs.dataLength);
  else;
    pTmpData = *NULL;
  endif;

  // Map journal data
  clear jrnEType_q;

  jrnEType_q.sysInf_1   = tmpJrnEType_q_qs.sysInf_1;
  jrnEType_q.sysInf_2   = tmpJrnEType_q_qs.sysInf_2;
  jrnEType_q.sysInf_3   = tmpJrnEType_q_qs.sysInf_3;
  jrnEType_q.order      = '';
  jrnEType_q.keyLength  = 0;
  jrnEType_q.dataLength = tmpJrnEType_q_qs.dataLength;

  if (pTmpData = *NULL);
    jrnEType_q.apiInf = *ALLx'00';
  else;
    jrnEType_q.apiInf = tmpData.apiInf;
  endif;

  pData_q = %addr(jrnEType_q) + %size(jrnEType_q);       // value
  enforceBoundaries(i_pData: i_length: pData_q: jrnEType_q.dataLength);
  %subst(data_q: 1: jrnEType_q.dataLength) =
     %subst(tmpData.value: 1: tmpJrnEType_q_qs.dataLength);

  if (pTmpData <> *NULL);
    dealloc(N) pTmpData;
  endif;

end-proc;

//====================================================================
//  *** private ***
//  Map Received data queue, no key (Q QR) journal entry
//  to common data queue journal entry data structure.
//====================================================================
dcl-proc mapJrnE_Q_QR;
  dcl-pi *n;
    i_pData  pointer const;
    i_length int(10) const;
  end-pi;

  //  Local fields
  dcl-ds tmpJrnEType_q_qr likeds(jrnEType_q_qr_t);
  dcl-ds jrnEType_q_qr likeds(jrnEType_q_qr_t) based(i_pData);
  dcl-ds jrnEType_q likeds(jrnEType_q_t) based(i_pData);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  // Save journal data
  tmpJrnEType_q_qr = jrnEType_q_qr;

  // Map journal data
  clear jrnEType_q;

  jrnEType_q.sysInf_1   = tmpJrnEType_q_qr.sysInf_1;
  jrnEType_q.sysInf_2   = tmpJrnEType_q_qr.sysInf_2;
  jrnEType_q.sysInf_3   = *ALLx'00';
  jrnEType_q.order      = '';
  jrnEType_q.keyLength  = 0;
  jrnEType_q.dataLength = 0;
  jrnEType_q.apiInf     = *ALLx'00';

end-proc;

//====================================================================
//  *** private ***
//  Map Data queue cleared, no key (Q QC) journal entry
//  to common data queue journal entry data structure.
//====================================================================
dcl-proc mapJrnE_Q_QC;
  dcl-pi *n;
    i_pData  pointer const;
    i_length int(10) const;
  end-pi;

  //  Local fields
  dcl-ds tmpJrnEType_q_qc likeds(jrnEType_q_qc_t);
  dcl-ds jrnEType_q_qc likeds(jrnEType_q_qc_t) based(i_pData);
  dcl-ds jrnEType_q likeds(jrnEType_q_t) based(i_pData);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  // Save journal data
  tmpJrnEType_q_qc = %subst(jrnEType_q_qc: 1: %len(tmpJrnEType_q_qc));

  // Map journal data
  clear jrnEType_q;

  jrnEType_q.sysInf_1   = *ALLx'00';
  jrnEType_q.sysInf_2   = tmpJrnEType_q_qc.sysInf_2;
  jrnEType_q.sysInf_3   = *ALLx'00';
  jrnEType_q.order      = '';
  jrnEType_q.keyLength  = 0;
  jrnEType_q.dataLength = 0;
  jrnEType_q.apiInf     = *ALLx'00';

end-proc;

//====================================================================
//  *** private ***
//  Map Send data queue, has key (Q QK) journal entry
//  to common data queue journal entry data structure.
//====================================================================
dcl-proc mapJrnE_Q_QK;
  dcl-pi *n;
    i_pData  pointer const;
    i_length int(10) const;
  end-pi;

  //  Local fields
  dcl-ds tmpJrnEType_q_qk likeds(jrnEType_q_qk_t);
  dcl-ds jrnEType_q_qk likeds(jrnEType_q_qk_t) based(i_pData);
  dcl-ds jrnEType_q likeds(jrnEType_q_t) based(i_pData);
  dcl-s key_q char(65535) based(pKey_q);
  dcl-s key_qk char(65535) based(pKey_qk);
  dcl-s data_q char(65535) based(pData_q);
  dcl-ds data_qk likeds(dtaQ_data_t) based(pData_qk);
  dcl-s tmpKey char(65535) based(pTmpKey);
  dcl-ds tmpData likeds(dtaQ_data_t) based(pTmpData);
  dcl-s sysInf_1_qk char(16) based(pSysInf_1_qk);
  dcl-s tmpSysInf_1 char(16) inz;
  dcl-s sysInf_2_qk char(16) based(pSysInf_2_qk);
  dcl-s tmpSysInf_2 char(16) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  // Save journal data
  tmpJrnEType_q_qk = %subst(jrnEType_q_qk: 1: %len(tmpJrnEType_q_qk));

  // System Information 1
  pSysInf_1_qk = %addr(jrnEType_q_qk) +
                 %size(jrnEType_q_qk) +
                 jrnEType_q_qk.keyLength;
  tmpSysInf_1  = sysInf_1_qk;

  // System Information 2
  pSysInf_2_qk = %addr(jrnEType_q_qk) +
                 %size(jrnEType_q_qk) +
                 jrnEType_q_qk.keyLength +
                 %size(sysInf_1_qk);
  tmpSysInf_2  = sysInf_2_qk;

  // Save key
  if (jrnEType_q_qk.keyLength > 0);
    pTmpKey   = %alloc(tmpJrnEType_q_qk.keyLength);
    pKey_qk   = %addr(jrnEType_q_qk) + %size(jrnEType_q_qk);
    %subst(tmpKey: 1: tmpJrnEType_q_qk.keyLength) =
       %subst(key_qk: 1: jrnEType_q_qk.keyLength);
  else;
    pTmpKey = *NULL;
  endif;

  // Save data
  if (jrnEType_q_qk.dataLength > 0);
    pTmpData  = %alloc(tmpJrnEType_q_qk.dataLength);
    pData_qk  = %addr(jrnEType_q_qk) + jrnEType_q_qk.ofsData;
    %subst(tmpData: 1: tmpJrnEType_q_qk.dataLength) =
       %subst(data_qk: 1: tmpJrnEType_q_qk.dataLength);
  else;
    pTmpData = *NULL;
  endif;

  // Map journal data
  clear jrnEType_q;

  jrnEType_q.sysInf_1   = tmpSysInf_1;
  jrnEType_q.sysInf_2   = tmpSysInf_2;
  jrnEType_q.sysInf_3   = *ALLx'00';
  jrnEType_q.order      = '';
  jrnEType_q.keyLength  = tmpJrnEType_q_qk.keyLength;
  jrnEType_q.dataLength = tmpJrnEType_q_qk.dataLength -
                          %size(dtaQ_data_t.apiInf);
  if (pTmpData = *NULL);
    jrnEType_q.apiInf = *ALLx'00';
  else;
    jrnEType_q.apiInf = tmpData.apiInf;
  endif;

  pKey_q = %addr(jrnEType_q) + %size(jrnEType_q);      // key
  enforceBoundaries(i_pData: i_length: pKey_q: jrnEType_q.keyLength);
  %subst(key_q: 1: jrnEType_q.keyLength) =
     %subst(tmpKey: 1: tmpJrnEType_q_qk.keyLength);

  pData_q = %addr(jrnEType_q) + %size(jrnEType_q) +    // data
                                jrnEType_q.keyLength;
  enforceBoundaries(i_pData: i_length: pData_q: jrnEType_q.dataLength);
  %subst(data_q: 1: jrnEType_q.dataLength) =
     %subst(tmpData.value: 1: tmpJrnEType_q_qk.dataLength);

  // Free memory
  if (pTmpKey <> *NULL);
    dealloc(N) pTmpKey;
  endif;
  if (pTmpData <> *NULL);
    dealloc(N) pTmpData;
  endif;

end-proc;

//====================================================================
//  *** private ***
//  Map Received data queue, has key (Q QL) journal entry
//  to common data queue journal entry data structure.
//====================================================================
dcl-proc mapJrnE_Q_QL;
  dcl-pi *n;
    i_pData  pointer const;
    i_length int(10) const;
  end-pi;

  //  Local fields
  dcl-ds tmpJrnEType_q_ql likeds(jrnEType_q_ql_t);
  dcl-ds jrnEType_q_ql likeds(jrnEType_q_ql_t) based(i_pData);
  dcl-ds jrnEType_q likeds(jrnEType_q_t) based(i_pData);
  dcl-s key_q char(65535) based(pKey_q);
  dcl-s key_ql char(65535) based(pKey_ql);
  dcl-s tmpKey char(65535) based(pTmpKey);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  // Save journal data
  tmpJrnEType_q_ql = %subst(jrnEType_q_ql: 1: %len(tmpJrnEType_q_ql));

  // Save key
  if (jrnEType_q_ql.keyLength > 0);
    pTmpKey   = %alloc(tmpJrnEType_q_ql.keyLength);
    pKey_ql   = %addr(jrnEType_q_ql) + %size(jrnEType_q_ql);
    %subst(tmpKey: 1: tmpJrnEType_q_ql.keyLength) =
       %subst(key_ql: 1: jrnEType_q_ql.keyLength);
  else;
    pTmpKey = *NULL;
  endif;

  // Map journal data
  clear jrnEType_q;

  jrnEType_q.sysInf_1   = tmpJrnEType_q_ql.sysInf_1;
  jrnEType_q.sysInf_2   = tmpJrnEType_q_ql.sysInf_2;
  jrnEType_q.sysInf_3   = *ALLx'00';
  jrnEType_q.order      = tmpJrnEType_q_ql.order;
  jrnEType_q.keyLength  = tmpJrnEType_q_ql.keyLength;
  jrnEType_q.dataLength = 0;
  jrnEType_q.apiInf     = *ALLx'00';

  pKey_q = %addr(jrnEType_q) + %size(jrnEType_q);      // key
  enforceBoundaries(i_pData: i_length: pKey_q: jrnEType_q.keyLength);
  %subst(key_q: 1: jrnEType_q.keyLength) =
     %subst(tmpKey: 1: tmpJrnEType_q_ql.keyLength);

  // Free memory
  if (pTmpKey <> *NULL);
    dealloc(N) pTmpKey;
  endif;

end-proc;

//====================================================================
//  *** private ***
//  Map Data queue cleared, has key (Q QJ) journal entry
//  to common data queue journal entry data structure.
//====================================================================
dcl-proc mapJrnE_Q_QJ;
  dcl-pi *n;
    i_pData  pointer const;
    i_length int(10) const;
  end-pi;

  //  Local fields
  dcl-ds tmpJrnEType_q_qj likeds(jrnEType_q_qj_t);
  dcl-ds jrnEType_q_qj likeds(jrnEType_q_qj_t) based(i_pData);
  dcl-ds jrnEType_q likeds(jrnEType_q_t) based(i_pData);
  dcl-s key_q char(65535) based(pKey_q);
  dcl-s key_qj char(65535) based(pKey_qj);
  dcl-s tmpKey char(65535) based(pTmpKey);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  // Save journal data
  tmpJrnEType_q_qj = %subst(jrnEType_q_qj: 1: %len(tmpJrnEType_q_qj));

  // Save key
  if (jrnEType_q_qj.keyLength > 0);
    pTmpKey   = %alloc(tmpJrnEType_q_qj.keyLength);
    pKey_qj   = %addr(jrnEType_q_qj) + %size(jrnEType_q_qj);
    %subst(tmpKey: 1: tmpJrnEType_q_qj.keyLength) =
       %subst(key_qj: 1: jrnEType_q_qj.keyLength);
  else;
    pTmpKey = *NULL;
  endif;

  // Map journal data
  clear jrnEType_q;

  jrnEType_q.sysInf_1   = *ALLx'00';
  jrnEType_q.sysInf_2   = *ALLx'00';
  jrnEType_q.sysInf_3   = *ALLx'00';
  jrnEType_q.order      = tmpJrnEType_q_qj.order;
  jrnEType_q.keyLength  = tmpJrnEType_q_qj.keyLength;
  jrnEType_q.dataLength = 0;
  jrnEType_q.apiInf     = *ALLx'00';

  pKey_q = %addr(jrnEType_q) + %size(jrnEType_q);      // key
  enforceBoundaries(i_pData: i_length: pKey_q: jrnEType_q.keyLength);
  %subst(key_q: 1: jrnEType_q.keyLength) =
     %subst(tmpKey: 1: tmpJrnEType_q_qj.keyLength);

  // Free memory
  if (pTmpKey <> *NULL);
    dealloc(N) pTmpKey;
  endif;

end-proc;

//====================================================================
//  *** private ***
//  Ensures that memory boundaries are noticed.
//====================================================================
dcl-proc enforceBoundaries;
  dcl-pi *n;
    i_pData  pointer const;
    i_length int(10) const;
    i_pValue pointer const;
    i_size   int(10) const;
  end-pi;

  //  Local fields
  dcl-ds msg likeds(msg_t) inz;

  //  Messages
/copy QEXPJRNE,USR0020
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  if (i_pValue >= i_pData and
      i_pValue <= i_pData + i_length - i_size);
    return;
  endif;

  clear USR0020;
  msg = f_newMsg('USR0020': USR0020: cMsg_Escape);
  Message_sendEscapeMsg(msg);

end-proc;

//====================================================================
//  *** private ***
//  Produces an initialized record for a given file.
//====================================================================
dcl-proc crtEntryDataInitialized;
  dcl-pi *n char(32766);
    i_file       char(10) const;
    i_lib        char(10) const;
    i_lastJrnFld char(10) const;
  end-pi;

  //  Return value
  dcl-s entryData char(32766) inz;

  //  Local fields
  dcl-s x int(10) inz;
  dcl-s isEntryDataFld ind inz(cFalse);
  dcl-s offset int(10) inz;
  dcl-s length int(10) inz;

  //  Cache for better performance
  dcl-ds cache qualified static;
    isDirty ind inz(cTrue);
    file    inz like(i_file);
    lib     inz like(i_lib);
    data    inz like(entryData);
  end-ds;

  //  Field dictionary, needed to get additional
  //  information for date fields
  dcl-s hFldDct like(fldDct_handle_t) inz(*null);
  dcl-ds flda0310 likeds(flda0310_t) inz;
  dcl-s flda0310s like(flda0310_t) based(pFlda0310s);
  dcl-s pFlda0310s pointer inz(%addr(flda0310));
  dcl-ds msg likeds(msg_t) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  if (i_file <> cache.file) or (i_lib <> cache.lib);
    reset cache;
  endif;

  if not cache.isDirty;
    return cache.data;
  endif;

  // create field dictionary
  if not f_fldDct_new(i_file
                      : i_lib
                      : cFLDDCT_RCDFMT_FIRST
                      : hFldDct
                      : msg);
    f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToPgmBdy);
    return '';
  endif;

  // spin through record format and initialize entry data
  isEntryDataFld = cFalse;
  offset         = 0;

  for x = 1 to f_FldDct_getNumE(hFldDct);

    if x = 1;
      f_FldDct_rtvFldAtr(hFldDct: cFLDDCT_FLD_FIRST:
                         flda0310s: 'FLDA0310');
    else;
      f_FldDct_rtvFldAtr(hFldDct: cFLDDCT_FLD_NEXT:
                         flda0310s: 'FLDA0310');
    endif;

    if flda0310.name = i_lastJrnFld;
      isEntryDataFld = cTrue;
      iter;
    endif;

    if not isEntryDataFld;
      iter;
    endif;

    // Initialize length of VAR-LENGTH fields
    if flda0310.varLength = '1';
      length = flda0310.buffLength - flda0310.length;
      %subst(entryData: 1 + offset: length) = *ALLx'00';
      offset = offset + length;
    else;
      length = 0;
    endif;

    p_assert((flda0310.varLength = '1' and
              flda0310.buffLength <> flda0310.length) or
             (flda0310.varLength = '0' and
              flda0310.buffLength = flda0310.length)
             : 'Unexpected relation between ''flda0310.varLength'', +
                ''flda0310.length'' and ''flda0310.buffLength''');

    // Initialize field for ...
    select;
    // ... binary data
    when flda0310.type = cFLDDCT_TYPE_BINARY;
      %subst(entryData: 1 + offset: flda0310.length) = *ALLx'00';
    // ... float data
    when flda0310.type = cFLDDCT_TYPE_FLOAT;
      %subst(entryData: 1 + offset: flda0310.length) = *ALLx'00';
    // ... zoned data
    when flda0310.type = cFLDDCT_TYPE_ZONED;
      %subst(entryData: 1 + offset: flda0310.length) = *ALLx'F0';
    // ... packed data
    when flda0310.type = cFLDDCT_TYPE_PACKED;
      %subst(entryData: 1 + offset: flda0310.length) = *ALLx'00';
      %subst(entryData: 1 + offset + flda0310.length - 1: 1) = x'0F';
    // ... character data
    when flda0310.type = cFLDDCT_TYPE_CHAR;
      %subst(entryData: 1 + offset: flda0310.length) = *ALLx'40';
    // ... graphic data
    when flda0310.type = cFLDDCT_TYPE_GRAPHIC;
      %subst(entryData: 1 + offset: flda0310.length) = *ALLx'00';
    // ... date data
    when flda0310.type = cFLDDCT_TYPE_DATE;
      %subst(entryData: 1 + offset: flda0310.length) = '0001-01-01';
    // ... time data
    when flda0310.type = cFLDDCT_TYPE_TIME;
      %subst(entryData: 1 + offset: flda0310.length) = '00.00.00';
    // ... timestamp data
    when flda0310.type = cFLDDCT_TYPE_TMSTMP;
      %subst(entryData: 1 + offset: flda0310.length) =
                                          '0001-01-01-00.00.00.000000';
    // ... large object (CLOB/BLOB)
    when flda0310.type = cFLDDCT_TYPE_LOB;
      %subst(entryData: 1 + offset: flda0310.buffLength) = '*POINTER';

    other;
      msg = f_newMsg('USR0017': flda0310.name: cMsg_Diag);
      f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToPgmBdy);
      msg = f_newMsg('USR0016': flda0310.name: cMsg_Escape);
      Message_sendEscapeMsg(msg);
    endsl;

    offset = offset + flda0310.buffLength - length;
  endfor;

  // delete field dictionary
  if hFldDct <> *NULL;
    f_fldDct_delete(hFldDct);
  endif;

  // cache data
  cache.isDirty = cFalse;
  cache.file    = i_file;
  cache.lib     = i_lib;
  cache.data    = entryData;

  return entryData;

end-proc;

//====================================================================
//  *** private ***
//  Convert large object (CLOB/BLOB) field data.
//====================================================================
dcl-proc cvtLargeObjectFieldData;
  dcl-pi *n;
    i_file       char(10) const;
    i_lib        char(10) const;
    i_lastJrnFld char(10) const;
    io_data      char(32766);
  end-pi;

  //  Local fields
  dcl-s x int(10) inz;
  dcl-s isEntryDataFld ind inz(cFalse);
  dcl-s offset int(10) inz;
  dcl-s length int(10) inz;

  //  Cache for better performance
  dcl-ds cache qualified static;
    isDirty     ind inz(cTrue);
    hasLobField ind inz(cFalse);
    file        inz like(i_file);
    lib         inz like(i_lib);
  end-ds;

  //  Field dictionary, needed to get additional
  //  information for date fields
  dcl-s hFldDct like(fldDct_handle_t) inz(*null);
  dcl-ds flda0310 likeds(flda0310_t) inz;
  dcl-s flda0310s like(flda0310_t) based(pFlda0310s);
  dcl-s pFlda0310s pointer inz(%addr(flda0310));
  dcl-ds msg likeds(msg_t) inz;

  dcl-c LOB_DATA x'000000000000000000000000000000005CD7D6C9D5E3C5D94040404040404040';
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  if (i_file <> cache.file) or (i_lib <> cache.lib);
    reset cache;
  endif;

  if (not cache.isDirty and not cache.hasLobField);
    return;
  endif;

  // create field dictionary
  if not f_fldDct_new(i_file
                      : i_lib
                      : cFLDDCT_RCDFMT_FIRST
                      : hFldDct
                      : msg);
    f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToPgmBdy);
    return;
  endif;

  // spin through record format and initialize entry data
  isEntryDataFld = cFalse;
  offset         = 0;

  for x = 1 to f_FldDct_getNumE(hFldDct);

    if x = 1;
      f_FldDct_rtvFldAtr(hFldDct: cFLDDCT_FLD_FIRST:
                         flda0310s: 'FLDA0310');
    else;
      f_FldDct_rtvFldAtr(hFldDct: cFLDDCT_FLD_NEXT:
                         flda0310s: 'FLDA0310');
    endif;

    if flda0310.name = i_lastJrnFld;
      isEntryDataFld = cTrue;
      offset = offset + flda0310.buffLength - length;
      iter;
    endif;

    if not isEntryDataFld;
      offset = offset + flda0310.buffLength - length;
      iter;
    endif;

    if (flda0310.type = cFLDDCT_TYPE_CHAR and flda0310.buffLength = 32);
      if (%subst(io_data: 1 + offset: flda0310.buffLength) = LOB_DATA);
        %subst(io_data: 1 + offset: flda0310.buffLength) = '*POINTER';
        cache.hasLobField = cTrue;
      endif;
    endif;

    offset = offset + flda0310.buffLength - length;
  endfor;

  // delete field dictionary
  if hFldDct <> *NULL;
    f_fldDct_delete(hFldDct);
  endif;

  // cache data
  cache.isDirty = cFalse;
  cache.file    = i_file;
  cache.lib     = i_lib;

end-proc;

//====================================================================
//  *** private ***
//  Converts a DTS timestamp to an ISO timestamp.
//====================================================================
dcl-proc cvtDtsToIso;
  dcl-pi *n timestamp;
    i_dtsTmStmp uns(20) value;
  end-pi;

  //  Return value
  dcl-s timestamp timestamp inz;

  //  Local fields
  dcl-s tmpInBuffer char(8) based(pTmpInBuffer);
  dcl-s pTmpInBuffer pointer inz;
  dcl-ds tmpBuffer;
    date char(8);
    time char(9);
    mSec char(3);
  end-ds;
  dcl-ds errCode likeds(errCode_t);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  pTmpInBuffer = %addr(i_dtsTmStmp);

  errCode = f_newApiErrCode(cTrue);
  QWCCVTDT('*DTS': tmpInBuffer: '*YYMD': tmpBuffer: errCode);
  mSec = *ALL'0';

  timestamp = %timestamp(tmpBuffer: *ISO0);

  return timestamp;

end-proc;

//====================================================================
//  *** private ***
//  Returns TRUE for a batch job, else FALSE.
//====================================================================
dcl-proc isBatchJob;
  dcl-pi *n ind;
  end-pi;

  //  Return value
  dcl-s isBatchJob ind inz(cFalse);

  //  Local fields
  dcl-ds qJob likeds(qJob_t) inz;
  dcl-ds jobi0100 likeds(jobi0100_t) inz;
  dcl-ds errCode likeds(errCode_t) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  qJob.name = '*';
  qJob.user = '';
  qJob.nbr  = '';
  errCode = f_newApiErrCode(cTrue);

  QUSRJOBI(jobi0100: %size(jobi0100): 'JOBI0100': qJob: '': errCode);

  if (f_isApiError(errCode));
    isBatchJob = cTrue;
  else;
    if (jobi0100.type = 'I');
      isBatchJob = cFalse;
    else;
      isBatchJob = cTrue;
    endif;
  endif;

  return isBatchJob;

end-proc;

//=====================================================================*
//  *** private ***
//  Closes the output file
//=====================================================================*
dcl-proc closeOutputFile;
  dcl-pi *n;
  end-pi;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  if (g_file.isOpen and Rclose(g_file.pRFile) = 0);
    g_file.isOpen = cFalse;
    g_file.name   = '';
  endif;

end-proc;

//=====================================================================*
//  Abnormal end procedure:   Delete temporary file
//=====================================================================*
dcl-proc AbnEnd_terminateExport;
  dcl-pi *n;
    i_pRtxToken pointer const;
  end-pi;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  monitor;
    closeOutputFile();
  on-error;
  endmon;

end-proc;

/if not defined(*V5R3M0)                                                              //
//=========================================================================
//  *** private ***
//  Returns the bit-wise ANDing of the arguments.
//=========================================================================
dcl-proc bitAND;
  dcl-pi *n uns(10);
    i_arg1 uns(10) value;
    i_arg2 uns(10) value;
  end-pi;

//  Return value
  dcl-s result uns(10);

//  Helper fields
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

ANDSTR(%addr(result): %addr(i_arg1): %addr(i_arg2): %len(result));

return result;

end-proc;

/endif
