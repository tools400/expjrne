**free
/if NOT DEFINED(EXPJRNE_PROTOTYPE)
//=====================================================================*
//                                                                     *
//  Application . : EXPJRNE                                            *
//  Object  . . . : EXPJRNER5                                          *
//  Description . : Export Journal Entries - DDS                       *
//  Author  . . . : Thomas Raddatz   <thomas.raddatz@tools400.de>      *
//  Date  . . . . : 10.08.2007                                         *
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
//  10.10.2007  Th.Raddatz    Now renaming field/record format name    *
//                            if the name contains invalid chracaters. *
//                            '.' is changed to '_'.                   *
//                                                                     *
//  19.09.2008  Th.Raddatz    Fix problem when writing long keywords   *
//                            to source member.                        *
//                                                                     *
//  20.09.2008  Th.Raddatz    Redesigned EXPJRNE to support additional *
//                            object types, starting with *DTAARA.     *
//                            Fixed problem with VARLEN fields.        *
//                            Actually the problem was caused by       *
//                            service program RTVFLDA because it did   *
//                            not correctly set the 'length' field.    *
//                            EXPJRNE now requires RTVFLDA V1.5!       *
//                                                                     *
//  12.08.2009  Th.Raddatz    Added 'CCSID(xxxxx)' keyword.            *
//                                                                     *
//  19.08.2009  Th.Raddatz    Fixed problem that CCSID clause was      *
//                            incorrectly added to DATE, TIME and      *
//                            TIMESTAMP fields.                        *
//                                                                     *
//  06.10.2014  Th.Raddatz    Fixed compiler error RNF0203.            *
//                                                                     *
//  04.10.2018  Th.Raddatz    Fixed external procedure name (typo).    *
//                                                                     *
//  22.09.2023  Th.Raddatz    Send message USR0031 if a timestamp      *
//                            field has an unsupported number of       *
//                            fractional-seconds.                      *
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
ctl-opt nomain;
/copy QEXPJRNE,H_SPEC
//=====================================================================*
/endif
dcl-f SRCFILE disk(112) usage(*input: *output) usropn extfile(g_srcFile) extmbr(g_srcMbr);

dcl-s g_srcFile char(21) inz;
dcl-s g_srcMbr char(10) inz;

dcl-pr f_crtOutfile_DDS ind extproc('EXPJRNER5_f_crtOutfile_DDS');
  i_tplFile   char(10) const;
  i_tplLib    char(10) const;
  i_outFile   char(10) const;
  i_outLib    char(10) const;
  i_outFilFmt char(10) const;
end-pr;

/if DEFINED(EXPJRNE_PROTOTYPE)
/eof
/endif

/copy QBASICS1,PBASICS1                      Tools/400 Runtime Library
/copy QEXPJRNE,CEELIB                        CEE APIs
/copy QEXPJRNE,SQL                           Embedded SQL type definitions and const.

/define EXPJRNE_PROTOTYPE
/copy QEXPJRNE,EXPJRNER6                     Tool: EXPJRNE SQL Call Level Interface
/copy QEXPJRNE,EXPJRNER7                     Tool: EXPJRNE Utilities
/undefine EXPJRNE_PROTOTYPE

//  typedefs
dcl-ds srcLine_t qualified based(pDummy);
  seq  zoned(6: 2);
  date zoned(6);
  data char(100);
end-ds;

dcl-ds rcdFmt_t qualified based(pDummy);
  spec char(6);
  type char(1) pos(17);
  name char(10) pos(19);
end-ds;

dcl-ds fldDef_t qualified based(pDummy);
  spec   char(6);
  name   char(10) pos(19);
  length zoned(5) pos(30);
  type   char(1);
  decPos zoned(2);
end-ds;

dcl-ds kwd_t qualified based(pDummy);
  spec  char(6);
  value char(36) pos(45);
end-ds;

