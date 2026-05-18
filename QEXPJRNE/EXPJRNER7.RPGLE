**free
/if NOT DEFINED(EXPJRNE_PROTOTYPE)
//=====================================================================*
//                                                                     *
//  Application . : EXPJRNE                                            *
//  Object  . . . : EXPJRNER7                                          *
//  Description . : Export Journal Entries - UTIL                      *
//  Author  . . . : Thomas Raddatz   <thomas.raddatz@tools400.de>      *
//  Date  . . . . : 19.09.2008                                         *
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
//  20.09.2008  Th.Raddatz    Redesigned EXPJRNE to support additional *
//                            object types, starting with *DTAARA.     *
//                                                                     *
//  12.08.2009  Th.Raddatz    Added mappings:                          *
//                               SQL_WCHAR    -> cSQL_TYPE_GRAPHIC     *
//                               SQL_WVARCHAR -> cSQL_TYPE_VARGRAPHIC  *
//                                                                     *
//  19.08.2009  Th.Raddatz    Added procedure: hasCcsidClause()        *
//                                                                     *
//  06.10.2014  Th.Raddatz    Fixed compiler error RNF0203.            *
//                                                                     *
//  03.02.2015  Th.Raddatz    Changed to support CLOB/BLOB fields:     *
//                            sqlTypeToString() / hasCcsidClause().    *
//                                                                     *
//  04.10.2018  Th.Raddatz    Added outfile types *TYPE4 and *TYPE5.   *
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
ctl-opt nomain;
/copy QEXPJRNE,H_SPEC
//=====================================================================*
/endif

//  Returns the date format of the job.
dcl-pr rtvJobDateFmt varchar(10) extproc('EXPJRNER7_rtvJobDateFmt');
end-pr;

//  Retrieve Journal Information
dcl-pr rtvJrnInf ind extproc('EXPJRNER7_rtvJrnInf');
  i_obj     char(10) const;
  i_lib     char(10) const;
  i_objType char(10) const;
  o_file    char(10);
  o_lib     char(10);
  o_active  ind;
  o_jrn     char(10);
  o_jrnLib  char(10);
  o_images  char(10);
  o_omtJrnE char(10);
end-pr;

//  Converts a given SQL raw data type (integer value) to
//  its external character representation.
dcl-pr sqlTypeToString varchar(32) extproc('EXPJRNER7_sqlTypeToString');
  i_sqltype int(10) const;
end-pr;

//  Converts a given RPG data type to its SQL representation.
dcl-pr rpgTypeToSqlString varchar(32) extproc('EXPJRNER7_rpgTypeToSqlString');
  i_rpgType char(1) const;
  i_length  int(10) options(*nopass) const;
end-pr;

//  Converts invalid characters.
dcl-pr xlate varchar(512) extproc('EXPJRNER7_xlate');
  i_string varchar(512) const;
end-pr;

//  Returns the list of columns of the output file.
dcl-pr getOutputFileColumns extproc('EXPJRNER7_getOutputFileColumns');
  i_hList     like(BasicList_handle_t) const;
  i_outFilFmt char(10) const;
  i_tplFile   likeds(qObj_t) const;
end-pr;

//  Returns cTrue if the field has a CCSID clause.
dcl-pr hasCcsidClause ind extproc('EXPJRNER7_hasCcsidClause');
  i_type  char(1) const;
  i_ccsid uns(10) const;
end-pr;

//  Sets the name of the output file.
dcl-pr OutputFile_setName extproc('EXPJRNER7_OutputFile_setName');
  i_file char(10) const;
end-pr;

//  Returns the name of the output file.
dcl-pr OutputFile_getName char(10) extproc('EXPJRNER7_OutputFile_getName');
end-pr;

//  Sets the name of the library that contains the output file.
dcl-pr OutputFile_setLibrary extproc('EXPJRNER7_OutputFile_setLibrary');
  i_file char(10) const;
end-pr;

//  Returns the name of the library that contains the output file.
dcl-pr OutputFile_getLibrary char(10) extproc('EXPJRNER7_OutputFile_getLibrary');
end-pr;

//  Sets the name of the member of the output file that is used to
//  receive the exported journal entries.
dcl-pr OutputFile_setMember extproc('EXPJRNER7_OutputFile_setMember');
  i_file char(10) const;
end-pr;

//  Returns the name of the member of the output file that is used to
//  receive the exported journal entries.
dcl-pr OutputFile_getMember char(10) extproc('EXPJRNER7_OutputFile_getMember');
end-pr;

//  Sets the type of the output format.
dcl-pr OutputFile_setOutputFileFormat extproc('EXPJRNER7_OutputFile_setOutputFileFormat');
  i_outFilFmt char(10) const;
end-pr;

//  Returns the type of the output format.
dcl-pr OutputFile_getOutputFileFormat char(10) extproc('EXPJRNER7_OutputFile_getOutputFileFormat');
end-pr;

//  Sets the name of the template file.
dcl-pr TemplateFile_setName extproc('EXPJRNER7_TemplateFile_setName');
  i_file char(10) const;
end-pr;

//  Returns the name of the template file.
dcl-pr TemplateFile_getName char(10) extproc('EXPJRNER7_TemplateFile_getName');
end-pr;

//  Sets the name of the library that contains the template file.
dcl-pr TemplateFile_setLibrary extproc('EXPJRNER7_TemplateFile_setLibrary');
  i_lib char(10) const;
end-pr;

//  Returns the name of the library that contains the template file.
dcl-pr TemplateFile_getLibrary char(10) extproc('EXPJRNER7_TemplateFile_getLibrary');
end-pr;

//  Returns cTrue if the output file format does not matches the required format.
dcl-pr OutputFile_isLevelCheck ind extproc('EXPJRNER7_OutputFile_isLevelCheck');
  o_msg likeds(msg_t) options(*nopass);
end-pr;

//  Sets the name of object whose journal entries are exported.
dcl-pr Object_setName extproc('EXPJRNER7_Object_setName');
  i_obj char(10) const;
end-pr;

//  Returns the name of object whose journal entries are exported.
dcl-pr Object_getName char(10) extproc('EXPJRNER7_Object_getName');
end-pr;

//  Sets the name of the library that contains
//  the object whose journal entries are exported.
dcl-pr Object_setLibrary extproc('EXPJRNER7_Object_setLibrary');
  i_file char(10) const;
end-pr;

//  Rteurns the name of the library that contains
//  the object whose journal entries are exported.
dcl-pr Object_getLibrary char(10) extproc('EXPJRNER7_Object_getLibrary');
end-pr;

//  Sets the type of the object whose journal entries are exported.
dcl-pr Object_setType extproc('EXPJRNER7_Object_setType');
  i_file char(10) const;
end-pr;

//  Returns the type of the object whose journal entries are exported.
dcl-pr Object_getType char(10) extproc('EXPJRNER7_Object_getType');
end-pr;

