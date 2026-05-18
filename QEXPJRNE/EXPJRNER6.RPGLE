**free
/if NOT DEFINED(EXPJRNE_PROTOTYPE)
//=====================================================================*
//                                                                     *
//  Application . : EXPJRNE                                            *
//  Object  . . . : EXPJRNER6                                          *
//  Description . : Export Journal Entries - SQLCLI                    *
//  Author  . . . : Thomas Raddatz   <thomas.raddatz@tools400.de>      *
//  Date  . . . . : 25.09.2008                                         *
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
//  17.11.2011  Th.Raddatz    Removed misleading error message when    *
//                            a SQL statement was executed but with    *
//                            warnings.                                *
//                                                                     *
//  03.02.2015  Th.Raddatz    Changed SQLCLI_Columns_get() to return   *
//                            length of CLOB and BLOB fields.          *
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

/copy QEXPJRNE,SQLCLI                        SQL Call level Interface
/copy QRTVFLDA,PRTVFLDA                      Field Attributes Dictionary

dcl-ds hSqlCli_t qualified based(pDummy);
  henv        like(HENV_t);
  hdbc        like(HDBC_t);
  isConnected ind;
end-ds;

dcl-ds hColumns_t qualified align based(pDummy);
  hSqlCli likeds(hSqlCli_t);
  hStmt   like(HSTMT_t);
  hFldDct like(fldDct_handle_t);
  numE    int(5);
  curE    int(5);
end-ds;

dcl-ds fldAttr_t qualified based(pDummy);
  flda0320 likeds(flda0320_t);
  sqlType  varchar(32);
end-ds;

//  Initializes the SQL call level interface
dcl-pr SQLCLI_initialize like(SQLRETCODE_t) extproc('EXPJRNER6_SQLCLI_initialize');
  o_hSqlCli likeds(hSqlCli_t);
end-pr;

//  Executes a given SQL statement.
dcl-pr SQLCLI_executeDirect like(SQLRETCODE_t) extproc('EXPJRNER6_SQLCLI_executeDirect');
  i_hSqlCli likeds(hSqlCli_t) value;
  i_sqlStr  pointer options(*string) value;
end-pr;

//  Terminates the SQL call level interface
dcl-pr SQLCLI_terminate like(SQLRETCODE_t) extproc('EXPJRNER6_SQLCLI_terminate');
  io_hSqlCli likeds(hSqlCli_t);
end-pr;

//  Shutdowns the SQL call level interface regardless of
//  pending connections.
dcl-pr SQLCLI_shutdown extproc('EXPJRNER6_SQLCLI_shutdown');
end-pr;

//  Returns a NULL SQL CLI handle.
dcl-pr SQLCLI_null likeds(hSqlCli_t) extproc('EXPJRNER6_SQLCLI_null');
end-pr;

//  Returns cTrue if a SQL CLI handle is NULL, else cFalse.
dcl-pr SQLCLI_isNull ind extproc('EXPJRNER6_SQLCLI_isNull');
  i_hSqlCli likeds(hSqlCli_t) const;
end-pr;

//  Opens the list of fields of a given file.
dcl-pr SQLCLI_Columns_open like(SQLRETCODE_t) extproc('EXPJRNER6_SQLCLI_Columns_open');
  o_hColumns likeds(hColumns_t);
  i_file     likeds(qObj_t) const;
end-pr;

//  Retrieves an entry from the field list.
dcl-pr SQLCLI_Columns_get like(SQLRETCODE_t) extproc('EXPJRNER6_SQLCLI_Columns_get');
  io_hColumns likeds(hColumns_t);
  o_fldAttr   likeds(fldAttr_t);
end-pr;

//  Retrieves the number of entries in the field list.
dcl-pr SQLCLI_Columns_numE int(10) extproc('EXPJRNER6_SQLCLI_Columns_numE');
  i_hColumns likeds(hColumns_t) const;
end-pr;

//  Closes a given list of fields of a file.
dcl-pr SQLCLI_Columns_close like(SQLRETCODE_t) extproc('EXPJRNER6_SQLCLI_Columns_close');
  io_hColumns likeds(hColumns_t);
end-pr;

//  Returns cTrue if a SQL CLI field list handle is NULL, else cFalse.
dcl-pr SQLCLI_Columns_isNull ind extproc('EXPJRNER6_SQLCLI_Columns_isNull');
  i_hColumn likeds(hColumns_t) const;
end-pr;

