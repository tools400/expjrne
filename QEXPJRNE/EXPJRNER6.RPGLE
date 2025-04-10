      /IF NOT DEFINED(EXPJRNE_PROTOTYPE)
      *=====================================================================*
      *                                                                     *
      *  Application . : EXPJRNE                                            *
      *  Object  . . . : EXPJRNER6                                          *
      *  Description . : Export Journal Entries - SQLCLI                    *
      *  Author  . . . : Thomas Raddatz   <thomas.raddatz@tools400.de>      *
      *  Date  . . . . : 25.09.2008                                         *
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
      *  20.09.2008  Th.Raddatz    Redesigned EXPJRNE to support additional *
      *                            object types, starting with *DTAARA.     *
      *                                                                     *
      *  17.11.2011  Th.Raddatz    Removed misleading error message when    *
      *                            a SQL statement was executed but with    *
      *                            warnings.                                *
      *                                                                     *
      *  03.02.2015  Th.Raddatz    Changed SQLCLI_Columns_get() to return   *
      *                            length of CLOB and BLOB fields.          *
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
      *     >>PARM<< TGTRLS(V7R3M0);                                        *
      *   >>END-IMPORTANT<<                                                 *
      *   >>EXECUTE<<                                                       *
      * >>END-PRE-COMPILER<<                                                *
      *=====================================================================*
     H NOMAIN
      /COPY QEXPJRNE,H_SPEC
      *=====================================================================*
      /ENDIF
      *
      /COPY QEXPJRNE,SQLCLI                        SQL Call level Interface
      /COPY QRTVFLDA,PRTVFLDA                      Field Attributes Dictionary
      *
     D hSqlCli_t       DS                  qualified               based(pDummy)
     D  henv                               like(HENV_t  )
     D  hdbc                               like(HDBC_t  )
     D  isConnected                    N
      *
     D hColumns_t      DS                  qualified  align        based(pDummy)
     D  hSqlCli                            likeds(hSqlCli_t     )
     D  hStmt                              like(HSTMT_t         )
     D  hFldDct                            like(fldDct_handle_t )
     D  numE                          5I 0
     D  curE                          5I 0
      *
     D fldAttr_t       DS                  qualified               based(pDummy)
     D  flda0320                           likeds(flda0320_t   )
     D  sqlType                      32A   varying
      *
      *  Initializes the SQL call level interface
     D SQLCLI_initialize...
     D                 PR                         like(SQLRETCODE_t )
     D                                     extproc('EXPJRNER6_+
     D                                     SQLCLI_initialize+
     D                                     ')
     D  o_hSqlCli                                 likeds(hSqlCli_t  )
      *
      *  Executes a given SQL statement.
     D SQLCLI_executeDirect...
     D                 PR                         like(SQLRETCODE_t )
     D                                     extproc('EXPJRNER6_+
     D                                     SQLCLI_executeDirect+
     D                                     ')
     D  i_hSqlCli                          value  likeds(hSqlCli_t  )
     D  i_sqlStr                       *   value  options(*string)
      *
      *  Terminates the SQL call level interface
     D SQLCLI_terminate...
     D                 PR                         like(SQLRETCODE_t )
     D                                     extproc('EXPJRNER6_+
     D                                     SQLCLI_terminate+
     D                                     ')
     D  io_hSqlCli                                likeds(hSqlCli_t  )
      *
      *  Shutdowns the SQL call level interface regardless of
      *  pending connections.
     D SQLCLI_shutdown...
     D                 PR
     D                                     extproc('EXPJRNER6_+
     D                                     SQLCLI_shutdown+
     D                                     ')
      *
      *  Returns a NULL SQL CLI handle.
     D SQLCLI_null...
     D                 PR                         likeds(hSqlCli_t  )
     D                                     extproc('EXPJRNER6_+
     D                                     SQLCLI_null+
     D                                     ')
      *
      *  Returns cTrue if a SQL CLI handle is NULL, else cFalse.
     D SQLCLI_isNull...
     D                 PR              N
     D                                     extproc('EXPJRNER6_+
     D                                     SQLCLI_isNull+
     D                                     ')
     D  i_hSqlCli                          const  likeds(hSqlCli_t  )
      *
      *  Opens the list of fields of a given file.
     D SQLCLI_Columns_open...
     D                 PR                         like(SQLRETCODE_t )
     D                                     extproc('EXPJRNER6_+
     D                                     SQLCLI_Columns_open+
     D                                     ')
     D  o_hColumns                                likeds(hColumns_t )
     D  i_file                             const  likeds(qObj_t     )
      *
      *  Retrieves an entry from the field list.
     D SQLCLI_Columns_get...
     D                 PR                         like(SQLRETCODE_t )
     D                                     extproc('EXPJRNER6_+
     D                                     SQLCLI_Columns_get+
     D                                     ')
     D  io_hColumns                               likeds(hColumns_t )
     D  o_fldAttr                                 likeds(fldAttr_t  )
      *
      *  Retrieves the number of entries in the field list.
     D SQLCLI_Columns_numE...
     D                 PR            10I 0
     D                                     extproc('EXPJRNER6_+
     D                                     SQLCLI_Columns_numE+
     D                                     ')
     D  i_hColumns                         const  likeds(hColumns_t )
      *
      *  Closes a given list of fields of a file.
     D SQLCLI_Columns_close...
     D                 PR                         like(SQLRETCODE_t )
     D                                     extproc('EXPJRNER6_+
     D                                     SQLCLI_Columns_close+
     D                                     ')
     D  io_hColumns                               likeds(hColumns_t )
      *
      *  Returns cTrue if a SQL CLI field list handle is NULL, else cFalse.
     D SQLCLI_Columns_isNull...
     D                 PR              N
     D                                     extproc('EXPJRNER6_+
     D                                     SQLCLI_Columns_isNull+
     D                                     ')
     D  i_hColumn                          const  likeds(hColumns_t )
      *
      *  Returns a NULL SQL CLI field list handle.
     D SQLCLI_Columns_null...
     D                 PR                         likeds(hColumns_t )
     D                                     extproc('EXPJRNER6_+
     D                                     SQLCLI_Columns_null+
     D                                     ')
      *
      *  Returns the most recent error information.
     D SQLCLI_Error_get...
     D                 PR                         like(msg_t )
     D                                     extproc('EXPJRNER6_+
     D                                     SQLCLI_Error_get+
     D                                     ')
      *
      *  Returns the most recent SQL state value.
     D SQLCLI_Error_getState...
     D                 PR             5A
      *
      /IF DEFINED(EXPJRNE_PROTOTYPE)
      /EOF
      /ENDIF
      *
      /COPY QBASICS1,PBASICS1                      Tools/400 Runtime Library
      *
      /DEFINE EXPJRNE_PROTOTYPE
      /COPY QEXPJRNE,EXPJRNER7                     Tool: EXPJRNE Utilities
      /UNDEFINE EXPJRNE_PROTOTYPE
      *
      *  Clears SQL CLI error information.
     D SQLCLI_Error_clear...
     D                 PR
     D                                     extproc('EXPJRNER6_+
     D                                     SQLCLI_Error_clear+
     D                                     ')
      *
      *  Retrieves and sets SQL CLI error information.
     D SQLCLI_Error_set...
     D                 PR
     D                                     extproc('EXPJRNER6_+
     D                                     SQLCLI_Error_set+
     D                                     ')
     D  i_hSqlCli                          value  likeds(hSqlCli_t  )
     D  i_hstmt                            value  like(HSTMT_t      )
      *
      *  Terminates the SQL call level interface.
     D terminateSqlCli...
     D                 PR                         like(SQLRETCODE_t )
     D                                     extproc('EXPJRNER6_+
     D                                     terminateSqlCli+
     D                                     ')
     D  io_hSqlCli                                likeds(hSqlCli_t  )
      *
      *  Global status fields
     D g_hSqlCli       DS                  likeds(hSqlCli_t  ) inz
     D g_count         S             10I 0 inz
      *
     D g_sqlError      DS                  qualified
     D  state                         5A
     D  code                         10I 0
     D  msg                         256A   varying
      *
      *  Global constants
     D cDOUBLE_QUOTE   C                   const('"')
      *
      *==================================================================*
      *  Initializes the SQL call level interface
      *==================================================================*
     P SQLCLI_initialize...
     P                 B                   export
     D                 PI                         like(SQLRETCODE_t )
     D  o_hSqlCli                                 likeds(hSqlCli_t  )
      *
      *  Return value
     D rc              S                   like(SQLRETCODE_t ) inz(SQL_ERROR)
      *
      *  Local fields
     D option          S             10I 0
     D hTmpSqlCli      DS                  likeds(hSqlCli_t  ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

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

      /END-FREE
     P                 E
      *
      *==================================================================*
      *  Executes a given SQL statement.
      *==================================================================*
     P SQLCLI_executeDirect...
     P                 B                   export
     D                 PI                         like(SQLRETCODE_t )
     D  i_hSqlCli                          value  likeds(hSqlCli_t  )
     D  i_sqlStr                       *   value  options(*string)
      *
      *  Return value
     D rc              S                   like(SQLRETCODE_t ) inz(SQL_ERROR)
      *
      *  Local fields
     D tmpRc           S                   like(SQLRETCODE_t ) inz(SQL_ERROR)
     D hstmt           S                   like(HSTMT_t     ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

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

      /END-FREE
     P                 E
      *
      *==================================================================*
      *  Terminates the SQL call level interface
      *==================================================================*
     P SQLCLI_terminate...
     P                 B                   export
     D                 PI                         like(SQLRETCODE_t )
     D  io_hSqlCli                                likeds(hSqlCli_t  )
      *
      *  Return value
     D rc              S                   like(SQLRETCODE_t ) inz(SQL_ERROR)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         dou '1';

            // return to caller if connection is still in use
            if (g_count > 1);
               g_count = g_count - 1;
               io_hSqlCli = SQLCLI_null();
               rc = SQL_SUCCESS;                                                         //RAD
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

      /END-FREE
     P                 E
      *
      *==================================================================*
      *  Shutdowns the SQL call level interface regardless of
      *  existing references. Usually called by abnormal end procedures.
      *==================================================================*
     P SQLCLI_shutdown...
     P                 B                   export
     D                 PI
      *
      *  Helper fields
     D rc              S                   like(SQLRETCODE_t ) inz(SQL_ERROR)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         // terminate SQL call level interface
         rc = terminateSqlCli(g_hSqlCli);

         // reset reference counter
         g_count = 0;

      /END-FREE
      *
     P SQLCLI_shutdown...
     P                 E
      *
      *==================================================================*
      *  Returns a NULL SQL CLI handle.
      *==================================================================*
     P SQLCLI_null...
     P                 B                   export
      *
     D SQLCLI_null...
     D                 PI                         likeds(hSqlCli_t  )
      *
      *  Return value
     D hSqlCli         DS                  likeds(hSqlCli_t  ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         hSqlCli.isConnected = cFalse;

         return hSqlCli;

      /END-FREE
     P                 E
      *
      *==================================================================*
      *  Returns cTrue if a SQL CLI handle is NULL, else cFalse.
      *==================================================================*
     P SQLCLI_isNull...
     P                 B                   export
     D                 PI              N
     D  i_hSqlCli                          const  likeds(hSqlCli_t  )
      *
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         if (i_hSqlCli = SQLCLI_null());
            return cTrue;
         else;
            return cFalse;
         endif;

      /END-FREE
      *
     P SQLCLI_isNull...
     P                 E
      *
      *==================================================================*
      *  Returns a NULL SQL CLI field list handle.
      *==================================================================*
     P SQLCLI_Columns_null...
     P                 B                   export
      *
     D SQLCLI_Columns_null...
     D                 PI                         likeds(hColumns_t )
      *
      *  Return value
     D hColumns        DS                  likeds(hColumns_t ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         clear hColumns;
         hColumns.hSqlCli = SQLCLI_null();
         hColumns.hStmt   = 0;
         hColumns.hFldDct = f_FldDct_null();

         return hColumns;

      /END-FREE
     P                 E
      *
      *==================================================================*
      *  Returns cTrue if a SQL CLI field list handle is NULL, else cFalse.
      *==================================================================*
     P SQLCLI_Columns_isNull...
     P                 B                   export
     D                 PI              N
     D  i_hColumns                         const  likeds(hColumns_t )
      *
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         if (i_hColumns = SQLCLI_Columns_null());
            return cTrue;
         else;
            return cFalse;
         endif;

      /END-FREE
     P                 E
      *
      *==================================================================*
      *  Opens the list of fields of a given file.
      *==================================================================*
     P SQLCLI_Columns_open...
     P                 B                   export
     D                 PI                         like(SQLRETCODE_t )
     D  o_hColumns                                likeds(hColumns_t )
     D  i_file                             const  likeds(qObj_t     )
      *
      *  Return value
     D rc              S                   like(SQLRETCODE_t ) inz(SQL_ERROR)
      *
      *  Local fields
     D hTmpColumns     DS                  likeds(hColumns_t ) inz
     D msg             DS                  likeds(msg_t      ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

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

      /END-FREE
     P                 E
      *
      *==================================================================*
      *  Retrieves an entry from the field list.
      *==================================================================*
     P SQLCLI_Columns_get...
     P                 B                   export
     D                 PI                         like(SQLRETCODE_t )
     D  io_hColumns                               likeds(hColumns_t )
     D  o_fldAttr                                 likeds(fldAttr_t  )
      *
      *  Return value
     D rc              S                   like(SQLRETCODE_t ) inz(SQL_ERROR)
      *
      *  Local fields
     D x               S                   like(io_hColumns.curE ) inz
     D cbDesc          S                   like(SQLINTEGER_t     ) inz
     D fDesc           S                   like(SQLINTEGER_t     ) inz
     D tmpColName      S            258A                           inz
     D tmpColDataType  S                   like(SQLSMALLINT_t    ) inz
     D tmpColLength    S                   like(SQLINTEGER_t     ) inz
     D tmpFlda0320     DS                  likeds(flda0320_t     ) inz
     D tmpFlda0320s    S                   like(tmpFlda0320      )
     D                                     based(pTmpFlda0320)
     D pTmpFlda0320    S               *   inz(%addr(tmpFlda0320))
     D tmpFldAttr      DS                  likeds(o_fldAttr      ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

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

      /END-FREE
     P                 E
      *
      *==================================================================*
      *  Retrieves the number of entries in the field list.
      *==================================================================*
     P SQLCLI_Columns_numE...
     P                 B                   export
     D                 PI            10I 0
     D  i_hColumns                         const  likeds(hColumns_t )
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         return i_hColumns.numE;

      /END-FREE
     P                 E
      *
      *==================================================================*
      *  Closes a given list of fields of a file.
      *==================================================================*
     P SQLCLI_Columns_close...
     P                 B                   export
     D                 PI                         like(SQLRETCODE_t )
     D  io_hColumns                               likeds(hColumns_t )
      *
      *  Return value
     D rc              S                   like(SQLRETCODE_t ) inz(SQL_ERROR)
      *
      *  Local fields
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

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

      /END-FREE
     P                 E
      *
      *==================================================================*
      *  Clears SQL CLI error information.
      *==================================================================*
     P SQLCLI_Error_clear...
     P                 B
     D                 PI
      *
      *  Local fields
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         clear g_sqlError;

      /END-FREE
     P                 E
      *
      *==================================================================*
      *  Retrieves and sets SQL CLI error information.
      *==================================================================*
     P SQLCLI_Error_set...
     P                 B
     D                 PI
     D  i_hSqlCli                          value  likeds(hSqlCli_t  )
     D  i_hstmt                            value  like(HSTMT_t      )
      *
      *  Local fields
     D state           S              6A   inz
     D code            S             10I 0 inz
     D msg             S            256A   inz
     D msgLen          S                   like(SQLSMALLINT_t) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         SQLError(i_hSqlCli.henv: i_hSqlCli.hdbc: i_hstmt
                  : %addr(state): %addr(code)
                  : %addr(msg): %len(msg): %addr(msgLen));

         g_sqlError.state = %str(%addr(state));
         g_sqlError.code  = code;
         g_sqlError.msg   = %str(%addr(msg));

      /END-FREE
     P                 E
      *
      *==================================================================*
      *  Returns the most recent error information.
      *==================================================================*
     P SQLCLI_Error_get...
     P                 B                   export
     D                 PI                         like(msg_t )
      *
      *  Return value
     D msg             DS                  likeds(msg_t ) inz
      *
      *  Messages
      /COPY QEXPJRNE,USR0023
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         clear USR0023;
         USR00231 = g_sqlError.code;
         USR00232 = g_sqlError.msg;

         msg = f_newMsg('USR0023': USR0023);

         return msg;

      /END-FREE
     P                 E
      *
      *==================================================================*
      *  Returns the most recent SQL state value.
      *==================================================================*
     P SQLCLI_Error_getState...
     P                 B                   export
     D                 PI             5A
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         return g_sqlError.state;

      /END-FREE
     P                 E
      *
      *==================================================================*
    R *  *** private ***
      *  Terminates the SQL call level interface.
      *==================================================================*
     P terminateSqlCli...
     P                 B
     D                 PI                         like(SQLRETCODE_t )
     D  io_hSqlCli                                likeds(hSqlCli_t  )
      *
      *  Return value
     D rc              S                   like(SQLRETCODE_t ) inz(SQL_ERROR)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

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

      /END-FREE
     P                 E
      *