//  Resets the error counter.
dcl-pr Error_resetCounter extproc('EXPJRNER7_Error_resetCounter');
end-pr;

//  Increments the error counter by one.
dcl-pr Error_incrementCounter extproc('EXPJRNER7_Error_incrementCounter');
end-pr;

//  Returns the number of errors.
dcl-pr Error_getCounterAsString char(10) extproc('EXPJRNER7_Error_getCounterAsString');
end-pr;

//  Sends a status message.
dcl-pr Message_sendStatusMsg extproc('EXPJRNER7_Message_sendStatusMsg');
  i_ID   like(msg_t.ID) const;
  i_data like(msg_t.data) options(*nopass) const;
end-pr;

//  Sends a diagnostic message.
dcl-pr Message_sendDiagMsg extproc('EXPJRNER7_Message_sendDiagMsg');
  i_msg likeds(msg_t) value;
end-pr;

//  Sends an escape message.
dcl-pr Message_sendEscapeMsg extproc('EXPJRNER7_Message_sendEscapeMsg');
  i_msg likeds(msg_t) value;
end-pr;

//  Returns the current release level of the operating system.
dcl-pr System_getCurrentRelease char(6) extproc('EXPJRNER7_System_getCurrentRelease');
end-pr;

//  Returns the application library of the EXPJRNE utility.
dcl-pr Application_getLibrary char(10) extproc('EXPJRNER7_Application_getLibrary');
end-pr;

/if DEFINED(EXPJRNE_PROTOTYPE)
/eof
/endif

/copy QBASICS1,PBASICS1                      Tools/400 Runtime Library
/copy QEXPJRNE,QUSRJOBI                      Retrieve Job Information (QUSRJOBI) API
/copy QEXPJRNE,FDQJOB                        typedef: Qualified Job Name
/copy QEXPJRNE,FDOBJD0400                    typedef: QUSROBJD API - OBJD0400
/copy QEXPJRNE,QUSROBJD                      Retrieve Object Description (QUSROBJD) API
/copy QEXPJRNE,SQLCLI                        SQL-Call Level Interface
/copy QEXPJRNE,SQL                           Embedded SQL type definitions and const.
/copy QEXPJRNE,QWCRDTAA                      Retrieve Data Area (QWCRDTAA) API
/copy QEXPJRNE,QMHQRDQD                      Retrieve Data Queue Description (QMHQRDQD)
/copy QEXPJRNE,JRNETYPES                     Layouts for var.-length portion of jrnE
/copy QEXPJRNE,CEELIB                        CEE APIs

/define EXPJRNE_PROTOTYPE
/copy QEXPJRNE,EXPJRNER6                     EXPJRNE: SQL type definitions and const.
/undefine EXPJRNE_PROTOTYPE

//  Adds the columns of a given file to a given column list.
dcl-pr addColumns like(SQLRETCODE_t) extproc('EXPJRNER7_addColumns');
  i_hList     like(BasicList_handle_t) const;
  i_file      likeds(qObj_t) const;
  i_lastField char(10) options(*nopass) const;
  i_isSeqNbr2 ind options(*nopass) const;
end-pr;

//  Adds variable-length portion of journal entries of type *DTAARA.
dcl-pr addDataAreaVarLenFields like(SQLRETCODE_t) extproc('EXPJRNER7_addDataAreaVarLenFields');
  i_hList like(BasicList_handle_t) const;
end-pr;

//  Adds variable-length portion of journal entries of type *DTAQ.
dcl-pr addDataQueueVarLenFields like(SQLRETCODE_t) extproc('EXPJRNER7_addDataQueueVarLenFields');
  i_hList like(BasicList_handle_t) const;
end-pr;

//  Produces a field attribute structure.
dcl-pr produceFldAttr likeds(fldAttr_t) extproc('EXPJRNER7_produceFldAttr');
  i_name   char(10) const;
  i_type   char(1) const;
  i_length int(10) const;
  i_decPos int(10) options(*omit) const;
  i_text   char(50) const;
  i_colHdg char(60) const;
end-pr;

//  Returns the data type of a given data area.
dcl-pr getDataAreaType likeds(fldAttr_t) extproc('EXPJRNER7_getDataAreaType');
  i_dtaAra char(10) const;
  i_lib    char(10) const;
end-pr;

//  Returns the data type of a given data queue.
dcl-pr getDataQueueType likeds(fldAttr_t) extproc('EXPJRNER7_getDataQueueType');
  i_dtaAra char(10) const;
  i_lib    char(10) const;
end-pr;

//  Returns the key type of a given keyed data queue.
dcl-pr getDataQueueKey likeds(fldAttr_t) extproc('EXPJRNER7_getDataQueueKey');
  i_dtaAra char(10) const;
  i_lib    char(10) const;
end-pr;

/define SDS_EXTENDED
/copy QEXPJRNE,SDS

//  Current program state
dcl-ds g_state qualified inz;
  qObj      likeds(qObj_t);
  objType   char(10);
  qOutFile  likeds(qObj_t);
  outMbr    char(10);
  outFilFmt char(10);
  qTplFile  likeds(qObj_t);
  errCount  int(10);
end-ds;

//  Constants
//  ... TYPE1 outfile
dcl-c cType1File 'QADSPJRN';
dcl-c cType1Lib 'QTEMP';

//  ... TYPE2 outfile
dcl-c cType2File 'QADSPJR2';
dcl-c cType2Lib 'QTEMP';

//  ... TYPE3 outfile
dcl-c cType3File 'QADSPJR3';
dcl-c cType3Lib 'QTEMP';

//  ... TYPE4 outfile
dcl-c cType4File 'QADSPJR4';
dcl-c cType4Lib 'QTEMP';

//  ... TYPE5 outfile
dcl-c cType5File 'QADSPJR5';
dcl-c cType5Lib 'QTEMP';

//==================================================================*
//  Returns the date format of the job.
//==================================================================*
dcl-proc rtvJobDateFmt export;
  dcl-pi *n varchar(10);
  end-pi;

  //  Return value
  dcl-s dateFmt varchar(10) inz;

  //  Local fields
  dcl-ds qJob likeds(qJob_t) inz;
  dcl-ds jobi0400 likeds(jobi0400_t) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  qJob.name = '*';
  qJob.user = '';
  qJob.nbr  = '';

  QUSRJOBI(JOBI0400: %size(JOBI0400): 'JOBI0400': qJob: '');

  dateFmt = jobi0400.dateFmt;

  return dateFmt;

end-proc;