//  Returns a NULL SQL CLI field list handle.
dcl-pr SQLCLI_Columns_null likeds(hColumns_t) extproc('EXPJRNER6_SQLCLI_Columns_null');
end-pr;

//  Returns the most recent error information.
dcl-pr SQLCLI_Error_get like(msg_t) extproc('EXPJRNER6_SQLCLI_Error_get');
end-pr;

//  Returns the most recent SQL state value.
dcl-pr SQLCLI_Error_getState char(5);
end-pr;

/if DEFINED(EXPJRNE_PROTOTYPE)
/eof
/endif

/copy QBASICS1,PBASICS1                      Tools/400 Runtime Library

/define EXPJRNE_PROTOTYPE
/copy QEXPJRNE,EXPJRNER7                     Tool: EXPJRNE Utilities
/undefine EXPJRNE_PROTOTYPE

//  Clears SQL CLI error information.
dcl-pr SQLCLI_Error_clear extproc('EXPJRNER6_SQLCLI_Error_clear');
end-pr;

//  Retrieves and sets SQL CLI error information.
dcl-pr SQLCLI_Error_set extproc('EXPJRNER6_SQLCLI_Error_set');
  i_hSqlCli likeds(hSqlCli_t) value;
  i_hstmt   like(HSTMT_t) value;
end-pr;

//  Terminates the SQL call level interface.
dcl-pr terminateSqlCli like(SQLRETCODE_t) extproc('EXPJRNER6_terminateSqlCli');
  io_hSqlCli likeds(hSqlCli_t);
end-pr;

//  Global status fields
dcl-ds g_hSqlCli likeds(hSqlCli_t) inz;
dcl-s g_count int(10) inz;

dcl-ds g_sqlError qualified;
  state char(5);
  code  int(10);
  msg   varchar(256);
end-ds;

//  Global constants
dcl-c cDOUBLE_QUOTE '"';

//==================================================================*
//  Initializes the SQL call level interface
//==================================================================*
dcl-proc SQLCLI_initialize export;
  dcl-pi *n like(SQLRETCODE_t);
    o_hSqlCli likeds(hSqlCli_t);
  end-pi;

  //  Return value
  dcl-s rc like(SQLRETCODE_t) inz(SQL_ERROR);

  //  Local fields
  dcl-s option int(10);
  dcl-ds hTmpSqlCli likeds(hSqlCli_t) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  o_hSqlCli = SQLCLI_null();

  hTmpSqlCli = SQLCLI_null();

  dou '1';

    if (g_hSqlCli.isConnected);
      o_hSqlCli = g_hSqlCli;
      g_count = g_count + 1;
      rc = SQL_SUCCESS;
      leave;
    endif;

    // send status message: Connecting to server
    Message_sendStatusMsg('USR0200');

    // allocate an environment handle
    if (SQLAllocEnv(%addr(hTmpSqlCli.henv)) <> SQL_SUCCESS);
      rc = SQL_ERROR;
      leave;
    endif;

    // allocate a connection handle
    if (SQLAllocConnect(hTmpSqlCli.henv
                        : %addr(hTmpSqlCli.hdbc)) <> SQL_SUCCESS);
      rc = SQL_ERROR;
      leave;
    endif;

    // disable commit control
    option = SQL_COMMIT_NONE;
    if (SQLSetConnectOption(hTmpSqlCli.hdbc
                            : SQL_ATTR_COMMIT
                            : %addr(option)) <>  SQL_SUCCESS);
      rc = SQL_ERROR;
      leave;
    endif;

    // connect to *LOCAL server
    if (SQLConnect(hTmpSqlCli.hdbc
                   : '*LOCAL': SQL_NTS
                   : *NULL: SQL_NTS
                   : *NULL: SQL_NTS) <> SQL_SUCCESS);
      rc = SQL_ERROR;
      leave;
    endif;

    hTmpSqlCli.isConnected = cTrue;

    // set global status fields
    g_hSqlCli = hTmpSqlCli;
    g_count = g_count + 1;

    p_assert(g_count = 1
             : 'g_count does not match expected value 1: ' +
               %char(g_count));

    // set return value
    o_hSqlCli = hTmpSqlCli;

    rc = SQL_SUCCESS;
  enddo;

  // House keeping
  if (rc <> SQL_SUCCESS);
    terminateSqlCli(hTmpSqlCli);
  endif;

  return rc;

end-proc;