//  Constants
//  ... double quotes
dcl-c cSINGLE_QUOTE '''';

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//  Internal prototypes
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

//  Adds the record format definition to the source file member.
dcl-pr addRecordFormat ind extproc('addRecordFormat');
  i_format    char(10) const;
  i_fileCcsid uns(10) const;
  o_msg       likeds(msg_t) const;
end-pr;

//  Adds the fields of the record format to the source file member.
dcl-pr addFields ind extproc('addFields');
  i_hList     like(BasicList_handle_t) const;
  i_fileCcsid uns(10) const;
end-pr;

//  Adds a keyword to the source file member.
dcl-pr addKeyword ind extproc('addKeyword');
  i_kwd varchar(256) value;
end-pr;

//  Returns a file level CCSID if all character fields have the
//  same CCSID.
dcl-pr getFileCcsid uns(10) extproc('getFileCcsid');
  i_hList like(BasicList_handle_t) const;
end-pr;

//  Create temporary source physical file.
dcl-pr crtSrcFile ind extproc('crtSrcFile');
  i_file char(10) const;
  i_lib  char(10) const;
  i_mbr  char(10) const;
  i_text char(50) const;
end-pr;

//  Deletes a given physical file.
dcl-pr dltFile ind extproc('dltFile');
  i_file char(10) const;
  i_lib  char(10) const;
end-pr;

dcl-pr p_abnEndProc extproc('p_abnEndProc');
  i_pRtxToken pointer const;
end-pr;

dcl-ds RtxToken_t qualified based(pDummy);
  hList   like(BasicList_handle_t);
  srcFile likeds(qObj_t);
  srcMbr  char(10);
end-ds;

//=====================================================================*
//  Create outfile
//=====================================================================*

dcl-proc f_crtOutfile_DDS export;
  dcl-pi *n ind;
    i_tplFile   char(10) const;
    i_tplLib    char(10) const;
    i_outFile   char(10) const;
    i_outLib    char(10) const;
    i_outFilFmt char(10) const;
  end-pi;

  //  return value
  dcl-s isOK ind inz(cFalse);

  //  fields
  dcl-s x int(10) inz;
  dcl-ds tplFile likeds(qObj_t) inz;
  dcl-ds fldAttr likeds(fldAttr_t) based(pFldAttr);
  dcl-s fileCcsid uns(10) inz;

  dcl-s text char(52) inz;
  dcl-ds msg likeds(msg_t);

  dcl-ds rtxToken likeds(rtxToken_t) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  clear rtxToken;

  // Register abnormal end procedure
  CEERTX(%paddr('p_abnEndProc'): %addr(rtxToken): *omit);

  dou '1';

    // Create temporary source physical file
    Message_sendStatusMsg('USR0101');

    msg = f_newMsg('TXT0001');
    text = f_addQuotes(%trim(f_rtvMsgText(msg)): cSINGLE_QUOTE);

    rtxToken.srcFile = f_getTmpName();
    rtxToken.srcMbr  = rtxToken.srcFile;

    if (not crtSrcFile(rtxToken.srcFile.name
                       : rtxToken.srcFile.lib
                       : rtxToken.srcMbr
                       : text));
      isOK = cFalse;
      leave;
    endif;

    // Retrieve Outfile Record Format
    Message_sendStatusMsg('USR0102');

    // Produce field list ...
    rtxToken.hList = BasicList_new('*COLUMNS': 256);

    tplFile.name = i_tplFile;
    tplFile.lib  = i_tplLib;
    getOutputFileColumns(rtxToken.hList: i_outFilFmt: tplFile);

    g_srcFile = %trim(rtxToken.srcFile.lib ) + '/' +
                %trim(rtxToken.srcFile.name);
    g_srcMbr = rtxToken.srcMbr;

    // Produce DDS source code:
    open SRCFILE;

    fileCcsid = getFileCcsid(rtxToken.hList);

    // ... add record format
    if (not addRecordFormat('EXPJRNE': fileCcsid: msg));
      f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToPgmBdy);
      isOK = cFalse;
      leave;
    endif;

    // ... add fields of QADSPJR*
    if (not addFields(rtxToken.hList: fileCcsid));
      f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToPgmBdy);
      isOK = cFalse;
      leave;
    endif;

    // Close source file
    close SRCFILE;

    // Create output file
    Message_sendStatusMsg('USR0103');

    if (not f_execute('CRTPF FILE(' + %trim(i_outLib)
                                    + '/'
                                    + %trim(i_outFile) + ') ' +
                            'SRCFILE(' + %trim(g_srcFile) + ') ' +
                            'SRCMBR('  + %trim(g_srcMbr)  + ') ' +
                            'OPTION('  + '*NOSRC *NOLIST' + ') '
                        : *omit: msg));
      f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToPgmBdy);
      isOK = cFalse;
      leave;
    endif;

    // Unregister abnormal end procedure
    CEEUTX(%paddr('p_abnEndProc'): *omit);

    isOK = cTrue;
  enddo;

  // Delete temporary objects
  Message_sendStatusMsg('USR0104');

  // House keeping
  // ... list of columns
  if (not BasicList_isNull(rtxToken.hList));
    BasicList_delete(rtxToken.hList);
    rtxToken.hList = BasicList_null();
  endif;
  // ... source physical
  if (%open(SRCFILE));
    close SRCFILE;
  endif;
  // ... temporary source physical file
  if (f_exist(rtxToken.srcFile.name: rtxToken.srcFile.lib: '*FILE'));
    dltFile(rtxToken.srcFile.name: rtxToken.srcFile.lib);
    clear rtxToken.srcFile;
  endif;

  return isOK;

end-proc;

//=====================================================================*
//  Adds the record format definition to the source file member.
//=====================================================================*
dcl-proc addRecordFormat;
  dcl-pi *n ind;
    i_format    char(10) const;
    i_fileCcsid uns(10) const;
    o_msg       likeds(msg_t) const;
  end-pi;

  //  Local fields
  dcl-ds rcdFmt likeds(rcdFmt_t) inz;
  dcl-ds srcLine likeds(srcLine_t) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  if (i_fileCcsid = 0);
    addKeyword('CCSID(' + %char(i_fileCcsid) + ')');
  endif;

  clear rcdFmt;
  rcdFmt.spec   = 'A';
  rcdFmt.type   = 'R';
  rcdFmt.name   = xlate(i_format);

  clear srcLine;
  srcLine.data = rcdFmt;
  write SRCFILE srcLine;

  return cTrue;

end-proc;

//=====================================================================*
//  Adds the fields of the record format to the source file member.
//=====================================================================*
dcl-proc addFields;
  dcl-pi *n ind;
    i_hList     like(BasicList_handle_t) const;
    i_fileCcsid uns(10) const;
  end-pi;

  //  Local fields
  dcl-s x int(10) inz;
  dcl-s ts_fraction int(10) inz;
  dcl-ds fldAttr likeds(fldAttr_t) based(pFldAttr);
  dcl-ds fldDef likeds(fldDef_t) inz;
  dcl-ds srcLine likeds(srcLine_t) inz;
  dcl-ds msg likeds(msg_t) inz;

/copy QEXPJRNE,USR0031
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  for x = 1 to BasicList_getNumE(i_hList);
    pFldAttr = BasicList_get(i_hList: x);

    fldDef = *ALL' ';
    fldDef.spec   = 'A';
    fldDef.name   = fldAttr.flda0320.name;

    // Set properties depeding on data type
    select;
    // ... CHARACTER / VARCHAR
    when (fldAttr.flda0320.type = cFLDDCT_TYPE_CHAR   );
      fldDef.length = fldAttr.flda0320.length;
      fldDef.type   = fldAttr.flda0320.type;
    // ... GRAPHIC / VARGRAPHIC
    when (fldAttr.flda0320.type = cFLDDCT_TYPE_GRAPHIC);
      fldDef.length = fldAttr.flda0320.digits;
      fldDef.type   = fldAttr.flda0320.type;
    // ... BINARY
    when (fldAttr.flda0320.type = cFLDDCT_TYPE_BINARY );
      fldDef.length = fldAttr.flda0320.digits;
      fldDef.decPos = fldAttr.flda0320.decPos;
      fldDef.type   = fldAttr.flda0320.type;
    // ... ZONED / PACKED / FLOAT
    when (fldAttr.flda0320.type = cFLDDCT_TYPE_ZONED  ) or
         (fldAttr.flda0320.type = cFLDDCT_TYPE_PACKED ) or
         (fldAttr.flda0320.type = cFLDDCT_TYPE_FLOAT  );
      fldDef.length = fldAttr.flda0320.digits;
      fldDef.decPos = fldAttr.flda0320.decPos;
      fldDef.type   = fldAttr.flda0320.type;
    // ... DATE / TIME
    when (fldAttr.flda0320.type = cFLDDCT_TYPE_DATE   ) or
         (fldAttr.flda0320.type = cFLDDCT_TYPE_TIME   );
      fldDef.type   = fldAttr.flda0320.type;
    // ... TIMESTAMP
    when (fldAttr.flda0320.type = cFLDDCT_TYPE_TMSTMP );
      if (fldAttr.flda0320.length = 19);
        ts_fraction = 6;
      else;
        ts_fraction = fldAttr.flda0320.length - 20;
      endif;

      if (ts_fraction = 6);
        fldDef.type   = fldAttr.flda0320.type;
      else;
        clear USR0031;
        USR00311 = fldAttr.flda0320.name;
        USR00312 = ts_fraction;
        msg = f_newMsg('USR0031': USR0031: cMsg_Escape);
        f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToPgmBdy);
      endif;

    // ... BLOB / CLOB
    when (fldAttr.flda0320.type = cFLDDCT_TYPE_LOB    );
      fldDef.length = fldAttr.flda0320.buffLength;
      fldDef.type   = 'A';
    endsl;

    clear srcLine;
    srcLine.data = fldDef;
    Write SRCFILE srcLine;

    // Add FLTPCN keyword
    if (fldAttr.flda0320.type = cFLDDCT_TYPE_FLOAT);
      if (fldAttr.flda0320.length = 4);
        addKeyword('FLTPCN(' + '*SINGLE' + ')');
      else;
        addKeyword('FLTPCN(' + '*DOUBLE' + ')');
      endif;
    endif;

    // Add VARLEN keyword
    if (fldAttr.flda0320.varLength = cTrue);
      if (fldAttr.flda0320.alcLength = 0);
        addKeyword('VARLEN');
      else;
        addKeyword('VARLEN(' +
                   %char(fldAttr.flda0320.alcLength) + ')');
      endif;
    endif;

    // Add CCSID keyword
    if (hasCcsidClause(fldAttr.flda0320.type
                       : fldAttr.flda0320.ccsid));
      if (i_fileCcsid = 0);
        addKeyword('CCSID(' + %char(fldAttr.flda0320.ccsid) + ')');
      endif;
    endif;

    // Add TEXT keyword
    addKeyword('TEXT(' + f_addQuotes(%trim(fldAttr.flda0320.text)
                                     : cSINGLE_QUOTE) + ')');

    // Add COLHDG keyword
    addKeyword('COLHDG(' + f_addQuotes(%trim(fldAttr.flda0320.colHdg1)
                                       : cSINGLE_QUOTE) + ' ' +
                           f_addQuotes(%trim(fldAttr.flda0320.colHdg2)
                                       : cSINGLE_QUOTE) + ' ' +
                           f_addQuotes(%trim(fldAttr.flda0320.colHdg3)
                                       : cSINGLE_QUOTE) + ')');

  endfor;

  return cTrue;

end-proc;

//=====================================================================*
//  Adds a keyword to the source file member.
//=====================================================================*
dcl-proc addKeyword;
  dcl-pi *n ind;
    i_kwd varchar(256) value;
  end-pi;

  //  Local fields
  dcl-ds kwd likeds(kwd_t) inz;
  dcl-ds srcLine likeds(srcLine_t) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  dow (%len(i_kwd) > 0);
    // Write field definition to source file:
    clear kwd;
    kwd.spec   = 'A';

    if (%len(i_kwd) > %len(kwd.value));
      kwd.value = %subst(i_kwd: 1: %len(kwd.value)-1) + '-';
      i_kwd = %subst(i_kwd: %len(kwd.value));
    else;
      kwd.value = i_kwd;
      i_kwd = '';
    endif;

    clear srcLine;
    srcLine.data = kwd;
    write SRCFILE srcLine;
  enddo;

  return cTrue;

end-proc;

//=====================================================================*
//  Returns a file level CCSID if all character fields have the
//  same CCSID.
//=====================================================================*
dcl-proc getFileCcsid;
  dcl-pi *n uns(10);
    i_hList like(BasicList_handle_t) const;
  end-pi;

  //  Return value
  dcl-s ccsid uns(10) inz(0);

  //  Local fields
  dcl-s x int(10) inz;
  dcl-ds fldAttr likeds(fldAttr_t) based(pFldAttr);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  for x = 1 to BasicList_getNumE(i_hList);
    pFldAttr = BasicList_get(i_hList: x);
    if (hasCcsidClause(fldAttr.flda0320.type
                       : fldAttr.flda0320.ccsid));
      if (ccsid > 0 and ccsid <> fldAttr.flda0320.ccsid);
        return 0;
      endif;
      ccsid = fldAttr.flda0320.ccsid;
    endif;
  endfor;

  return ccsid;

end-proc;

//=====================================================================*
//  Create temporary source physical file.
//=====================================================================*
dcl-proc crtSrcFile;
  dcl-pi *n ind;
    i_file char(10) const;
    i_lib  char(10) const;
    i_mbr  char(10) const;
    i_text char(50) const;
  end-pi;

  //  Return value
  dcl-s isOK ind inz(cFalse);

  //  Local fields
  dcl-ds msg likeds(msg_t) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  dou '1';

    if (not f_execute('CRTSRCPF ' +
                         'FILE(' + %trim(i_lib) + '/' +
                                   %trim(i_file) + ') ' +
                         'TEXT(' + i_text + ') '
                      : *omit: msg));
      f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToPgmBdy);
      isOK = cFalse;
      leave;
    endif;

    if (not f_execute('ADDPFM ' +
                         'FILE(' + %trim(i_lib) + '/' +
                                   %trim(i_file) + ') ' +
                         'MBR('  + %trim(i_mbr) + ') ' +

                         'TEXT(' + i_text + ') ' +
                         'SRCTYPE(' + 'PF' + ') '
                      : *omit: msg));
       f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToPgmBdy);
      isOK = cFalse;
      leave;
      endif;

    isOK = cTrue;
  enddo;

  if (not isOK);
    dltFile(i_file: i_lib);
  endif;

  isOK = cTrue;

  return isOK;

end-proc;

//=====================================================================*
//  Deletes a given physical file.
//=====================================================================*
dcl-proc dltFile;
  dcl-pi *n ind;
    i_file char(10) const;
    i_lib  char(10) const;
  end-pi;

  //  Local fields
  dcl-ds msg likeds(msg_t) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  if (f_exist(i_file: i_lib: '*FILE'));
    if (not f_execute('DLTF ' + 'FILE(' + %trim(i_lib) + '/' +
                                          %trim(i_file) + ') '
                      : *omit: msg));
      f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToPgmBdy);
      return cFalse;
    endif;
  endif;

  return cTrue;

end-proc;

//=====================================================================*
//  Terminate SQL connection
//=====================================================================*

dcl-proc p_abnEndProc;
  dcl-pi *n;
    i_pRtxToken pointer const;
  end-pi;

  dcl-ds rtxToken likeds(rtxToken_t) based(i_pRtxToken);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  if (%open(SRCFILE));
    close SRCFILE;
  endif;

  if (not BasicList_isNull(rtxToken.hList));
    BasicList_delete(rtxToken.hList);
    rtxToken.hList = BasicList_null();
  endif;

  dltFile(rtxToken.srcFile.name: rtxToken.srcFile.lib);

end-proc;