//====================================================================
//  Retrieve Journal Information
//====================================================================
//  Input :  i_file     - The name of the file about which the
//                        information is to be retrieved from.
//           i_lib      - The library of the file.
//                        Special values: *LIBL, *CURLIB
//
//  Output:  o_file     - The actual file name from which the
//                        information was retrieved from.
//           o_lib      - The actual library of the file.
//           o_active   - Journaling active.
//                            TRUE    = File is beeing journaled.
//                            FALSE   = File is not beeing journaled.
//           o_jrn      - The name of the journal.
//           o_jrnLib   - The library of the journal.
//           o_images   - Record images that are journaled.
//                            *BOTH   = Both images are written
//                                      to the journal.
//                            *AFTER  = Only after images are written
//                                      to the journal.
//           o_omtJrnE  - Journal entries that are omitted.
//                            *NONE   = No journal entries are omitted.
//                            *OPNCLO = Open and close entries are omitted.
//
//====================================================================
dcl-proc rtvJrnInf export;
  dcl-pi *n ind;
    i_obj     char(10) const;
    i_lib     char(10) const;
    i_objType char(10) const;
    o_obj     char(10);
    o_lib     char(10);
    o_active  ind;
    o_jrn     char(10);
    o_jrnLib  char(10);
    o_images  char(10);
    o_omtJrnE char(10);
  end-pi;

  //  return value
  dcl-s isOK ind inz(cFalse);

  //  work fields
  dcl-ds qObj likeds(qObj_t) inz;
  dcl-ds objd0400 likeds(objd0400_t) inz;
  dcl-ds errCode likeds(errCode_t) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  // Determine initial size of memory needed ...
  qObj.name = i_obj;
  qObj.lib  = i_lib;
  errCode    = f_newApiErrCode(cTrue);

  QUSROBJD(objd0400: %size(objd0400): 'OBJD0400'
           : qObj: i_objType: errCode);

  // Is there was an error, ...
  if (f_isApiError(errCode));
    // ... then clear return values
    o_obj     = '';
    o_lib     = '';
    o_active  = cFalse;
    o_jrn     = '';
    o_jrnLib  = '';
    o_images  = '';
    o_omtJrnE = '';
    return cFalse;
  endif;

  o_obj     = objd0400.name;
  o_lib     = objd0400.rtnLib;

  if (objd0400.jrnStat = '1');
    o_active  = cTrue;
    o_jrn     = objd0400.jrnName;
    o_jrnLib  = objd0400.jrnLibName;

    if (objd0400.jrnImages = '0');
      o_images  = '*AFTER';
    else;
      o_images  = '*BOTH';
    endif;

    if (objd0400.jrnOmitE = '0');
      o_omtJrnE = '*NONE';
    else;
      o_omtJrnE = '*OPNCLO';
    endif;

  else;
    o_active  = cFalse;
    o_jrn     = '';
    o_jrnLib  = '';
    o_images  = '';
    o_omtJrnE = '';
  endif;

  return cTrue;

end-proc;

//====================================================================
//  Converts a given SQL raw data type (integer value) to
//  its external character representation.
//====================================================================
//  Input :  i_sqlType  - Internal SQL data type as returned by
//                        SQLColAttributes().
//
//  Return:  extType    - Character representation of i_sqlType.
//====================================================================
dcl-proc sqlTypeToString export;
  dcl-pi *n varchar(32);
    i_sqltype int(10) const;
  end-pi;

  //  return value
  dcl-s dataType varchar(10) inz('*N');
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  // Determine initial size of memory needed ...
  Select;
  When (i_sqltype = SQL_CHAR);
    dataType = cSQL_TYPE_CHARACTER;
  When (i_sqltype = SQL_VARCHAR);
    dataType = cSQL_TYPE_VARCHAR;
  When (i_sqltype = SQL_GRAPHIC);
    dataType = cSQL_TYPE_GRAPHIC;
  When (i_sqltype = SQL_VARGRAPHIC);
    dataType = cSQL_TYPE_VARGRAPHIC;
  When (i_sqltype = SQL_WCHAR);
    dataType = cSQL_TYPE_GRAPHIC;
  When (i_sqltype = SQL_WVARCHAR);
    dataType = cSQL_TYPE_VARGRAPHIC;
  When (i_sqltype = SQL_SMALLINT);
    dataType = cSQL_TYPE_SMALLINT;
  When (i_sqltype = SQL_INTEGER);
    dataType = cSQL_TYPE_INTEGER;
  When (i_sqltype = SQL_BIGINT);
    dataType = cSQL_TYPE_BIGINT;
  When (i_sqltype = SQL_DECIMAL);
    dataType = cSQL_TYPE_DECIMAL;
  When (i_sqltype = SQL_NUMERIC);
    dataType = cSQL_TYPE_NUMERIC;
  When (i_sqltype = SQL_DOUBLE);
    dataType = cSQL_TYPE_DOUBLE;
  When (i_sqltype = SQL_FLOAT);
    dataType = cSQL_TYPE_FLOAT;
  When (i_sqltype = SQL_REAL);
    dataType = cSQL_TYPE_REAL;
  When (i_sqltype = SQL_DATE);
    dataType = cSQL_TYPE_DATE;
  When (i_sqltype = SQL_TIME);
    dataType = cSQL_TYPE_TIME;
  When (i_sqltype = SQL_TIMESTAMP);
    dataType = cSQL_TYPE_TIMESTAMP;
  When (i_sqltype = SQL_BLOB);
    dataType = cSQL_TYPE_BLOB;
  When (i_sqltype = SQL_CLOB);
    dataType = cSQL_TYPE_CLOB;
  Other;
    dataType = '*INVALID_DATA_TYPE';
  Endsl;

  return dataType;

end-proc;

//====================================================================
//  Converts a given SQL raw data type (integer value) to
//  its external character representation.
//====================================================================
//  Input :  i_sqlType  - Internal SQL data type as returned by
//                        SQLColAttributes().
//
//  Return:  extType    - Character representation of i_sqlType.
//====================================================================
dcl-proc rpgTypeToSqlString export;
  dcl-pi *n varchar(32);
    i_rpgType char(1) const;
    i_length  int(10) options(*nopass) const;
  end-pi;

  //  Parameter positions
  dcl-c p_length 2;

  //  Fields for optional parameters
  dcl-s length like(i_length) inz;

  //  return value
  dcl-s dataType varchar(10) inz('*N');
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  if (%parms() >= p_length);
    length = i_length;
  else;
    length = 0;
  endif;

  // Determine initial size of memory needed ...
  select;
  when (i_rpgType = 'A');
    dataType = sqlTypeToString(SQL_CHAR);

  when (i_rpgType = 'B');
    select;
    when (length <= 4);
      dataType = sqlTypeToString(SQL_SMALLINT);
    when (length <=  9);
      dataType = sqlTypeToString(SQL_INTEGER);
    when (length <= 18);
      dataType = sqlTypeToString(SQL_BIGINT);
    other;
      dataType = sqlTypeToString(SQL_BIGINT);
    endsl;

  when (i_rpgType = 'I');
    select;
    when (length <= 3);
      dataType = sqlTypeToString(SQL_SMALLINT);
    when (length <= 5);
      dataType = sqlTypeToString(SQL_SMALLINT);
    when (length <= 10);
      dataType = sqlTypeToString(SQL_INTEGER);
    when (length <= 20);
      dataType = sqlTypeToString(SQL_BIGINT);
    other;
      dataType = sqlTypeToString(SQL_BIGINT);
    endsl;

  when (i_rpgType = 'P');
    dataType = sqlTypeToString(SQL_DECIMAL);

  when (i_rpgType = 'S');
    dataType = sqlTypeToString(SQL_NUMERIC);

  when (i_rpgType = 'F');
    select;
    when (length = 4);
      dataType = sqlTypeToString(SQL_REAL);
    when (length = 8);
      dataType = sqlTypeToString(SQL_DOUBLE);
    other;
      dataType = sqlTypeToString(SQL_DOUBLE);
    endsl;

  when (i_rpgType = 'D');
    dataType = sqlTypeToString(SQL_DATE);

  when (i_rpgType = 'T');
    dataType = sqlTypeToString(SQL_TIME);

  when (i_rpgType = 'Z');
    dataType = sqlTypeToString(SQL_TIMESTAMP);

  other;
    dataType = '*INVALID_DATA_TYPE';
  endsl;

  return dataType;