//==================================================================*
//  Executes a given SQL statement.
//==================================================================*
dcl-proc SQLCLI_executeDirect export;
  dcl-pi *n like(SQLRETCODE_t);
    i_hSqlCli likeds(hSqlCli_t) value;
    i_sqlStr  pointer options(*string) value;
  end-pi;

  //  Return value
  dcl-s rc like(SQLRETCODE_t) inz(SQL_ERROR);

  //  Local fields
  dcl-s tmpRc like(SQLRETCODE_t) inz(SQL_ERROR);
  dcl-s hstmt like(HSTMT_t) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  dou '1';

    SQLCLI_Error_clear();

    // allocate SQL statement handle
    if (SQLAllocStmt(i_hSqlCli.hdbc: %addr(hstmt)) <> SQL_SUCCESS);
      rc = SQL_ERROR;
      leave;
    endif;

    // execute SQL statement
    tmpRc = SQLExecDirect(hstmt: i_sqlStr: SQL_NTS);
    select;
    when (tmpRc = SQL_SUCCESS);
    // nothing to do here
    when (tmpRc = SQL_SUCCESS_WITH_INFO);
      // log warning but return SUCCESS
      SQLCLI_Error_set(i_hSqlCli: hstmt);
      if (SQLCLI_Error_getState() <>
          SQL_STATE_WARN_CREATED_NOT_JOURNALED);
        Message_sendDiagMsg(SQLCLI_Error_get());
      endif;
      SQLCLI_Error_clear();
    other;
      SQLCLI_Error_set(i_hSqlCli: hstmt);
      rc = SQL_ERROR;
      leave;
    endsl;

    // set return value
    rc = SQL_SUCCESS;
  enddo;

  // House keeping
  if (hstmt <> 0);
    SQLFreeStmt(hstmt: SQL_DROP);
    hstmt = 0;
  endif;

  return rc;

end-proc;

//==================================================================*
//  Terminates the SQL call level interface
//==================================================================*
dcl-proc SQLCLI_terminate export;
  dcl-pi *n like(SQLRETCODE_t);
    io_hSqlCli likeds(hSqlCli_t);
  end-pi;

  //  Return value
  dcl-s rc like(SQLRETCODE_t) inz(SQL_ERROR);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  dou '1';

    // return to caller if connection is still in use
    if (g_count > 1);
      g_count = g_count - 1;
      io_hSqlCli = SQLCLI_null();
      rc = SQL_SUCCESS;                                                           //RAD
      leave;
    endif;

    // terminate SQL call level interface
    if (terminateSqlCli(io_hSqlCli) <> SQL_SUCCESS);
      rc = SQL_ERROR;
      leave;
    endif;

    // decrease reference counter
    g_count   = g_count - 1;
    g_hSqlCli = io_hSqlCli;

    p_assert(g_count = 0
             : 'g_count does not match expected value 0: ' +
               %char(g_count));

    // set return value
    io_hSqlCli = SQLCLI_null();

    rc = SQL_SUCCESS;
  enddo;

  return rc;

end-proc;

//==================================================================*
//  Shutdowns the SQL call level interface regardless of
//  existing references. Usually called by abnormal end procedures.
//==================================================================*
dcl-proc SQLCLI_shutdown export;
  dcl-pi *n;
  end-pi;

  //  Helper fields
  dcl-s rc like(SQLRETCODE_t) inz(SQL_ERROR);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  // terminate SQL call level interface
  rc = terminateSqlCli(g_hSqlCli);

  // reset reference counter
  g_count = 0;


end-proc;

//==================================================================*
//  Returns a NULL SQL CLI handle.
//==================================================================*
dcl-proc SQLCLI_null export;
  dcl-pi *n likeds(hSqlCli_t);
  end-pi;

  //  Return value
  dcl-ds hSqlCli likeds(hSqlCli_t) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  hSqlCli.isConnected = cFalse;

  return hSqlCli;

end-proc;

//==================================================================*
//  Returns cTrue if a SQL CLI handle is NULL, else cFalse.
//==================================================================*
dcl-proc SQLCLI_isNull export;
  dcl-pi *n ind;
    i_hSqlCli likeds(hSqlCli_t) const;
  end-pi;

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  if (i_hSqlCli = SQLCLI_null());
    return cTrue;
  else;
    return cFalse;
  endif;


end-proc;

