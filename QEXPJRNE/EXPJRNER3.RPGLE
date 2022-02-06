      *=====================================================================*
      *                                                                     *
      *  Application . : EXPJRNE                                            *
      *  Object  . . . : EXPJRNER3                                          *
      *  Description . : Export Journal Entries - RCVJRN                    *
      *  Author  . . . : Thomas Raddatz   <thomas.raddatz@tools400.de>      *
      *  Date  . . . . : 07.02.2006                                         *
      *                                                                     *
      *=====================================================================*
      *                                                                     *
      *  This software is free software, you can redistribute it and/or     *
      *  modify it under the terms of the GNU General Public License (GPL)  *
      *  as published by the Free Software Foundation.                      *
      *                                                                     *
      *  See GNU General Public License for details.                        *
      *          http://www.opensource.org                                  *
      *          http://www.opensource.org/licenses/gpl-license.html        *
      *                                                                     *
      *=====================================================================*
      *  History:                                                           *
      *                                                                     *
      *  Date        Name          Comment                                  *
      *  ----------  ------------  ---------------------------------------  *
      *  30.03.2007  Th.Raddatz    Removed prototype of ANDSTR() because    *
      *                            it comes with copy book MILIB, included  *
      *                            by PBASICS1.                             *
      *                                                                     *
      *  19.09.2008  Th.Raddatz    Added status message USR0012.            *
      *                                                                     *
      *  20.09.2008  Th.Raddatz    Redesigned EXPJRNE to support additional *
      *                            object types, starting with *DTAARA.     *
      *                                                                     *
      *  12.05.2010  Th.Raddatz    Changed program to use _rOpen, _rWrite   *
      *                            and _rClose instead of native RPG record *
      *                            IO to ensure that the journal data is    *
      *                            added to the output file as binary data. *
      *                                                                     *
      *  21.09.2013  Th.Raddatz    Fixed crtEntryDataInitialized() to       *
      *                            properly initialize the space of         *
      *                            variable length fields.                  *
      *                                                                     *
      *  06.10.2014  Th.Raddatz    Fixed compiler error RNF0203.            *
      *                                                                     *
      *  03.02.2015  Th.Raddatz    Changed to ignore the "Incomplete data"  *
      *                            flag in order to export BLOB/CLOB data.  *
      *                                                                     *
      *  04.10.2018  Th.Raddatz    Added outfile types *TYPE4 and *TYPE5.   *
      *                                                                     *
      *=====================================================================*
      * >>PRE-COMPILER<<                                                    *
      *   >>CRTCMD<< CRTRPGMOD    MODULE(&LI/&OB) +                         *
      *                           SRCFILE(&SL/&SF) +                        *
      *                           SRCMBR(&SM);                              *
      *   >>IMPORTANT<<                                                     *
      *     >>PARM<< TRUNCNBR(*NO);                                         *
      *     >>PARM<< DBGVIEW(*LIST);                                        *
      *     >>PARM<< OPTION(*EVENTF);                                       *
      *     >>PARM<< TGTRLS(V7R1M0);                                        *
      *   >>END-IMPORTANT<<                                                 *
      *   >>EXECUTE<<                                                       *
      * >>END-PRE-COMPILER<<                                                *
      *=====================================================================*
      /COPY QEXPJRNE,H_SPEC
      *=====================================================================*
      *
      *  Type definitions
      /COPY QEXPJRNE,FDQJOB
      /COPY QEXPJRNE,FDINFDS
      *
     D control_t       DS                  qualified               based(pDummy)
     D  byte1                         1A
     D  byte2                         1A
     D  byte3                         1A
      *
     D dtaQ_data_t     DS         65535    qualified               based(pDummy)
     D  apiInf                       16A
     D  value                     65519A
      *
      *
      *  Journal entry data (QSYSINC/QRPGLESRC.QJOURNAL: QJO00JEH00)
     D RJNE0200_t      DS         32766    qualified               based(pDummy)
     D  ofsNxtHeader           1      4I 0
     D  ofsNulValInd           5      8I 0
     D  ofsEntData             9     12I 0
     D  ofsTransactID         13     16U 0
     D  ofsLglUnitWrk         17     20U 0
     D  ofsRcvInf             21     24U 0
     D  seqNbr                25     32U 0
     D  timestamp             33     40U 0
     D  threadID              41     48U 0
     D  sysSeqNbr             49     56U 0
     D  rrn                   57     64U 0
     D  cmtCycleID            65     72U 0
     D  ptrHandle             73     76U 0
     D  rmtPort               77     78U 0
     D  armNbr                79     80U 0
     D  pgmLibASP             81     82U 0
     D  rmtAdr                83     98A
     D  jrnCode               99     99A
     D  entryType            100    101A
     D  job                  102    111A
     D  user                 112    121A
     D  jobNbr               122    127A
     D  pgm                  128    137A
     D  pgmLib               138    147A
     D  pgmLibASPDev         148    157A
     D  object               158    187A
     D  userProfile          188    197A
     D  journalID            198    207A
     D  adrFamily            208    208A
     D  system               209    216A
     D  indFlag              217    217A
     D  objnameID            218    218A
     D  flags                219    219I 0
     D  objType              220    229A
     D  reserved_1           230    232A
     D  nestedCmtLvl         233    236I 0
      *
      *  Null value indicator information (QSYSINC/QRPGLESRC.QJOURNAL: QJOENVIV)
     D nullValueInd_t  DS                  qualified               based(pDummy)
     D  length                       10I 0
     D  indicators                 8000A
      *
      *  Receiver information (QSYSINC/QRPGLESRC.QJOURNAL: QJO200RI)
     D receiverInf_t   DS                  qualified               based(pDummy)
     D  rcvName                      10A
     D  rcvLibName                   10A
     D  rcvASPDev                    10A
     D  rcvASPNbr                     5U 0
      *
      *  Logical unit of work
     D luw_t           DS                  qualified               based(pDummy)
     D  id                           39A
      *
      *  Transaction identifier (QSYSINC/H.XA: xid_t)
     D xid_t           DS                  qualified               based(pDummy)
     D  formatID                     10I 0
     D  gtrid_length                 10I 0
     D  bqual_length                 10I 0
     D  data                        128A
      *
     D XIDDATASIZE     C                   128
      *
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      *  External prototypes
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /COPY QEXPJRNE,CLIB2                         Prototypes of C-Library   Record IO
      /COPY QEXPJRNE,CEELIB                        Prototypes of CEE APIs
      /COPY QEXPJRNE,QUSRJOBI
      *
      *  memcpy -- Copy Bytes
      *     The behavior is undefined if copying takes place
      *     between objects that overlap.
      *     The memcpy() function returns a pointer to dest.
     d*memcpy          pr              *          extproc('memcpy')
     d* i_pDest                        *   value
     d* i_pSrc                         *   value
     d* i_count                      10u 0 value
      *
      *  Convert Hex to Character (CVTHC)
     d*cvthc...
     d*                pr                  extproc('cvthc')
     d* pResult                        *   value
     d* pSource                        *   value
     d* sourceSize                   10i 0 value
      *
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      *  Exported prototypes
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
     D EXPJRNER3...
     D                 PR                  extpgm('EXPJRNER3')
     D  gi_buffer                 65535A          options(*varsize)
     D  gio_control                               likeds(control_t)
      *
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      *  Internal prototypes
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
     D p_main...
     D                 PR                         extproc('p_main')
     D  i_buffer                  65535A          options(*varsize)
     D  io_control                                likeds(control_t)
      *
      *  Converts a 4-byte hex value to an IPv4 address.
     D cvtToIPv4...
     D                 PR            15A          extproc('cvtToIPv4')
     D  i_bytes                       4A   const
      *
      *  Converts a 16-byte hex value to an IPv6 address.
     D cvtToIPv6...
     D                 PR            39A          extproc('cvtToIPv6')
     D  i_bytes                      16A   value
      *
      *  Returns the job number.
     D getJONBR...
     D                 PR             6S 0       extproc('getJONBR')
     D  i_RJNE0200                         const likeds(RJNE0200_t)
     D                                           options(*varsize)
      *
      *  Returns the name of the journal object.
     D getJOOBJ...
     D                 PR            10A         extproc('getJOOBJ')
     D  i_RJNE0200                         const likeds(RJNE0200_t)
     D                                           options(*varsize)
      *
      *  Returns the name of the library where the
      *  journaled object is stored.
     D getJOLIB...
     D                 PR            10A         extproc('getJOOBJ')
     D  i_RJNE0200                         const likeds(RJNE0200_t)
     D                                           options(*varsize)
      *
      *  Returns the name of the journaled member.
     D getJOMBR...
     D                 PR            10A         extproc('getJOMBR')
     D  i_RJNE0200                         const likeds(RJNE0200_t)
     D                                           options(*varsize)
      *
      *  Returns the value of the 'Minimized ESD' flag.
     D getJOMINESD...
     D                 PR             1A         extproc('getJOMINESD')
     D  i_RJNE0200                         const likeds(RJNE0200_t)
     D                                           options(*varsize)
      *
      *  Returns the value of the 'File type indicator' flag.
     D getJOFILTYP...
     D                 PR             1A         extproc('getJOFILTYP')
     D  i_RJNE0200                         const likeds(RJNE0200_t)
     D                                           options(*varsize)
      *
      *  Returns the value of the 'Referential Constraint' flag.
     D getJORCST...
     D                 PR             1A         extproc('getJORCST')
     D  i_RJNE0200                         const likeds(RJNE0200_t)
     D                                           options(*varsize)
      *
      *  Returns the value of the 'Trigger' flag.
     D getJOTGR...
     D                 PR             1A         extproc('getJOTGR')
     D  i_RJNE0200                         const likeds(RJNE0200_t)
     D                                           options(*varsize)
      *
      *  Returns the value of the 'Incomplete data' flag.
     D getJOINCDAT...
     D                 PR             1A         extproc('getJOINCDAT')
     D  i_RJNE0200                         const likeds(RJNE0200_t)
     D                                           options(*varsize)
      *
      *  Returns the value of the
      *  'Ignored during APYJRNCHG or RMVJRNCHG' flag.
     D getJOIGNAPY...
     D                 PR             1A         extproc('getJOIGNAPY')
     D  i_RJNE0200                         const likeds(RJNE0200_t)
     D                                           options(*varsize)
      *
      *  Returns the value of the 'Null value indicator' flag.
     D getJONVI...
     D                 PR                        like(nullValueInd_t.indicators)
     D                                           extproc('getJONVI')
     D  i_pRJNE0200                    *   const
      *
      *  Map journal entries to common format.
     D mapJrnE...
     D                 PR                         extproc('mapJrnE')
     D  i_JOCODE                      1A   const
     D  i_JOENTT                      2A   const
     D  i_pData                        *   const
     D  i_length                     10I 0 const
      *
      *  Map journal entry E EB.
     D mapJrnE_E_EB...
     D                 PR                         extproc('mapJrnE_E_EB')
     D  i_pData                        *   const
     D  i_length                     10I 0 const
      *
      *  Map journal entry E EA.
     D mapJrnE_E_EA...
     D                 PR                         extproc('mapJrnE_E_EA')
     D  i_pData                        *   const
     D  i_length                     10I 0 const
      *
      *  Map journal entry E EE.
     D mapJrnE_E_EE...
     D                 PR                         extproc('mapJrnE_E_EE')
     D  i_pData                        *   const
     D  i_length                     10I 0 const
      *
      *  Map journal entry Q QS.
     D mapJrnE_Q_QS...
     D                 PR                         extproc('mapJrnE_Q_QS')
     D  i_pData                        *   const
     D  i_length                     10I 0 const
      *
      *  Map journal entry Q QR.
     D mapJrnE_Q_QR...
     D                 PR                         extproc('mapJrnE_Q_QR')
     D  i_pData                        *   const
     D  i_length                     10I 0 const
      *
      *  Map journal entry Q QK.
     D mapJrnE_Q_QK...
     D                 PR                         extproc('mapJrnE_Q_QK')
     D  i_pData                        *   const
     D  i_length                     10I 0 const
      *
      *  Map journal entry Q QL to common data queue journal entry.
     D mapJrnE_Q_QL...
     D                 PR                         extproc('mapJrnE_Q_QL')
     D  i_pData                        *   const
     D  i_length                     10I 0 const
      *
      *  Map journal entry Q QJ to common data queue journal entry.
     D mapJrnE_Q_QJ...
     D                 PR                         extproc('mapJrnE_Q_QJ')
     D  i_pData                        *   const
     D  i_length                     10I 0 const
      *
      *  Map journal entry Q QC to common data queue journal entry.
     D mapJrnE_Q_QC...
     D                 PR                         extproc('mapJrnE_Q_QC')
     D  i_pData                        *   const
     D  i_length                     10I 0 const
      *
      *  Ensures that memory boundaries are noticed.
     D enforceBoundaries...
     D                 PR                         extproc('enforceBoundaries')
     D  i_pData                        *   const
     D  i_length                     10I 0 const
     D  i_pValue                       *   const
     D  i_size                       10I 0 const
      *
      *  Produces an initialized record for a given file.
     D crtEntryDataInitialized...
     D                 PR         32766A          extproc('+
     D                                            crtEntryDataInitialized')
     D  i_file                       10A   const
     D  i_lib                        10A   const
     D  i_lastJrnFld                 10A   const
      *
      *  Produces an initialized record for a given file.
     D cvtLargeObjectFieldData...
     D                 PR                         extproc('+
     D                                            cvtLargeObjectFieldData')
     D  i_file                       10A   const
     D  i_lib                        10A   const
     D  i_lastJrnFld                 10A   const
     D  io_data                   32766A
      *
      *  Converts a DTS timestamp to an ISO timestamp.
     D cvtDtsToIso...
     D                 PR              Z          extproc('cvtDtsToIso')
     D  i_dtsTmStmp                  20U 0 value
      *
      *  Returns TRUE for a batch job, else FALSE.
     D isBatchJob...
     D                 PR              N          extproc('isBatchJob')
      *
      *  Closes the output file
     D closeOutputFile...
     D                 PR                         extproc('closeOutputFile')
      *
      *  Abnormal end procedure:   terminate export
     D AbnEnd_terminateExport...
     D                 PR                         extproc('+
     D                                            AbnEnd_terminateExport')
     D  i_pRtxToken                    *   const
      /if not defined(*V5R3M0)                                                              //
      *
      *  Returns the bit-wise ANDing of the arguments.
     D bitAND...
     D                 PR            10U 0        extproc('bitAND')
     D  i_arg1                       10U 0 value
     D  i_arg2                       10U 0 value
      /endif
      *
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      *  Imported prototypes
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /COPY QBASICS1,PBASICS1
      /COPY QRTVFLDA,PRTVFLDA
      /COPY QEXPJRNE,JRNETYPES
      *
      /DEFINE EXPJRNE_PROTOTYPE
      /COPY QEXPJRNE,EXPJRNER7                    Tool: EXPJRNE Utilities
      /UNDEFINE EXPJRNE_PROTOTYPE
      *
     D QWCCVTDT        PR                  ExtPgm('QWCCVTDT')
     D  i_inFormat                   10A   const
     D  i_inValue                 65535A   const  options(*varsize)
     D  i_outFormat                  10A   const
     D  o_outValue                65535A          options(*varsize)
     D  io_errCode                65535A          options(*varsize)
      *
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      *  Global fields and constants
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
     D g_nextInfoMsg   S               Z   inz(*loval)
     D g_isBatchJob    S               N   inz(cTrue )
      *
     D g_file          DS                  qualified
     D  isOpen                         N   inz(cFalse)
     D  name                         64A   varying inz
     D  pRFile                         *   inz
      *
     D cINFO_MSG_INTERVAL...
     D                 C                   15
      *
      *=====================================================================*
      *  Program entry point
      *  gio_control:
      *
      *  Byte 1 (Passed to the Exit Program):
      *  0 - No journal entry is passed on this call of the exit program.
      *  1 - A single journal entry is passed to the exit program.
      *  2 - A block of one or more journal entries is passed to the exit program.
      *  3 - No journal entry is passed on this call to the exit program, and no
      *      more entries can be passed, because the journal receiver that was
      *      attached when the receive journal entry operation started is no longer
      *      attached.
      *      Note: The system ends the RCVJRNE command after calling the exit
      *            program once with a reason code of 3.
      *  4 - No journal entry is passed on this call to the exit program, and no
      *      more entries can be passed unless the remote journal is activated.
      *      Note: This value can only be passed to the exit program when
      *            receiving journal entries from the attached receiver of a
      *            remote journal and the journal state for the journal is
      *            currently *INACTIVE.
      *
      *  Byte 1 (Passed to the System from the Exit Program):
      *  8 - Requests the command processing program to start passing one or
      *      more journal entries in a block. If BLKLEN(*NONE) was not
      *      specified, then specifying 8 in the first byte of the second
      *      parameter will have no effect and the first 5 bytes of the first
      *      parameter will be ignored.
      *  9 - Requests the RCVJRNE command to end. The exit program returns
      *      control to the system.
      *
      *  Byte 2 (Passed to the Exit Program):
      *  N - Additional journal entries are not currently available to be
      *      passed after this call of the exit program, or the RCVJRNE
      *      command will be ending after this call of the exit program.
      *  Y - Additional journal entries are currently available to be passed
      *      after this call of the exit program.
      *
      *  Byte 3 (Passed to the Exit Program):
      *  x'00' - One or more journal entries are being passed to the exit
      *      program and the object names in the fixed length portion of
      *      each journal entry do not necessarily reflect the name of the
      *      object at the time the journal entry was deposited into the
      *      journal.
      *      Note: This value is returned only when receiving journal
      *            entries from a journal receiver that was attached to a
      *            journal prior to V4R2M0.
      *  0 - No journal entries are currently being passed, so the
      *      information normally returned in this byte is not applicable.
      *  1 - One or more journal entries are being passed to the exit
      *      program and the object names in the fixed length portion of
      *      each journal entry reflect the name of the object at the time
      *      the journal entry was deposited into the journal.
      *  2 - One or more journal entries are being passed to the exit
      *      program and the object names in the fixed length portion of
      *      each journal entry do not necessarily reflect the name of the
      *      object at the time the journal entry was deposited into the
      *      journal. The object name in the fixed length portion of the
      *      journal entry may be returned as a previously known name for
      *      the object prior to the journal entry being deposited into the
      *      journal or be returned as *UNKNOWN.
      *      Note: This value will only be returned when receiving journal
      *            entries from a remote journal and the remote journal is
      *            currently being caught up from its source journal. A
      *            remote journal is being caught up from its source journal
      *            when the Change Remote Journal (CHGRMTJRN) command or
      *            Change Journal State (QjoChangeJournalState) API is
      *            invoked and is currently replicating journal entries to
      *            the remote journal. After the call to the CHGRMTJRN
      *            command or QjoChangeJournalState API returns, the remote
      *            journal is maintained with a synchronous or asynchronous
      *            delivery mode, and the remote journal is no longer being
      *            caught up.
      *  3 - One or more journal entries are being passed to the exit
      *      program and the object names in the fixed length portion of
      *      each journal entry do not necessarily reflect the name of the
      *      object at the time the journal entry was deposited into the
      *      journal. The object name in the fixed length portion of the
      *      journal entry may be returned as *UNKNOWN.
      *=====================================================================*
      *
     D EXPJRNER3...
     D                 PI
     D  gi_buffer                 65535A          options(*varsize)
     D  gio_control                               likeds(control_t)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         CEERTX(%paddr('AbnEnd_terminateExport'): *NULL: *omit);

         p_main(gi_buffer: gio_control);

         CEEUTX(%paddr('AbnEnd_terminateExport'): *omit);

         return;

         begsr *pssr;

            AbnEnd_terminateExport(*NULL);

            *inlr = *on;

         endsr '*CANCL';

      /END-FREE
      *
      *====================================================================
      *  Main control block with local fields
      *====================================================================
      *
     P p_main...
     P                 B
     D                 PI
     D  i_buffer                  65535A          options(*varsize)
     D  io_control                                likeds(control_t)
      *
      *  Local fields
     D offsJOESD       S             10I 0 inz
     D fixLength       S             10I 0 inz
     D dataLength      S             10I 0 inz
     D maxDataLength   S             10I 0 inz
     D msg             DS                  likeds(msg_t        ) inz
     D infoMsg         DS                  likeds(msg_t        ) inz
      *
      *  Outfile attributes passed in via environment variables
     D outFile         DS                  qualified
     D  name                         10A   inz
     D  lib                          10A   inz
     D  mbr                          10A   inz
     D  outFilFmt                    10A   inz
      *
      *  Write counter
     D numWrites       S             10I 0 inz   static
      *
      *  Error counter
     D numErrors       S             10I 0 inz   static
      *
      *  File handle and IO feedback area
     D rFile           DS                  likeds(RFILE_t)
     D                                     based(g_file.pRFile)
     D pRIOFB          S               *   inz                   static
     D rIOFB           DS                  likeds(RIOFB_t)
     D                                     based(pRIOFB)
      *
      *  I-Buffer
     D dsQADSPJRN    E DS         32766    extname(QADSPJRN) based(pdsQADSPJRN)
     D                                     qualified
     D dsQADSPJR2    E DS         32766    extname(QADSPJR2) based(pdsQADSPJR2)
     D                                     qualified
      *
      * dsQADSPJR3:
      *  Journal entry header information
     D header          DS                  qualified         based(pHeader)
     D  bytRet                 1      4U 0
     D  ofsJrnE                5      8U 0
     D  numE                   9     12U 0
     D  contID                13     13A
     D  contStrRcv            14     23A
     D  contStrRcvLib         24     33A
     D  contStrSeqNbr         34     53A
     D  reserved              54     65A
      *
      *  Journal entry data
     D RJNE0200        DS                  likeds(RJNE0200_t) based(pRJNE0200)
      *
      *  Entry data information
     D entryData       DS                  qualified based(pEntryData)
     D  length                        5S 0
     D  reserved                     11A
     D  value                     65519A
      *
      *  Empty data structures
     D clearEntryData...
     D                 DS                  likeds(entryData   )   inz
      *
      *  Receiver information
     D receiverInf     DS                  likeds(receiverInf_t)
     D                                     based(pReceiverInf)
     D clearReceiverInf...
     D                 DS                  likeds(receiverInf_t)  inz
      *
      *  Logical unit of work information
     D logicalUnitOfWork...
     D                 DS                  likeds(luw_t)
     D                                     based(pLogicalUnitOfWork)
     D clearLogicalUnitOfWork...
     D                 DS                  likeds(luw_t)          inz
      *
      *  Transaction ID
     D transactionId...
     D                 DS                  likeds(xid_t)
     D                                     based(pTransactionId)
     D clearTransactionId...
     D                 DS                  likeds(xid_t)          inz
      *
      *  O-Buffer
     D dsQADSPJRN_O  E DS         32766    extname(QADSPJRN) inz
     D                                     qualified
     D dsQADSPJR2_O  E DS         32766    extname(QADSPJR2) inz
     D                                     qualified
     D dsQADSPJR3_O  E DS         32766    extname(QADSPJR3) inz
     D                                     qualified
     D dsQADSPJR4_O  E DS         32766    extname(QADSPJR4) inz
     D                                     qualified
     D dsQADSPJR5_O  E DS         32766    extname(QADSPJR5) inz
     D                                     qualified
      *
      *  Messages
      /COPY QEXPJRNE,USR0012
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         if (g_nextInfoMsg = *LOVAL);
            g_isBatchJob  = isBatchJob();
            if (g_isBatchJob);
               g_nextInfoMsg = *HIVAL;
            else;
               g_nextInfoMsg = %timestamp() + %seconds(cINFO_MSG_INTERVAL);
            endif;
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

               clear dsQADSPJRN_O;
               fixLength  = %addr(dsQADSPJRN.JOESD) - %addr(dsQADSPJRN);
               dataLength = dsQADSPJRN.JOENTL - fixLength;
               dsQADSPJRN_O = %subst(dsQADSPJRN: 1: dsQADSPJRN.JOENTL);
               if (dataLength > 0);
                  cvtLargeObjectFieldData(
                     outFile.name: outFile.lib: 'JORES': dsQADSPJRN_O);
                  maxDataLength = %size(dsQADSPJRN_O) - dataLength;
                  mapJrnE(dsQADSPJRN_O.JOCODE: dsQADSPJRN_O.JOENTT
                          : %addr(dsQADSPJRN_O.JOESD): maxDataLength);
               else;
                  %subst(dsQADSPJRN_O: fixLength + 1) =
                     crtEntryDataInitialized(outFile.name: outFile.lib:'JORES');
               endif;
               pRIOFB = Rwrite(g_file.pRFile
                               : %addr(dsQADSPJRN_O): rFile.bufLen);

            when outFile.outFilFmt = '*TYPE2';

               clear dsQADSPJR2_O;
               fixLength  = %addr(dsQADSPJR2.JOESD) - %addr(dsQADSPJR2);
               dataLength = dsQADSPJR2.JOENTL - fixLength;
               dsQADSPJR2_O = %subst(dsQADSPJR2: 1: dsQADSPJR2.JOENTL);
               if (dataLength > 0);
                  cvtLargeObjectFieldData(
                     outFile.name: outFile.lib: 'JORES': dsQADSPJR2_O);
                  maxDataLength = %size(dsQADSPJR2_O) - dataLength;
                  mapJrnE(dsQADSPJR2_O.JOCODE: dsQADSPJR2_O.JOENTT
                          : %addr(dsQADSPJR2_O.JOESD): maxDataLength);
               else;
                  %subst(dsQADSPJR2_O: fixLength + 1) =
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
               clear dsQADSPJR3_O;

               // Set output data
               dsQADSPJR3_O.JOENTL   = entryData.length +
                                       (%addr(dsQADSPJR3_O.JOESD) -
                                        %addr(dsQADSPJR3_O));
               dsQADSPJR3_O.JOSEQN   = RJNE0200.seqNbr;
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

               // Compute offset for entry data
               offsJOESD = %addr(dsQADSPJR3_O.JONVI)
                           - %addr(dsQADSPJR3_O)
                           + %size(dsQADSPJR3_O.JONVI);

               // Set entry data
               if entryData.length = 0;
                  %subst(dsQADSPJR3_O: offsJOESD+1) =
                     crtEntryDataInitialized(outFile.name:outFile.lib:'JONVI');
               else;
                  %subst(dsQADSPJR3_O: offsJOESD+1) =
                     %subst(entryData.value: 1: entryData.length);
               endif;

               if // (dsQADSPJR3_O.JOINCDAT = '1') or   // Incomplete data, e.g. CLOB/BLOB
                  (dsQADSPJR3_O.JOMINESD = '1');     // Minimized ESD
                  numErrors = numErrors + 1;
               else;
                  dataLength = entryData.length;
                  if (dataLength > 0);
                     cvtLargeObjectFieldData(
                        outFile.name: outFile.lib: 'JORES': dsQADSPJR3_O);
                     maxDataLength = %size(dsQADSPJR3_O) - dataLength;
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
               clear dsQADSPJR4_O;

               // Set output data
               dsQADSPJR4_O.JOENTL   = entryData.length +
                                       (%addr(dsQADSPJR4_O.JOESD) -
                                        %addr(dsQADSPJR4_O));
               dsQADSPJR4_O.JOSEQN   = RJNE0200.seqNbr;
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

               // Compute offset for entry data
               offsJOESD = %addr(dsQADSPJR4_O.JONVI)
                           - %addr(dsQADSPJR4_O)
                           + %size(dsQADSPJR4_O.JONVI);

               // Set entry data
               if entryData.length = 0;
                  %subst(dsQADSPJR4_O: offsJOESD+1) =
                     crtEntryDataInitialized(outFile.name:outFile.lib:'JONVI');
               else;
                  %subst(dsQADSPJR4_O: offsJOESD+1) =
                     %subst(entryData.value: 1: entryData.length);
               endif;

               if // (dsQADSPJR4_O.JOINCDAT = '1') or   // Incomplete data, e.g. CLOB/BLOB
                  (dsQADSPJR4_O.JOMINESD = '1');     // Minimized ESD
                  numErrors = numErrors + 1;
               else;
                  dataLength = entryData.length;
                  if (dataLength > 0);
                     cvtLargeObjectFieldData(
                        outFile.name: outFile.lib: 'JORES': dsQADSPJR4_O);
                     maxDataLength = %size(dsQADSPJR4_O) - dataLength;
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
                  %subst(dsQADSPJR5_O: offsJOESD+1) =
                     crtEntryDataInitialized(outFile.name:outFile.lib:'JONVI');
               else;
                  %subst(dsQADSPJR5_O: offsJOESD+1) =
                     %subst(entryData.value: 1: entryData.length);
               endif;

               if // (dsQADSPJR3_O.JOINCDAT = '1') or  // Incomplete data, e.g. CLOB/BLOB
                  (dsQADSPJR5_O.JOMINESD = '1');       // Minimized ESD
                  numErrors = numErrors + 1;
               else;
                  dataLength = entryData.length;
                  if (dataLength > 0);
                     cvtLargeObjectFieldData(
                        outFile.name: outFile.lib: 'JORES': dsQADSPJR5_O);
                     maxDataLength = %size(dsQADSPJR5_O) - dataLength;
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

            // Unload program
            *inlr = *on;
         endif;

      /END-FREE
     P                 E
      *
      *====================================================================
      *  *** private ***
      *  Converts a 4-byte hex value to an IPv4 address.
      *====================================================================
     P cvtToIPv4...
     P                 B
     D                 PI            15A
     D  i_bytes                       4A   const
      *
     D ipv4            S             15A   varying
      *
     D i               S             10I 0
     D converter       DS                  qualified
     D  byte                          1A
     D  int                           3U 0 overlay(byte)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         for i = 1 to 4;
            converter.byte = %subst(i_bytes: i: 1);
            if (ipv4 <> '');
               ipv4 = ipv4 + '.';
            endif;
            ipv4 = ipv4 + %editc(converter.int: 'X');
         endfor;

         return ipv4;

      /END-FREE
     P                 E
      *
      *====================================================================
      *  *** private ***
      *  Converts a 16-byte hex value to an IPv6 address.
      *====================================================================
     P cvtToIPv6...
     P                 B
     D                 PI            39A
     D  i_bytes                      16A   value
      *
     D ipv6            S             39A   varying
      *
     D offset          S             10I 0
     D pSource         S               *
     D chunk           S              4A
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

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

      /END-FREE
     P                 E
      *
      *====================================================================
      *  *** private ***
      *  Returns the job number.
      *====================================================================
     P getJONBR...
     P                 B
     D                 PI             6S 0
     D  i_RJNE0200                         const likeds(RJNE0200_t)
     D                                           options(*varsize)
      *
     D nbr             S              6S 0
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         nbr = %dec(i_RJNE0200.jobNbr: 6: 0);

         return nbr;

      /END-FREE
     P                 E
      *
      *====================================================================
      *  *** private ***
      *  Returns the job number.
      *====================================================================
     P getJOOBJ...
     P                 B
     D                 PI            10A
     D  i_RJNE0200                         const likeds(RJNE0200_t)
     D                                           options(*varsize)
      *
     D obj             S             10A
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         obj = %subst(i_RJNE0200.object:  1: 10);

         return obj;

      /END-FREE
     P                 E
      *
      *====================================================================
      *  *** private ***
      *  Returns the job number.
      *====================================================================
     P getJOLIB...
     P                 B
     D                 PI            10A
     D  i_RJNE0200                         const likeds(RJNE0200_t)
     D                                           options(*varsize)
      *
     D lib             S             10A
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         lib = %subst(i_RJNE0200.object: 11: 10);

         return lib;

      /END-FREE
     P                 E
      *
      *====================================================================
      *  *** private ***
      *  Returns the job number.
      *====================================================================
     P getJOMBR...
     P                 B
     D                 PI            10A
     D  i_RJNE0200                         const likeds(RJNE0200_t)
     D                                           options(*varsize)
      *
     D mbr             S             10A
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         mbr = %subst(i_RJNE0200.object: 21: 10);

         return mbr;

      /END-FREE
     P                 E
      *
      *====================================================================
      *  *** private ***
      *  Returns the value of the 'Minimized ESD' flag.
      *====================================================================
     P getJOMINESD...
     P                 B
     D                 PI             1A
     D  i_RJNE0200                         const likeds(RJNE0200_t)
     D                                           options(*varsize)
      *
     D minESD          S              1A
     D MINESD_BIT      C                   x'08'
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

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

      /END-FREE
     P                 E
      *
      *====================================================================
      *  *** private ***
      *  Returns the value of the 'File type indicator' flag.
      *====================================================================
     P getJOFILTYP...
     P                 B
     D                 PI             1A
     D  i_RJNE0200                         const likeds(RJNE0200_t)
     D                                           options(*varsize)
      *
     D filTyp          S              1A
     D FILTYP_BIT      C                   x'04'
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

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

      /END-FREE
     P                 E
      *
      *====================================================================
      *  *** private ***
      *  Returns the value of the 'Referential Constraint' flag.
      *====================================================================
     P getJORCST...
     P                 B
     D                 PI             1A
     D  i_RJNE0200                         const likeds(RJNE0200_t)
     D                                           options(*varsize)
      *
     D rcst            S              1A
     D RCST_BIT        C                   x'80'
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

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

      /END-FREE
     P                 E
      *
      *====================================================================
      *  *** private ***
      *  Returns the value of the 'Trigger' flag.
      *====================================================================
     P getJOTGR...
     P                 B
     D                 PI             1A
     D  i_RJNE0200                         const likeds(RJNE0200_t)
     D                                           options(*varsize)
      *
     D tgr             S              1A
     D TGR_BIT         C                   x'40'
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

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

      /END-FREE
     P                 E
      *
      *====================================================================
      *  *** private ***
      *  Returns the value of the 'Incomplete data' flag.
      *====================================================================
     P getJOINCDAT...
     P                 B
     D                 PI             1A
     D  i_RJNE0200                         const likeds(RJNE0200_t)
     D                                           options(*varsize)
      *
     D incDat          S              1A
     D INCDAT_BIT      C                   x'20'
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

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

      /END-FREE
     P                 E
      *
      *====================================================================
      *  *** private ***
      *  Returns the value of the
      *  'Ignored during APYJRNCHG or RMVJRNCHG' flag.
      *====================================================================
     P getJOIGNAPY...
     P                 B
     D                 PI             1A
     D  i_RJNE0200                         const likeds(RJNE0200_t)
     D                                           options(*varsize)
      *
     D ignApy          S              1A
     D IGNAPY_BIT      C                   x'10'
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

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

      /END-FREE
     P                 E
      *
      *====================================================================
      *  *** private ***
      *  Returns the value of the 'Null value indicator' flag.
      *====================================================================
     P getJONVI...
     P                 B
     D                 PI                  like(nullValueInd_t.indicators)
     D  i_pRJNE0200                    *   const
      *
     D nvi             S                   like(nullValueInd_t.indicators)
      *
     D RJNE0200        DS                  likeds(RJNE0200_t) based(i_pRJNE0200)
      *
      *  Null value indicator information
     D nullValueInd    DS                  likeds(nullValueInd_t)
     D                                     based(pNullValueIndicator)
     D clearNullValueInd...
     D                 DS                  likeds(nullValueInd)   inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         // Get access to null value indicators
         if RJNE0200.ofsNulValInd > 0;
            pNullValueIndicator = %addr(RJNE0200) + RJNE0200.ofsNulValInd;
         else;
            pNullValueIndicator = %addr(clearNullValueInd);
         endif;

         nvi = %subst(nullValueInd.indicators: 1: nullValueInd.length);

         return nvi;

      /END-FREE
     P                 E
      *
      *====================================================================
      *  *** private ***
      *  Map journal entries to common format.
      *====================================================================
     P mapJrnE...
     P                 B
     D                 PI
     D  i_JOCODE                      1A   const
     D  i_JOENTT                      2A   const
     D  i_pData                        *   const
     D  i_length                     10I 0 const
      *
      *  Local fields
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

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

      /END-FREE
     P                 E
      *
      *====================================================================
      *  *** private ***
      *  Map Update data area (E EB) journal entry
      *  to common data area journal entry data structure.
      *====================================================================
     P mapJrnE_E_EB...
     P                 B
     D                 PI
     D  i_pData                        *   const
     D  i_length                     10I 0 const
      *
      *  Local fields
     D jrnEType_e_eb...
     D                 DS                  likeds(jrnEType_e_eb_t )
     D                                     based(i_pData)
     D jrnEType_e...
     D                 DS                  likeds(jrnEType_e_t    )
     D                                     based(i_pData)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         // no mapping required
         p_assert(%size(jrnEType_e_eb) = %size(jrnEType_e));

      /END-FREE
     P                 E
      *
      *====================================================================
      *  *** private ***
      *  Map Update data area (E EA) journal entry
      *  to common data area journal entry data structure.
      *====================================================================
     P mapJrnE_E_EA...
     P                 B
     D                 PI
     D  i_pData                        *   const
     D  i_length                     10I 0 const
      *
      *  Local fields
     D jrnEType_e_ea...
     D                 DS                  likeds(jrnEType_e_ea_t )
     D                                     based(i_pData)
     D jrnEType_e...
     D                 DS                  likeds(jrnEType_e_t    )
     D                                     based(i_pData)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         // no mapping required
         p_assert(%size(jrnEType_e_ea) = %size(jrnEType_e));

      /END-FREE
     P                 E
      *
      *====================================================================
      *  *** private ***
      *  Map Create data area (E EE) journal entry
      *  to common data area journal entry data structure.
      *====================================================================
     P mapJrnE_E_EE...
     P                 B
     D                 PI
     D  i_pData                        *   const
     D  i_length                     10I 0 const
      *
      *  Local fields
     D tmpJrnEType_e_ee...
     D                 DS                  likeds(jrnEType_e_ee_t )
     D jrnEType_e_ee...
     D                 DS                  likeds(jrnEType_e_ee_t )
     D                                     based(i_pData)
     D jrnEType_e...
     D                 DS                  likeds(jrnEType_e_t    )
     D                                     based(i_pData)
     D value           S           2000A   based(pValue)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

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

      /END-FREE
     P                 E
      *
      *====================================================================
      *  *** private ***
      *  Map Send data queue, no key (Q QS) journal entry
      *  to common data queue journal entry data structure.
      *====================================================================
     P mapJrnE_Q_QS...
     P                 B
     D                 PI
     D  i_pData                        *   const
     D  i_length                     10I 0 const
      *
      *  Local fields
     D tmpJrnEType_q_qs...
     D                 DS                  likeds(jrnEType_q_qs_t )
     D jrnEType_q_qs...
     D                 DS                  likeds(jrnEType_q_qs_t )
     D                                     based(i_pData)
     D jrnEType_q...
     D                 DS                  likeds(jrnEType_q_t )
     D                                     based(i_pData)
     D data_q          S          65535A   based(pData_q )
     D data_qs         DS                  likeds(dtaQ_data_t ) based(pData_qs)
     D tmpData         DS                  likeds(dtaQ_data_t ) based(pTmpData)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

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

      /END-FREE
     P                 E
      *
      *====================================================================
      *  *** private ***
      *  Map Received data queue, no key (Q QR) journal entry
      *  to common data queue journal entry data structure.
      *====================================================================
     P mapJrnE_Q_QR...
     P                 B
     D                 PI
     D  i_pData                        *   const
     D  i_length                     10I 0 const
      *
      *  Local fields
     D tmpJrnEType_q_qr...
     D                 DS                  likeds(jrnEType_q_qr_t )
     D jrnEType_q_qr...
     D                 DS                  likeds(jrnEType_q_qr_t )
     D                                     based(i_pData)
     D jrnEType_q...
     D                 DS                  likeds(jrnEType_q_t )
     D                                     based(i_pData)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

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

      /END-FREE
     P                 E
      *
      *====================================================================
      *  *** private ***
      *  Map Data queue cleared, no key (Q QC) journal entry
      *  to common data queue journal entry data structure.
      *====================================================================
     P mapJrnE_Q_QC...
     P                 B
     D                 PI
     D  i_pData                        *   const
     D  i_length                     10I 0 const
      *
      *  Local fields
     D tmpJrnEType_q_qc...
     D                 DS                  likeds(jrnEType_q_qc_t )
     D jrnEType_q_qc...
     D                 DS                  likeds(jrnEType_q_qc_t )
     D                                     based(i_pData)
     D jrnEType_q...
     D                 DS                  likeds(jrnEType_q_t )
     D                                     based(i_pData)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

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

      /END-FREE
     P                 E
      *
      *====================================================================
      *  *** private ***
      *  Map Send data queue, has key (Q QK) journal entry
      *  to common data queue journal entry data structure.
      *====================================================================
     P mapJrnE_Q_QK...
     P                 B
     D                 PI
     D  i_pData                        *   const
     D  i_length                     10I 0 const
      *
      *  Local fields
     D tmpJrnEType_q_qk...
     D                 DS                  likeds(jrnEType_q_qk_t )
     D jrnEType_q_qk...
     D                 DS                  likeds(jrnEType_q_qk_t )
     D                                     based(i_pData)
     D jrnEType_q...
     D                 DS                  likeds(jrnEType_q_t )
     D                                     based(i_pData)
     D key_q           S          65535A   based(pKey_q   )
     D key_qk          S          65535A   based(pKey_qk  )
     D data_q          S          65535A   based(pData_q  )
     D data_qk         DS                  likeds(dtaQ_data_t ) based(pData_qk )
     D tmpKey          S          65535A   based(pTmpKey  )
     D tmpData         DS                  likeds(dtaQ_data_t ) based(pTmpData )
     D sysInf_1_qk     S             16A   based(pSysInf_1_qk )
     D tmpSysInf_1     S             16A   inz
     D sysInf_2_qk     S             16A   based(pSysInf_2_qk )
     D tmpSysInf_2     S             16A   inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

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

      /END-FREE
     P                 E
      *
      *====================================================================
      *  *** private ***
      *  Map Received data queue, has key (Q QL) journal entry
      *  to common data queue journal entry data structure.
      *====================================================================
     P mapJrnE_Q_QL...
     P                 B
     D                 PI
     D  i_pData                        *   const
     D  i_length                     10I 0 const
      *
      *  Local fields
     D tmpJrnEType_q_ql...
     D                 DS                  likeds(jrnEType_q_ql_t )
     D jrnEType_q_ql...
     D                 DS                  likeds(jrnEType_q_ql_t )
     D                                     based(i_pData)
     D jrnEType_q...
     D                 DS                  likeds(jrnEType_q_t )
     D                                     based(i_pData)
     D key_q           S          65535A   based(pKey_q   )
     D key_ql          S          65535A   based(pKey_ql  )
     D tmpKey          S          65535A   based(pTmpKey  )
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

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

      /END-FREE
     P                 E
      *
      *====================================================================
      *  *** private ***
      *  Map Data queue cleared, has key (Q QJ) journal entry
      *  to common data queue journal entry data structure.
      *====================================================================
     P mapJrnE_Q_QJ...
     P                 B
     D                 PI
     D  i_pData                        *   const
     D  i_length                     10I 0 const
      *
      *  Local fields
     D tmpJrnEType_q_qj...
     D                 DS                  likeds(jrnEType_q_qj_t )
     D jrnEType_q_qj...
     D                 DS                  likeds(jrnEType_q_qj_t )
     D                                     based(i_pData)
     D jrnEType_q...
     D                 DS                  likeds(jrnEType_q_t )
     D                                     based(i_pData)
     D key_q           S          65535A   based(pKey_q   )
     D key_qj          S          65535A   based(pKey_qj  )
     D tmpKey          S          65535A   based(pTmpKey  )
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

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

      /END-FREE
     P                 E
      *
      *====================================================================
      *  *** private ***
      *  Ensures that memory boundaries are noticed.
      *====================================================================
     P enforceBoundaries...
     P                 B
     D                 PI
     D  i_pData                        *   const
     D  i_length                     10I 0 const
     D  i_pValue                       *   const
     D  i_size                       10I 0 const
      *
      *  Local fields
     D msg             DS                  likeds(msg_t        ) inz
      *
      *  Messages
      /COPY QEXPJRNE,USR0020
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         if (i_pValue >= i_pData and
             i_pValue <= i_pData + i_length - i_size);
            return;
         endif;

         clear USR0020;
         msg = f_newMsg('USR0020': USR0020: cMsg_Escape);
         Message_sendEscapeMsg(msg);

      /END-FREE
     P                 E
      *
      *====================================================================
      *  *** private ***
      *  Produces an initialized record for a given file.
      *====================================================================
     P crtEntryDataInitialized...
     P                 B
     D                 PI         32766A
     D  i_file                       10A   const
     D  i_lib                        10A   const
     D  i_lastJrnFld                 10A   const
      *
      *  Return value
     D entryData       S          32766A   inz
      *
      *  Local fields
     D x               S             10I 0 inz
     D isEntryDataFld  S               N   inz(cFalse)
     D offset          S             10I 0 inz
     D length          S             10I 0 inz
      *
      *  Cache for better performance
     D cache           DS                  qualified   static
     D  isDirty                        N   inz(cTrue)
     D  file                               inz         like(i_file   )
     D  lib                                inz         like(i_lib    )
     D  data                               inz         like(entryData)
      *
      *  Field dictionary, needed to get additional
      *  information for date fields
     D hFldDct         S                   like(fldDct_handle_t) inz(*NULL)
     D flda0310        DS                  likeds(flda0310_t   ) inz
     D flda0310s       S                   like(flda0310_t     )
     D                                     based(pFlda0310s)
     D pFlda0310s      S               *   inz(%addr(flda0310 ))
     D msg             DS                  likeds(msg_t        ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

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

      /END-FREE
     P                 E
      *
      *====================================================================
      *  *** private ***
      *  Convert large object (CLOB/BLOB) field data.
      *====================================================================
     P cvtLargeObjectFieldData...
     P                 B
     D                 PI
     D  i_file                       10A   const
     D  i_lib                        10A   const
     D  i_lastJrnFld                 10A   const
     D  io_data                   32766A
      *
      *  Local fields
     D x               S             10I 0 inz
     D isEntryDataFld  S               N   inz(cFalse)
     D offset          S             10I 0 inz
     D length          S             10I 0 inz
      *
      *  Cache for better performance
     D cache           DS                  qualified   static
     D  isDirty                        N   inz(cTrue)
     D  hasLobField                    N   inz(cFalse)
     D  file                               inz         like(i_file   )
     D  lib                                inz         like(i_lib    )
      *
      *  Field dictionary, needed to get additional
      *  information for date fields
     D hFldDct         S                   like(fldDct_handle_t) inz(*NULL)
     D flda0310        DS                  likeds(flda0310_t   ) inz
     D flda0310s       S                   like(flda0310_t     )
     D                                     based(pFlda0310s)
     D pFlda0310s      S               *   inz(%addr(flda0310 ))
     D msg             DS                  likeds(msg_t        ) inz
      *
     D LOB_DATA        C                   x'00000000000000000000000000000000+
     D                                       5CD7D6C9D5E3C5D94040404040404040'
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

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

      /END-FREE
     P                 E
      *
      *====================================================================
      *  *** private ***
      *  Converts a DTS timestamp to an ISO timestamp.
      *====================================================================
     P cvtDtsToIso...
     P                 B
     D                 PI              Z
     D  i_dtsTmStmp                  20U 0 value
      *
      *  Return value
     D timestamp       S               Z   inz
      *
      *  Local fields
     D tmpInBuffer     S              8A   based(pTmpInBuffer)
     D pTmpInBuffer    S               *   inz
     D tmpBuffer       DS
     D  date                          8A
     D  time                          9A
     D  mSec                          3A
     D errCode         DS                  likeds(errCode_t )
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         pTmpInBuffer = %addr(i_dtsTmStmp);

         errCode = f_newApiErrCode(cTrue);
         QWCCVTDT('*DTS': tmpInBuffer: '*YYMD': tmpBuffer: errCode);
         mSec = *ALL'0';

         timestamp = %timestamp(tmpBuffer: *ISO0);

         return timestamp;

      /END-FREE
     P                 E
      *
      *====================================================================
      *  *** private ***
      *  Returns TRUE for a batch job, else FALSE.
      *====================================================================
     P isBatchJob...
     P                 B
     D                 PI              N
      *
      *  Return value
     D isBatchJob      S               N   inz(cFalse)
      *
      *  Local fields
     D qJob            DS                  likeds(qJob_t    ) inz
     D jobi0100        DS                  likeds(jobi0100_t) inz
     D errCode         DS                  likeds(errCode_t ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

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

      /END-FREE
     P                 E
      *
      *=====================================================================*
      *  *** private ***
      *  Closes the output file
      *=====================================================================*
     P closeOutputFile...
     P                 B
     D                 PI
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         if (g_file.isOpen and Rclose(g_file.pRFile) = 0);
            g_file.isOpen = cFalse;
            g_file.name   = '';
         endif;

      /END-FREE
     P                 E
      *
      *=====================================================================*
      *  Abnormal end procedure:   Delete temporary file
      *=====================================================================*
     P AbnEnd_terminateExport...
     P                 B
     D                 PI
     D  i_pRtxToken                    *   const
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         monitor;
            closeOutputFile();
         on-error;
         endmon;

      /END-FREE
     P                 E
      *
      /if not defined(*V5R3M0)                                                              //
      *=========================================================================
      *  *** private ***
      *  Returns the bit-wise ANDing of the arguments.
      *=========================================================================
     P bitAND...
     P                 B
     D                 PI            10U 0
     D  i_arg1                       10U 0 value
     D  i_arg2                       10U 0 value
      *
      *  Return value
     D result          S             10U 0
      *
      *  Helper fields
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         ANDSTR(%addr(result): %addr(i_arg1): %addr(i_arg2): %len(result));

         return result;

      /END-FREE
     P                 E
      *
      /endif