end-proc;

//====================================================================
//  Converts invalid characters.
//====================================================================
//  Input :  i_string   - Input string.
//
//  Return:  string     - Output string.
//====================================================================
dcl-proc xlate export;
  dcl-pi *n varchar(512);
    i_string varchar(512) const;
  end-pi;

  //  Return value
  dcl-s string varchar(512) inz;

  //  Local fields
  dcl-ds msg likeds(msg_t) inz;

  //  Messages
/copy QEXPJRNE,USR0019
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  string = %xlate('.': '_': i_string);

  if (i_string <> string);
    clear USR0019;
    USR00191 = i_string;
    USR00192 = string;
    msg = f_newMsg('USR0019': USR0019);
    f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToPgmBdy: *omit: sds.pgmContProc);
  endif;

  return string;

end-proc;

//====================================================================
//  Returns the list of columns of the output file.
//====================================================================
//  Input :  i_hList    - Handle of the list the columns are added to.
//           i_outFilFmt- Format of the output file.
//           i_tplFile  - Qualified file name of the template file.
//
//  Return:  void
//====================================================================
dcl-proc getOutputFileColumns export;
  dcl-pi *n;
    i_hList     like(BasicList_handle_t) const;
    i_outFilFmt char(10) const;
    i_tplFile   likeds(qObj_t) const;
  end-pi;

  //  Local fields
  dcl-ds fldAttr likeds(fldAttr_t) inz;
  dcl-ds expType likeds(qObj_t) inz;
  dcl-s isSeqNbr2 ind;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  // Determine type of output file
  select;
  when (i_outFilFmt = '*TYPE1');
    expType.name = cType1File;
    expType.lib  = cType1Lib;
    isSeqNbr2 = *off;
  when (i_outFilFmt = '*TYPE2');
    expType.name = cType2File;
    expType.lib  = cType2Lib ;
    isSeqNbr2 = *off;
  when (i_outFilFmt = '*TYPE3');
    expType.name = cType3File;
    expType.lib  = cType3Lib;
    isSeqNbr2 = *on;
  when (i_outFilFmt = '*TYPE4');
    expType.name = cType4File;
    expType.lib  = cType4Lib;
    isSeqNbr2 = *on;
  when (i_outFilFmt = '*TYPE5');
    expType.name = cType5File;
    expType.lib  = cType5Lib;
  endsl;

  // ... add columns of QADSPJR*, depending of export type
  addColumns(i_hList: expType: 'JOESD': isSeqNbr2);

  // ... add variable-length portion of journal entries of ...
  select;
  // ... data areas
  when (Object_getType() = '*DTAARA');
    addDataAreaVarLenFields(i_hList);
  // ... data queues
  when (Object_getType() = '*DTAQ');
    addDataQueueVarLenFields(i_hList);
  endsl;

  // ... add columns of template file
  select;
  when (Object_getType() = '*DTAARA');
    fldAttr = getDataAreaType(Object_getName(): Object_getLibrary());
    BasicList_add(i_hList: %addr(fldAttr): %size(fldAttr));

  when (Object_getType() = '*DTAQ');
    fldAttr = getDataQueueKey(Object_getName(): Object_getLibrary());
    if (fldAttr.flda0320.name <> '');
      BasicList_add(i_hList: %addr(fldAttr): %size(fldAttr));
    endif;

    fldAttr = getDataQueueType(Object_getName(): Object_getLibrary());
    BasicList_add(i_hList: %addr(fldAttr): %size(fldAttr));

  other;
    addColumns(i_hList: i_tplFile);
  endsl;

end-proc;

//====================================================================
//  Returns cTrue if the field has a CCSID clause.
//====================================================================
//  Input :  i_fldAttr  - Field attribute structure.
//
//  Return:  hasCcsid   -
//====================================================================
dcl-proc hasCcsidClause export;
  dcl-pi *n ind;
    i_type  char(1) const;
    i_ccsid uns(10) const;
  end-pi;

  //  Return value
  dcl-s hasCcsid ind inz(cFalse);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  if (i_ccsid > 0 and i_type <> cFLDDCT_TYPE_DATE   and
                      i_type <> cFLDDCT_TYPE_TIME   and
                      i_type <> cFLDDCT_TYPE_TMSTMP and
                      i_type <> cFLDDCT_TYPE_ERROR ); // returned for BLOB/CLOB
    hasCcsid = cTrue;
  else;
    hasCcsid = cFalse;
  endif;

  return hasCcsid;

end-proc;