//==================================================================*
//  Returns a NULL SQL CLI field list handle.
//==================================================================*
dcl-proc SQLCLI_Columns_null export;
  dcl-pi *n likeds(hColumns_t);
  end-pi;

  //  Return value
  dcl-ds hColumns likeds(hColumns_t) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  clear hColumns;
  hColumns.hSqlCli = SQLCLI_null();
  hColumns.hStmt   = 0;
  hColumns.hFldDct = f_FldDct_null();

  return hColumns;

end-proc;

//==================================================================*
//  Returns cTrue if a SQL CLI field list handle is NULL, else cFalse.
//==================================================================*
dcl-proc SQLCLI_Columns_isNull export;
  dcl-pi *n ind;
    i_hColumns likeds(hColumns_t) const;
  end-pi;

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  if (i_hColumns = SQLCLI_Columns_null());
    return cTrue;
  else;
    return cFalse;
  endif;

end-proc;

//==================================================================*
//  Opens the list of fields of a given file.
//==================================================================*
dcl-proc SQLCLI_Columns_open export;
  dcl-pi *n like(SQLRETCODE_t);
    o_hColumns likeds(hColumns_t);
    i_file     likeds(qObj_t) const;
  end-pi;

  //  Return value
  dcl-s rc like(SQLRETCODE_t) inz(SQL_ERROR);

  //  Local fields
  dcl-ds hTmpColumns likeds(hColumns_t) inz;
  dcl-ds msg likeds(msg_t) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  hTmpColumns = SQLCLI_Columns_null();

  dou '1';

    // create field dictionary
    if (not f_fldDct_new(i_file.name: i_file.lib: '*FIRST'
                         : hTmpColumns.hFldDct: msg));
      msg.type = cMsg_Diag;
      f_sndPgmMsg(msg: cMsg_Same: cMsg_ToMyself);
      rc = SQL_ERROR;
      leave;
    endif;

    // initialize SQL call level interface
    if (SQLCLI_initialize(hTmpColumns.hSqlCli) <> SQL_SUCCESS);
      rc = SQL_ERROR;
      leave;
    endif;

    // create a statement handle
    if (SQLAllocStmt(hTmpColumns.hSqlCli.hdbc
                     : %addr(hTmpColumns.hStmt)) <> SQL_SUCCESS);
      rc = SQL_ERROR;
      leave;
    endif;

    // execute dummy statement
    if (SQLPrepare(hTmpColumns.hStmt: 'SELECT * FROM ' +
                                             %trim(i_file.lib)  + '.' +
                                             cDOUBLE_QUOTE +
                                             %trim(i_file.name) +
                                             cDOUBLE_QUOTE +
                                      ' WHERE RRN(' +
                                             %trim(i_file.lib) + '.' +
                                             cDOUBLE_QUOTE +
                                             %trim(i_file.name) +
                                             cDOUBLE_QUOTE +
                                             ') = -1'
                                    : SQL_NTS) <> SQL_SUCCESS);
      rc = SQL_ERROR;
      leave;
    endif;

    // get number of result columns
    if (SQLNumResultCols (hTmpColumns.hStmt
                          : %addr(hTmpColumns.numE)) <> SQL_SUCCESS);
      rc = SQL_ERROR;
      leave;
    endif;

    // set return value
    o_hColumns = hTmpColumns;
    hTmpColumns = SQLCLI_Columns_null();

    rc = SQL_SUCCESS;
  enddo;

  // house keeping
  // ... field dictionary
  if (hTmpColumns.hFldDct <> f_FldDct_null());
    f_FldDct_delete(hTmpColumns.hFldDct);
    hTmpColumns.hFldDct = f_FldDct_null();
  endif;
  // ... statement handle
  if (hTmpColumns.hStmt <> 0);
    SQLFreeStmt(hTmpColumns.hStmt: SQL_DROP);
    hTmpColumns.hStmt = 0;
  endif;
  // ... SQL call levelinterface
  if (not SQLCLI_isNull(hTmpColumns.hSqlCli));
    SQLCLI_terminate(hTmpColumns.hSqlCli);
    hTmpColumns.hSqlCli = SQLCLI_null();
  endif;

  return rc;

end-proc;