//====================================================================
//  *** private ***
//  Adds the columns of a given file to a given column list.
//====================================================================
//  Input :  i_hList    - Handle of the list the columns are added to.
//           i_file     - Name of the file.
//           i_lastField- Qualified file name of the template file.
//           i_isSeqNbr2- Add field JOSEQ2 as 20-digit sequence number.
//
//  Return:  void
//====================================================================
dcl-proc addColumns;
  dcl-pi *n like(SQLRETCODE_t);
    i_hList     like(BasicList_handle_t) const;
    i_file      likeds(qObj_t) const;
    i_lastField char(10) options(*nopass) const;
    i_isSeqNbr2 ind options(*nopass) const;
  end-pi;

  //  Return value
  dcl-s rc like(SQLRETCODE_t) inz(SQL_ERROR);

  //  Fields for optional parameters
  dcl-s lastField like(i_lastField) inz;
  dcl-s isSeqNbr2 like(i_isSeqNbr2) inz;

  //  Local fields
  dcl-s x int(10) inz;
  dcl-ds hColumns likeds(hColumns_t) inz;
  dcl-ds fldAttr likeds(fldAttr_t) inz;
  dcl-ds fldAttrJOSEQN likeds(fldAttr_t) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  if (%parms() >= %parmnum(i_lastField));
    lastField = i_lastField;
  else;
    lastField = '';
  endif;

  if (%parms() >= %parmnum(i_isSeqNbr2));
    isSeqNbr2 = i_isSeqNbr2;
  else;
    isSeqNbr2 = *off;
  endif;

  hColumns = SQLCLI_Columns_null();

  dou '1';

    if (SQLCLI_Columns_open(hColumns: i_file) <> SQL_SUCCESS);
      rc = SQL_ERROR;
      leave;
    endif;

    for x = 1 to SQLCLI_Columns_numE(hColumns);
      SQLCLI_Columns_get(hColumns: fldAttr);

      if (lastField <> '' and fldAttr.flda0320.name = lastField);
        leave;
      endif;

      BasicList_add(i_hList: %addr(fldAttr): %size(fldAttr));

      if (isSeqNbr2 and fldAttr.flda0320.name = 'JOSEQN');
        fldAttrJOSEQN = fldAttr;
      endif;
    endfor;

  enddo;

  if (isSeqNbr2);
    fldAttrJOSEQN.flda0320.name = 'JOSEQ2';
    fldAttrJOSEQN.flda0320.alias = 'JOSEQ2';
    fldAttrJOSEQN.flda0320.digits = 20;
    fldAttrJOSEQN.flda0320.colHdg3 = 'LONG';
    fldAttrJOSEQN.flda0320.text = 'Sequence number long';
    BasicList_add(i_hList: %addr(fldAttrJOSEQN): %size(fldAttrJOSEQN));
  endif;

  if (not SQLCLI_Columns_isNull(hColumns));
    SQLCLI_Columns_close(hColumns);
    hColumns = SQLCLI_Columns_null();
  endif;

  return rc;

end-proc;

//====================================================================
//  *** private ***
//  Adds variable-length portion of journal entries of type *DTAARA.
//====================================================================
//  Input :  i_hList    - Handle of the list the columns are added to.
//
//  Return:  rc         - Returns SQL_SUCCESS on success, else SQL_ERROR.
//====================================================================
dcl-proc addDataAreaVarLenFields;
  dcl-pi *n like(SQLRETCODE_t);
    i_hList like(BasicList_handle_t) const;
  end-pi;

  //  Return value
  dcl-s rc like(SQLRETCODE_t) inz(SQL_ERROR);

  //  Local fields
  dcl-ds fldAttr likeds(fldAttr_t) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  fldAttr = produceFldAttr('X_START' : 'B': 9: 0
                           : 'Starting position of change'
                           : 'Start pos.');
  BasicList_add(i_hList: %addr(fldAttr): %size(fldAttr));

  fldAttr = produceFldAttr('X_LENGTH': 'B': 9: 0
                           : 'Length of change'
                           : 'Length');
  BasicList_add(i_hList: %addr(fldAttr): %size(fldAttr));

  fldAttr = produceFldAttr('X_DECPOS': 'B': 9: 0
                           : 'Number of decimal positions'
                           : 'Dec.Pos.');
  BasicList_add(i_hList: %addr(fldAttr): %size(fldAttr));

  fldAttr = produceFldAttr('X_OFFSET': 'B': 9: 0
                           : 'Offset to change'
                           : 'Offset');
  BasicList_add(i_hList: %addr(fldAttr): %size(fldAttr));

  fldAttr = produceFldAttr('X_TYPE'  : 'A': 10: *omit
                           : 'Type of data area'
                           : 'type');
  BasicList_add(i_hList: %addr(fldAttr): %size(fldAttr));

  rc = SQL_SUCCESS;

  return rc;

end-proc;

//====================================================================
//  *** private ***
//  Adds variable-length portion of journal entries of type *DTAQ.
//====================================================================
//  Input :  i_hList    - Handle of the list the columns are added to.
//
//  Return:  rc         - Returns SQL_SUCCESS on success, else SQL_ERROR.
//====================================================================
dcl-proc addDataQueueVarLenFields;
  dcl-pi *n like(SQLRETCODE_t);
    i_hList like(BasicList_handle_t) const;
  end-pi;

  //  Return value
  dcl-s rc like(SQLRETCODE_t) inz(SQL_ERROR);

  //  Local fields
  dcl-ds fldAttr likeds(fldAttr_t) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  fldAttr = produceFldAttr('X_SYSINF1': 'A':  16: 0
                           : 'Reserved for future use'
                           : 'Reserved 1');
  BasicList_add(i_hList: %addr(fldAttr): %size(fldAttr));

  fldAttr = produceFldAttr('X_SYSINF2': 'A':   2: 0
                           : 'Reserved for future use'
                           : 'Reserved 2');
  BasicList_add(i_hList: %addr(fldAttr): %size(fldAttr));

  fldAttr = produceFldAttr('X_SYSINF3': 'A':  10: 0
                           : 'Reserved for future use'
                           : 'Reserved 3');
  BasicList_add(i_hList: %addr(fldAttr): %size(fldAttr));

  fldAttr = produceFldAttr('X_ORDER'  : 'A':   2: 0
                           : 'Key order'
                           : 'Key order');
  BasicList_add(i_hList: %addr(fldAttr): %size(fldAttr));

  fldAttr = produceFldAttr('X_KEYLEN' : 'B':   9: 0
                           : 'Key length '
                           : 'Key length');
  BasicList_add(i_hList: %addr(fldAttr): %size(fldAttr));

  fldAttr = produceFldAttr('X_DTALEN' : 'B':   9: 0
                           : 'Data length '
                           : 'Data length');
  BasicList_add(i_hList: %addr(fldAttr): %size(fldAttr));

  fldAttr = produceFldAttr('X_APIINF' : 'A':  16: 0
                           : 'Send data queue API information'
                           : 'API Inf.');
  BasicList_add(i_hList: %addr(fldAttr): %size(fldAttr));

  rc = SQL_SUCCESS;

  return rc;

end-proc;

//====================================================================
//  *** private ***
//  Produces a field attribute structure.
//====================================================================
//  Input :  i_name     - Field name.
//           i_type     - Data type.
//           i_length   - Field length.
//           i_decPos   - Decimal positions.
//           i_text     - Field description.
//           i_colHdg   - Field column heading.
//
//  Return:  fldAttr    - Field attribute structure.
//====================================================================
dcl-proc produceFldAttr;
  dcl-pi *n likeds(fldAttr_t);
    i_name   char(10) const;
    i_type   char(1) const;
    i_length int(10) const;
    i_decPos int(10) options(*omit) const;
    i_text   char(50) const;
    i_colHdg char(60) const;
  end-pi;

  //  Return value
  dcl-ds fldAttr likeds(fldAttr_t) inz;

  //  Parameter positions
  dcl-c p_decPos 4;

  //  Fields for optional parameters
  dcl-s decPos like(i_decPos) inz;

  //  Local fields
  dcl-s isDecPos int(10) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  p_assert(i_type = 'A' or i_type = 'I' or i_type = 'B' or i_type = 'P'
           : 'Unexpected value in i_type: ' + i_type);

  CEETSTA(isDecPos: p_decPos: *omit);
  if (isDecPos = 1);
    decPos = i_decPos;
  else;
    decPos = 0;
  endif;

  fldAttr.flda0320.name    = i_name;
  fldAttr.flda0320.type    = i_type;

  select;
  when (fldAttr.flda0320.type = 'A');
    fldAttr.flda0320.length  = i_length;
    fldAttr.flda0320.digits  = 0;

  when (fldAttr.flda0320.type = 'P');
    fldAttr.flda0320.length  =
                         %unsh(((((i_length + 1) / 2) * 10) + 5) / 10);
    fldAttr.flda0320.digits  = i_length;

  when (fldAttr.flda0320.type = 'B' or fldAttr.flda0320.type = 'I');
    select;
    when (i_length <= 3);
      fldAttr.flda0320.length = 1;
    when (i_length <= 5);
      fldAttr.flda0320.length = 2;
    when (i_length <= 10);
      fldAttr.flda0320.length = 4;
    when (i_length <= 20);
      fldAttr.flda0320.length = 8;
    endsl;
    fldAttr.flda0320.digits  = i_length;
  endsl;

  fldAttr.flda0320.decPos  = decPos;
  fldAttr.flda0320.text    = i_text;
  fldAttr.flda0320.colHdg1 = %subst(i_colHdg:  1: 20);
  fldAttr.flda0320.colHdg2 = %subst(i_colHdg: 21: 20);
  fldAttr.flda0320.colHdg3 = %subst(i_colHdg: 41: 20);
  fldAttr.flda0320.alias   = i_name;
  fldAttr.sqlType          = rpgTypeToSqlString(i_type: i_length);

  return fldAttr;

end-proc;

//====================================================================
//  *** private ***
//  Returns the data type of a given data area.
//====================================================================
//  Input :  i_dtaAra   - Data area whose data type is returned
//
//  Return:  fldAttr    - Field definition of the data type of the
//                        data area.
//====================================================================
dcl-proc getDataAreaType;
  dcl-pi *n likeds(fldAttr_t);
    i_dtaAra char(10) const;
    i_lib    char(10) const;
  end-pi;

  //  Return value
  dcl-ds fldAttr likeds(fldAttr_t) inz;

  //  Local fields
  dcl-s start int(10) inz;
  dcl-s length int(10) inz;
  dcl-ds qDtaAra likeds(qObj_t) inz;
  dcl-ds rtvDtaAra likeds(rtvDtaAra_t) inz;
  dcl-ds errCode likeds(errCode_t) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  qDtaAra.name = i_dtaAra;
  qDtaAra.lib  = i_lib;
  start  = -1;
  length = %len(rtvDtaAra.value);
  errCode = f_newApiErrCode(cFalse);
  QWCRDTAA(rtvDtaAra: %size(rtvDtaAra): qDtaAra: start: length: errCode);

  select;
  when (rtvDtaAra.type = '*CHAR');
    fldAttr = produceFldAttr('X_VALUE' : 'A'
                             : rtvDtaAra.length
                             : 0
                             : 'Changed string value'
                             : 'Changed value       (string)');

  when (rtvDtaAra.type = '*DEC');
    fldAttr = produceFldAttr('X_VALUE' : 'P'
                              : rtvDtaAra.length
                              : rtvDtaAra.decPos
                             : 'Changed numeric value'
                             : 'Changed value       (numeric)');

  when (rtvDtaAra.type = '*LGL');
    fldAttr = produceFldAttr('X_VALUE' : 'A'
                              : rtvDtaAra.length
                              : 0
                             : 'Changed boolean value'
                             : 'Changed value       (boolean)');

  endsl;

  return fldAttr;

end-proc;

//====================================================================
//  *** private ***
//  Returns the data type of a given data queue.
//====================================================================
//  Input :  i_dtaAra   - Data queue whose data type is returned
//
//  Return:  fldAttr    - Field definition of the data type of the
//                        data queue.
//====================================================================
dcl-proc getDataQueueType;
  dcl-pi *n likeds(fldAttr_t);
    i_dtaQ char(10) const;
    i_lib  char(10) const;
  end-pi;

  //  Return value
  dcl-ds fldAttr likeds(fldAttr_t) inz;

  //  Local fields
  dcl-ds qDtaQ likeds(qObj_t) inz;
  dcl-ds rdqd0100 likeds(rdqd0100_t) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  qDtaQ.name = i_dtaQ;
  qDtaQ.lib  = i_lib;
  QMHQRDQD(rdqd0100: %size(rdqd0100): 'RDQD0100': qDtaQ);
  //RAD
  fldAttr = produceFldAttr('X_DATA' : 'A'
                           : rdqd0100.msgLength
                           : 0
                           : 'Message Data'
                           : 'Message data');

  return fldAttr;

end-proc;

//====================================================================
//  *** private ***
//  Returns the key type of a given keyed data queue.
//====================================================================
//  Input :  i_dtaAra   - Data queue whose data type is returned
//
//  Return:  fldAttr    - Field definition of the data type of the
//                        data queue.
//====================================================================
dcl-proc getDataQueueKey;
  dcl-pi *n likeds(fldAttr_t);
    i_dtaQ char(10) const;
    i_lib  char(10) const;
  end-pi;

  //  Return value
  dcl-ds fldAttr likeds(fldAttr_t) inz;

  //  Local fields
  dcl-ds qDtaQ likeds(qObj_t) inz;
  dcl-ds rdqd0100 likeds(rdqd0100_t) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  qDtaQ.name = i_dtaQ;
  qDtaQ.lib  = i_lib;
  QMHQRDQD(rdqd0100: %size(rdqd0100): 'RDQD0100': qDtaQ);

  if (rdqd0100.sequence <> 'K');
    return fldAttr;
  endif;
  //RAD
  fldAttr = produceFldAttr('X_KEY' : 'A'
                           : rdqd0100.keyLength
                           : 0
                           : 'Key value'
                           : 'Key value');

  return fldAttr;

end-proc;

//====================================================================
//  Sets the name of the output file.
//====================================================================
//  Input :  i_file     - Name of the output file.
//
//  Return:  void
//====================================================================
dcl-proc OutputFile_setName export;
  dcl-pi *n;
    i_file char(10) const;
  end-pi;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  g_state.qOutFile.name = i_file;

end-proc;