//==================================================================*
//  Retrieves an entry from the field list.
//==================================================================*
dcl-proc SQLCLI_Columns_get export;
  dcl-pi *n like(SQLRETCODE_t);
    io_hColumns likeds(hColumns_t);
    o_fldAttr   likeds(fldAttr_t);
  end-pi;

  //  Return value
  dcl-s rc like(SQLRETCODE_t) inz(SQL_ERROR);

  //  Local fields
  dcl-s x like(io_hColumns.curE) inz;
  dcl-s cbDesc like(SQLINTEGER_t) inz;
  dcl-s fDesc like(SQLINTEGER_t) inz;
  dcl-s tmpColName char(258) inz;
  dcl-s tmpColDataType like(SQLSMALLINT_t) inz;
  dcl-s tmpColLength like(SQLINTEGER_t) inz;
  dcl-ds tmpFlda0320 likeds(flda0320_t) inz;
  dcl-s tmpFlda0320s like(tmpFlda0320) based(pTmpFlda0320);
  dcl-s pTmpFlda0320 pointer inz(%addr(tmpFlda0320));
  dcl-ds tmpFldAttr likeds(o_fldAttr) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  clear o_fldAttr;
  clear tmpFldAttr;

  dou '1';

    if (io_hColumns.curE >= io_hColumns.numE);
      rc = SQL_ERROR;
      leave;
    endif;

    x = io_hColumns.curE + 1;

    // get column name
    if (SQLColAttributes(io_hColumns.hStmt
                         : x
                         : SQL_DESC_NAME
                         : %addr(tmpColName)
                         : %size(tmpColName)
                         : %addr(cbDesc)
                         : *NULL) <> SQL_SUCCESS);
      rc = SQL_ERROR;
      leave;
    endif;

    tmpColName = %str(%addr(tmpColName));   // remove NULL byte

    // get column data type
    if (SQLColAttributes(io_hColumns.hStmt
                         : x
                         : SQL_DESC_TYPE
                         : *NULL
                         : 0
                         : *NULL
                         : %addr(fDesc )      ) <> SQL_SUCCESS);
      rc = SQL_ERROR;
      leave;
    endif;

    tmpColDataType = fDesc;

    // get column length
    if (SQLColAttributes(io_hColumns.hStmt
                         : x
                         : SQL_DESC_LENGTH
                         : *NULL
                         : 0
                         : *NULL
                         : %addr(fDesc )      ) <> SQL_SUCCESS);
      rc = SQL_ERROR;
      leave;
    endif;

    tmpColLength = fDesc;

    // get remaining field attributes from dictionary
    if (not f_FldDct_rtvFldAtr(io_hColumns.hFldDct
                               : %trimR(tmpColName)
                               : tmpFlda0320s
                               : 'FLDA0320'));
      rc = SQL_ERROR;
      leave;
    endif;

    tmpFlda0320.alias = xlate(tmpFlda0320.alias);

    // add missing field text
    if (tmpFlda0320.text = '');
      tmpFlda0320.text = tmpFlda0320.name;
    endif;

    // Add missing column heading
    if (tmpFlda0320.colHdg1 = '') and
       (tmpFlda0320.colHdg2 = '') and
       (tmpFlda0320.colHdg3 = '');
      tmpFlda0320.colHdg1 = tmpFlda0320.name;
    endif;

    // if date or time format is not *ISO, ...
    if (tmpColDataType = SQL_DATE or tmpColDataType = SQL_TIME);
      if (tmpFlda0320.datTimFmt <> cFLDDCT_DTFMT_ISO);
        // ... change column type to character
        tmpColDataType = SQL_CHAR;
      endif;
    endif;

    // Overwrite length for BLOB or CLOB fields
    if (tmpColDataType = SQL_BLOB or
        tmpColDataType = SQL_CLOB);
      tmpFlda0320.length = tmpColLength;
    endif;

    o_fldAttr.flda0320 = tmpFlda0320;
    o_fldAttr.sqlType  = sqlTypeToString(tmpColDataType);

    io_hColumns.curE = x;

    rc = SQL_SUCCESS;
  enddo;

  return rc;

end-proc;

//==================================================================*
//  Retrieves the number of entries in the field list.
//==================================================================*
dcl-proc SQLCLI_Columns_numE export;
  dcl-pi *n int(10);
    i_hColumns likeds(hColumns_t) const;
  end-pi;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  return i_hColumns.numE;

end-proc;

//==================================================================*
//  Closes a given list of fields of a file.
//==================================================================*
dcl-proc SQLCLI_Columns_close export;
  dcl-pi *n like(SQLRETCODE_t);
    io_hColumns likeds(hColumns_t);
  end-pi;

  //  Return value
  dcl-s rc like(SQLRETCODE_t) inz(SQL_ERROR);

  //  Local fields
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  dou '1';

    // free statement handle
    if (io_hColumns.hStmt <> 0);
      if (SQLFreeStmt(io_hColumns.hStmt: SQL_DROP) <> SQL_SUCCESS);
        rc = SQL_ERROR;
        leave;
      endif;
      io_hColumns.hStmt = 0;
    endif;

    // terminate SQL call level interface
    if (not SQLCLI_isNull(io_hColumns.hSqlCli));
      if (SQLCLI_terminate(io_hColumns.hSqlCli) <> SQL_SUCCESS);
        rc = SQL_ERROR;
        leave;
      endif;
      io_hColumns.hSqlCli = SQLCLI_null();
    endif;

    // delete field dictionary
    if (not f_FldDct_isNull(io_hColumns.hFldDct));
      if (not f_fldDct_delete(io_hColumns.hFldDct));
        rc = SQL_ERROR;
        leave;
      endif;
      io_hColumns.hFldDct = f_FldDct_null();
    endif;

    // clear handle
    io_hColumns = SQLCLI_Columns_null();

    rc = SQL_SUCCESS;
  enddo;

  return rc;

end-proc;

//==================================================================*
//  Clears SQL CLI error information.
//==================================================================*
dcl-proc SQLCLI_Error_clear;
  dcl-pi *n;
  end-pi;

  //  Local fields
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  clear g_sqlError;

end-proc;

//==================================================================*
//  Retrieves and sets SQL CLI error information.
//==================================================================*
dcl-proc SQLCLI_Error_set;
  dcl-pi *n;
    i_hSqlCli likeds(hSqlCli_t) value;
    i_hstmt   like(HSTMT_t) value;
  end-pi;

  //  Local fields
  dcl-s state char(6) inz;
  dcl-s code int(10) inz;
  dcl-s msg char(256) inz;
  dcl-s msgLen like(SQLSMALLINT_t) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  SQLError(i_hSqlCli.henv: i_hSqlCli.hdbc: i_hstmt
           : %addr(state): %addr(code)
           : %addr(msg): %len(msg): %addr(msgLen));

  g_sqlError.state = %str(%addr(state));
  g_sqlError.code  = code;
  g_sqlError.msg   = %str(%addr(msg));

end-proc;

//==================================================================*
//  Returns the most recent error information.
//==================================================================*
dcl-proc SQLCLI_Error_get export;
  dcl-pi *n like(msg_t);
  end-pi;

  //  Return value
  dcl-ds msg likeds(msg_t) inz;

  //  Messages
/copy QEXPJRNE,USR0023
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  clear USR0023;
  USR00231 = g_sqlError.code;
  USR00232 = g_sqlError.msg;

  msg = f_newMsg('USR0023': USR0023);

  return msg;

end-proc;

//==================================================================*
//  Returns the most recent SQL state value.
//==================================================================*
dcl-proc SQLCLI_Error_getState export;
  dcl-pi *n char(5);
  end-pi;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  return g_sqlError.state;

end-proc;

//==================================================================*
//  *** private ***
//  Terminates the SQL call level interface.
//==================================================================*
dcl-proc terminateSqlCli;
  dcl-pi *n like(SQLRETCODE_t);
    io_hSqlCli likeds(hSqlCli_t);
  end-pi;

  //  Return value
  dcl-s rc like(SQLRETCODE_t) inz(SQL_ERROR);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  dou '1';

    // send status message: Disconnecting from server
    Message_sendStatusMsg('USR0201');

    // disconnect from database
    if (io_hSqlCli.isConnected);
      if (SQLDisconnect(io_hSqlCli.hdbc) <> SQL_SUCCESS);
        rc = SQL_ERROR;
        leave;
      endif;
      io_hSqlCli.isConnected = cFalse;
    endif;

    // free connection handle
    if (io_hSqlCli.hdbc <> 0);
      if (SQLFreeConnect(io_hSqlCli.hdbc) <> SQL_SUCCESS);
        rc = SQL_ERROR;
        leave;
      endif;
      io_hSqlCli.hdbc = 0;
    endif;

    // free environment handle
    if (io_hSqlCli.henv <> 0);
      if (SQLFreeEnv(io_hSqlCli.henv) <> 0);
        rc = SQL_ERROR;
        leave;
      endif;
      io_hSqlCli.henv = 0;
    endif;

    // set return value
    io_hSqlCli = SQLCLI_null();

    rc = SQL_SUCCESS;
  enddo;

  return rc;

end-proc;