//====================================================================
//  Sets the name of the library that contains the output file.
//====================================================================
//  Input :  i_lib      - Name of the library that contains the
//                        output file.
//
//  Return:  void
//====================================================================
dcl-proc OutputFile_setLibrary export;
  dcl-pi *n;
    i_lib char(10) const;
  end-pi;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  g_state.qOutFile.lib = i_lib;

end-proc;

//====================================================================
//  Sets the name of the member of the output file that is used to
//  receive the exported journal entries.
//====================================================================
//  Input :  i_mbr      - Name of the member that receives the
//                        exported journal entries.
//
//  Return:  void
//====================================================================
dcl-proc OutputFile_setMember export;
  dcl-pi *n;
    i_mbr char(10) const;
  end-pi;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  g_state.outMbr = i_mbr;

end-proc;

//====================================================================
//  Sets the type of the output format.
//====================================================================
//  Input :  i_type     - Sets the type of the output format.
//
//  Return:  void
//====================================================================
dcl-proc OutputFile_setOutputFileFormat export;
  dcl-pi *n;
    i_outFilFmt char(10) const;
  end-pi;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  g_state.outFilFmt = i_outFilFmt;

end-proc;

//====================================================================
//  Sets the name of the template file.
//====================================================================
//  Input :  i_file     - Name of the template file.
//
//  Return:  void
//====================================================================
dcl-proc TemplateFile_setName export;
  dcl-pi *n;
    i_file char(10) const;
  end-pi;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  g_state.qTplFile.name = i_file;

end-proc;

//====================================================================
//  Sets the name of the library that contains the template file.
//====================================================================
//  Input :  i_lib      - Name of the library that contains the
//                        template file.
//
//  Return:  void
//====================================================================
dcl-proc TemplateFile_setLibrary export;
  dcl-pi *n;
    i_lib char(10) const;
  end-pi;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  g_state.qTplFile.lib = i_lib;

end-proc;

//====================================================================
//  Returns the name of the template file.
//====================================================================
//  Input :  void
//
//  Return:  file       - Name of the template file.
//====================================================================
dcl-proc TemplateFile_getName export;
  dcl-pi *n char(10);
  end-pi;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  return g_state.qTplFile.name;

end-proc;

//====================================================================
//  Returns the name of the library that contains the template file.
//====================================================================
//  Input :  void
//
//  Return:  lib        - Name of the library that contains
//                        the template file.
//====================================================================
dcl-proc TemplateFile_getLibrary export;
  dcl-pi *n char(10);
  end-pi;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  return g_state.qTplFile.lib;

end-proc;

//====================================================================
//  Returns the name of the output file.
//====================================================================
//  Input :  void
//
//  Return:  file       - Name of the output file.
//====================================================================
dcl-proc OutputFile_getName export;
  dcl-pi *n char(10);
  end-pi;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  return g_state.qOutFile.name;

end-proc;

//====================================================================
//  Returns the name of the library that contains the output file.
//====================================================================
//  Input :  void
//
//  Return:  lib        - Name of the library that contains the
//                        output file.
//====================================================================
dcl-proc OutputFile_getLibrary export;
  dcl-pi *n char(10);
  end-pi;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  return g_state.qOutFile.lib;

end-proc;

//====================================================================
//  Returns the name of the member of the output file that is used to
//  receive the exported journal entries.
//====================================================================
//  Input :  void
//
//  Return:  mbr        - Name of the member that receives the
//                        exported journal entries.
//====================================================================
dcl-proc OutputFile_getMember export;
  dcl-pi *n char(10);
  end-pi;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  return g_state.outMbr;

end-proc;

//====================================================================
//  Returns the type of the output format.
//====================================================================
//  Input :  void
//
//  Return:  type       - Returns the type of the output format.
//====================================================================
dcl-proc OutputFile_getOutputFileFormat export;
  dcl-pi *n char(10);
  end-pi;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  return g_state.outFilFmt;

end-proc;

//====================================================================
//  Returns cTrue if the output file format does not matches
//  the required format.
//====================================================================
//  Input :  void
//
//  Return:  isLevelCheck
//====================================================================
dcl-proc OutputFile_isLevelCheck export;
  dcl-pi *n ind;
    o_msg likeds(msg_t) options(*nopass);
  end-pi;

  //  Return value
  dcl-s isLevelCheck ind inz(cFalse);

  //  Parameter positions
  dcl-c p_msg 1;

  //  Local fields
  dcl-s x int(10) inz;
  dcl-s hOutFile like(BasicList_handle_t) inz;
  dcl-s hReqFile like(BasicList_handle_t) inz;
  dcl-ds attrOut likeds(fldAttr_t) based(pAttrOut);
  dcl-ds attrReq likeds(fldAttr_t) based(pAttrReq);
  dcl-ds msg likeds(msg_t) inz;

  //  Messages
/copy QEXPJRNE,USR0021
/copy QEXPJRNE,USR0022
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  msg = f_newMsg(cMSG_ID_OK);

  hOutFile = BasicList_null();
  hReqFile = BasicList_null();

  dou '1';

    monitor;

      hOutFile = BasicList_new('*COLUMNS': 256);
      getOutputFileColumns(hOutFile
                           : g_state.outFilFmt: g_state.qTplFile);

      hReqFile = BasicList_new('*COLUMNS': 256);
      addColumns(hReqFile: g_state.qOutFile: '');

      if (BasicList_getNumE(hOutFile) <> BasicList_getNumE(hReqFile));
        clear USR0021;
        USR00211 = g_state.qOutFile.name;
        USR00212 = g_state.qOutFile.lib;
        msg = f_newMsg('USR0021': USR0021);
        isLevelCheck = cTrue;
        leave;
      endif;

      for x = 1 to BasicList_getNumE(hOutFile);

        pAttrOut = BasicList_get(hOutFile: x);
        pAttrReq = BasicList_get(hReqFile: x);

        if (
           attrOut.flda0320.name       <> attrReq.flda0320.name       or
           attrOut.flda0320.type       <> attrReq.flda0320.type       or
           attrOut.flda0320.length     <> attrReq.flda0320.length     or
           attrOut.flda0320.digits     <> attrReq.flda0320.digits     or
           attrOut.flda0320.decPos     <> attrReq.flda0320.decPos     or
           attrOut.flda0320.datTimFmt  <> attrReq.flda0320.datTimFmt  or
           attrOut.flda0320.datTimSep  <> attrReq.flda0320.datTimSep  or
           attrOut.flda0320.alwNull    <> attrReq.flda0320.alwNull    );

          clear USR0022;
          USR00221 = g_state.qOutFile.name;
          USR00222 = g_state.qOutFile.lib;
          USR00223 = attrOut.flda0320.name;
          msg = f_newMsg('USR0022': USR0022);
          isLevelCheck = cTrue;
          leave;
        endif;

      endfor;

    on-error;
    endmon;

  enddo;

  if (not BasicList_isNull(hOutFile));
    BasicList_delete(hOutFile);
  endif;

  if (not BasicList_isNull(hReqFile));
    BasicList_delete(hReqFile);
  endif;

  if (%parms() > p_msg);
    o_msg = msg;
  else;
    if (msg.ID <> cMSG_ID_OK);
      Message_sendDiagMsg(msg);
    endif;
  endif;

  return isLevelCheck;

end-proc;

//====================================================================
//  Sets the name of object whose journal entries are exported.
//====================================================================
//  Input :  i_obj      - Name of the object whose journal entries
//                        are exported.
//
//  Return:  void
//====================================================================
dcl-proc Object_setName export;
  dcl-pi *n;
    i_obj char(10) const;
  end-pi;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  g_state.qObj.name = i_obj;

end-proc;

//====================================================================
//  Sets the name of the library that contains
//  the object whose journal entries are exported.
//====================================================================
//  Input :  i_lib      - Name of the library that contains the
//                        object whose journal entries are exported.
//
//  Return:  void
//====================================================================
dcl-proc Object_setLibrary export;
  dcl-pi *n;
    i_lib char(10) const;
  end-pi;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  g_state.qObj.lib = i_lib;

end-proc;

//====================================================================
//  Sets the type of the object whose journal entries are exported.
//====================================================================
//  Input :  i_type     - Sets the type of the object whose journal
//                        entries are exported.
//
//  Return:  void
//====================================================================
dcl-proc Object_setType export;
  dcl-pi *n;
    i_type char(10) const;
  end-pi;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  g_state.objType = i_type;

end-proc;

//====================================================================
//  Returns the name of object whose journal entries are exported.
//====================================================================
//  Input :  void
//
//  Return:  obj        - Name of the object whose journal entries
//                        are exported.
//====================================================================
dcl-proc Object_getName export;
  dcl-pi *n char(10);
  end-pi;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  return g_state.qObj.name;

end-proc;

//====================================================================
//  Returns the name of the library that contains
//  the object whose journal entries are exported.
//====================================================================
//  Input :  void
//
//  Return:  lib        - Name of the library that contains the object
//                        whose journal entries are exported.
//====================================================================
dcl-proc Object_getLibrary export;
  dcl-pi *n char(10);
  end-pi;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  return g_state.qObj.lib;

end-proc;

//====================================================================
//  Returns the type of the object whose journal entries are exported.
//====================================================================
//  Input :  void
//
//  Return:  type       - Type of the object whose journal entries
//                        are exported.
//====================================================================
dcl-proc Object_getType export;
  dcl-pi *n char(10);
  end-pi;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  return g_state.objType;

end-proc;

//====================================================================
//  Resets the error counter.
//====================================================================
//  Input :  void
//
//  Return:  void
//====================================================================
dcl-proc Error_resetCounter export;
  dcl-pi *n;
  end-pi;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  g_state.errCount = 0;

end-proc;

//====================================================================
//  Increments the error counter by one.
//====================================================================
//  Input :  void
//
//  Return:  void
//====================================================================
dcl-proc Error_incrementCounter export;
  dcl-pi *n;
  end-pi;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  g_state.errCount = g_state.errCount + 1;

end-proc;

//====================================================================
//  Returns the number of errors.
//====================================================================
//  Input :  void
//
//  Return:  counter    - Number of errors that occured.
//====================================================================
dcl-proc Error_getCounterAsString export;
  dcl-pi *n char(10);
  end-pi;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  return %char(g_state.errCount);

end-proc;

//====================================================================
//  Sends a status message.
//====================================================================
//  Input :  i_id       - Message ID.
//           i_data     - Message data.
//
//  Return:  void
//====================================================================
dcl-proc Message_sendStatusMsg export;
  dcl-pi *n;
    i_ID   like(msg_t.ID) const;
    i_data like(msg_t.data) options(*nopass) const;
  end-pi;

  //  Parameter positions
  dcl-c c_data 2;

  //  Local fields
  dcl-ds msg likeds(msg_t) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  if (%parms() >= c_data);
    msg = f_newMsg(i_ID: i_data: cMsg_Status);
  else;
    msg = f_newMsg(i_ID: '': cMsg_Status);
  endif;

  f_sndPgmMsg(msg: cMsg_Ext);

end-proc;

//====================================================================
//  Sends a diagnostic message.
//====================================================================
//  Input :  i_id       - Message ID.
//           i_data     - Message data.
//
//  Return:  void
//====================================================================
dcl-proc Message_sendDiagMsg export;
  dcl-pi *n;
    i_msg likeds(msg_t) value;
  end-pi;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  i_msg.type = cMsg_Diag;
  f_sndPgmMsg(i_msg: cMsg_Prv: cMsg_ToCtlBdy);

end-proc;

//====================================================================
//  Sends an escape message.
//====================================================================
//  Input :  i_id       - Message ID.
//           i_data     - Message data.
//
//  Return:  void
//====================================================================
dcl-proc Message_sendEscapeMsg export;
  dcl-pi *n;
    i_msg likeds(msg_t) value;
  end-pi;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  i_msg.type = cMsg_Escape;
  f_sndPgmMsg(i_msg: cMsg_Prv: cMsg_ToCtlBdy);

end-proc;

//====================================================================
//  Returns the current release level of the operating system.
//====================================================================
//  Input :  void
//
//  Return:  VxRxMx
//====================================================================
dcl-proc System_getCurrentRelease export;
  dcl-pi *n char(6);
  end-pi;

  //  QSZRTVPR API
  dcl-pr QSZRTVPR extpgm('QSZRTVPR');
    o_rcvVar    char(65535) options(*varsize);
    i_lenRcvVar int(10) const;
    i_format    char(8) const;
    o_prodInf   char(65535) options(*varsize) const;
    io_errCode  char(65535) options(*varsize);
  end-pr;

  dcl-ds prdi0100 qualified;
    productID  char(7) inz('*OPSYS');
    releaseLvl char(6) inz('*CUR');
    productOpt char(4) inz('0000');
    loadID     char(10) inz('*CODE');
  end-ds;
  //  Shortened!:
  dcl-ds prdr0100 qualified;
    bytRet     int(10);
    bytAvl     int(10);
    reserved_1 int(10);
    productID  char(7);
    releaseLvl char(6);
  end-ds;

  //  API error code
  dcl-ds errCode likeds(errCode_t) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  errCode = f_newApiErrCode(cFalse);

  QSZRTVPR(prdr0100: %size(prdr0100): 'PRDR0100': prdi0100: errCode);

  return prdr0100.releaseLvl;

end-proc;

//====================================================================
//  Returns the name of the library that contains the output file.
//====================================================================
//  Input :  void
//
//  Return:  library-name
//====================================================================
dcl-proc Application_getLibrary export;
  dcl-pi *n char(10);
  end-pi;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  return sds.pgmLib;

end-proc;

