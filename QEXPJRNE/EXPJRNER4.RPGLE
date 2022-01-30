      /IF NOT DEFINED(EXPJRNE_PROTOTYPE)
      *=====================================================================*
      *                                                                     *
      *  Application . : EXPJRNE                                            *
      *  Object  . . . : EXPJRNER4                                          *
      *  Description . : Export Journal Entries - SQL                       *
      *  Author  . . . : Thomas Raddatz   <thomas.raddatz@tools400.de>      *
      *  Date  . . . . : 23.10.2001                                         *
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
      *  23.12.2002  Th.Raddatz    Fixed problem that field names longer    *
      *                            than 10 characeters were not supported.  *
      *                                                                     *
      *  10.11.2005  Th.Raddatz    Added option to select between outfile   *
      *                            types: *TYPE1 / *TYPE2.                  *
      *                                                                     *
      *  22.12.2005  Th.Raddatz    Replaced local procedures by procedures  *
      *                            of service program BASICS1.              *
      *                            Fixed bug that non *ISO dates and times  *
      *                            caused the program to crash. These       *
      *                            values are now converted to CHARACTER.   *
      *                            Replaced external data structures by     *
      *                            type definitions using LIKEDS.           *
      *                                                                     *
      *  07.02.2006  Th.Raddatz    Added outfile type *TYPE3 to support     *
      *                            files with null-capable fields.          *
      *                                                                     *
      *  10.04.2006  Th.Raddatz    Fixed problem with file names that       *
      *                            contain a dot (.).                       *
      *                                                                     *
      *  11.10.2006  D. Storch     Added support for Datatyp BIGINT         *
      *                                                                     *
      *  10.10.2007  Th.Raddatz    Now renaming field name if the name      *
      *                            contains invalid chracaters.             *
      *                            '.' is changed to '_'.                   *
      *                                                                     *
      *  31.03.2008  Th.Raddatz    Changed input parameter and return value *
      *                            of f_xlate() from 10A to 512A VARYING to *
      *                            support long field names of SQL tables.  *
      *                                                                     *
      *  18.09.2008  Th.Raddatz    Fixed typo in #MSG_ENG when removing and *
      *                            adding message description USR0019       *
      *                            (wrong message file name).               *
      *                            Renamed #MSG_ENG and #MSG_GER to         *
      *                            A_MSG_ENG and A_MSG_GER.                 *
      *                                                                     *
      *  19.09.2008  Th.Raddatz    Changed size of sqlStr_t from 32767 to   *
      *                            65535 and added new typedef sqlStrV_t.   *
      *                            Now retrieving description of output     *
      *                            file from message description TXT0001.   *
      *                            Fixed incorrect logical 'or' in          *
      *                            f_cliProcessStmt(). SQL_SUCCESS and      *
      *                            SQL_SUCCESS_WITH_INFO had to be ANDed.   *
      *                                                                     *
      *  20.09.2008  Th.Raddatz    Redesigned EXPJRNE to support additional *
      *                            object types, starting with *DTAARA.     *
      *                                                                     *
      *  12.08.2009  Th.Raddatz    Removed ' FOR SBCS DATA' clause.         *
      *                            Added ' CCSID xxxxx' clause.             *
      *                                                                     *
      *  19.08.2009  Th.Raddatz    Fixed problem that CCSID clause was      *
      *                            incorrectly added to DATE, TIME and      *
      *                            TIMESTAMP fields.                        *
      *                                                                     *
      *  12.09.2009  Th.Raddatz    Fixed problem that the CREATE TABLE      *
      *                            statement ended in error if SQL reserved *
      *                            words (such as CHECK) were used as field *
      *                            names.                                   *
      *                                                                     *
      *  06.10.2014  Th.Raddatz    Fixed compiler error RNF0203.            *
      *                                                                     *
      *  03.02.2015  Th.Raddatz    Changed to generate a pseudo field       *
      *                            for CLOB/BLOB fields.                    *
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
     H NOMAIN
      /COPY QEXPJRNE,H_SPEC
      *=====================================================================*
      /ENDIF
      *
     D f_crtOutfile_SQL...
     D                 PR              N
     D                                     extproc('EXPJRNER4_+
     D                                     f_crtOutfile_SQL+
     D                                     ')
     D  i_tplFile                    10A   const
     D  i_tplLib                     10A   const
     D  i_outFile                    10A   const
     D  i_outLib                     10A   const
     D  i_outFilFmt                  10A   const
      *
      /IF DEFINED(EXPJRNE_PROTOTYPE)
      /EOF
      /ENDIF
      *
      /COPY QBASICS1,PBASICS1                      Tools/400 Runtime Library
      /COPY QEXPJRNE,CEELIB                        CEE APIs
      /COPY QEXPJRNE,SQL                           Embedded SQL type definitions and const.
      *
      /DEFINE EXPJRNE_PROTOTYPE
      /COPY QEXPJRNE,EXPJRNER6                     Tool: EXPJRNE SQL Call Level Interface
      /COPY QEXPJRNE,EXPJRNER7                     Tool: EXPJRNE Utilities
      /UNDEFINE EXPJRNE_PROTOTYPE
      *
      *  Typedefs
     D sqlStrV_t       S          65535A   varying            based(pDummy)
      *
      *  Constants
      *  ... double quotes
     D cDOUBLE_QUOTE   C                   const('"')
     D cSINGLE_QUOTE   C                   const('''')
      *
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      *  Internal prototypes
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      *
     D p_abnEndProc...
     D                 PR                  extproc('p_abnEndProc')
     D  i_pRtxToken                    *   const
      *
     D RtxToken_t      DS                  qualified               based(pDummy)
     D  hList                              like(BasicList_handle_t )
     D  hSqlCli                            likeds(hSqlCli_t        )
      *
      *=====================================================================*
      *  Create outfile
      *=====================================================================*
      *
     P f_crtOutfile_SQL...
     P                 B                   export
     D                 PI              N
     D  i_tplFile                    10A   const
     D  i_tplLib                     10A   const
     D  i_outFile                    10A   const
     D  i_outLib                     10A   const
     D  i_outFilFmt                  10A   const
      *
      *  return value
     D isOK            S               N   inz(cFalse)
      *
      *  fields
     D x               S             10I 0 inz
     D tplFile         DS                  likeds(qObj_t    ) inz
     D fldAttr         DS                  likeds(fldAttr_t ) based(pFldAttr)
     D rc              S                   like(SQLRETCODE_t) inz
      *
     D sqlStrFld       S                   like(sqlStrV_t   ) inz
     D sqlStrText      S                   like(sqlStrV_t   ) inz
     D sqlStrCHdg      S                   like(sqlStrV_t   ) inz
     D sqlStrDesc      S                   like(sqlStrV_t   ) inz
     D text            S             52A   inz
     D msg             DS                  likeds(msg_t)
      *
     D rtxToken        DS                  likeds(rtxToken_t) inz
      *
      *  Messages
      /COPY QEXPJRNE,USR0024
      /COPY QEXPJRNE,USR0025
      /COPY QEXPJRNE,USR0026
      /COPY QEXPJRNE,USR0027
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         rtxToken.hSqlCli = SQLCLI_null();
         rtxToken.hList   = BasicList_null();

         // Register abnormal end procedure
         CEERTX(%paddr('p_abnEndProc'): %addr(rtxToken): *omit);

         dou '1';

            // Connect to DB Server
            Message_sendStatusMsg('USR0001');
            SQLCLI_initialize(rtxToken.hSqlCli);

            // Retrieve Outfile Record Format
            Message_sendStatusMsg('USR0002');

            // Produce field list ...
            rtxToken.hList = BasicList_new('*COLUMNS': 256);

            tplFile.name = i_tplFile;
            tplFile.lib  = i_tplLib;
            getOutputFileColumns(rtxToken.hList: i_outFilFmt: tplFile);

            // Initialize SQL statements
            sqlStrFld = 'CREATE TABLE ' + %trim(i_outLib) + '.' +
                                          cDOUBLE_QUOTE +
                                          %trim(i_outFile) +
                                          cDOUBLE_QUOTE + ' (';

            sqlStrText = 'LABEL ON '    + %trim(i_outLib) + '.' +
                                          cDOUBLE_QUOTE +
                                          %trim(i_outFile) +
                                          cDOUBLE_QUOTE + ' (';

            sqlStrCHdg = 'LABEL ON '    + %trim(i_outLib) + '.' +
                                          cDOUBLE_QUOTE +
                                          %trim(i_outFile) +
                                          cDOUBLE_QUOTE + ' (';

            // Loop through column list and create SQL statements
            for x = 1 to BasicList_getNumE(rtxToken.hList);
               pFldAttr = BasicList_get(rtxToken.hList: x);

               // --------------------------------------------------
               // produce SQL command: CREATE TABLE
               // --------------------------------------------------

               // ... column name
               sqlStrFld = sqlStrFld + f_addQuotes(fldAttr.flda0320.alias
                                                   : cDOUBLE_QUOTE);

               // ... add data type
               select;
               when (fldAttr.sqlType = cSQL_TYPE_CHARACTER ) or
                    (fldAttr.sqlType = cSQL_TYPE_VARCHAR   );

                  sqlStrFld = sqlStrFld + '  ' + fldAttr.sqlType + ' (' +
                              %trim(%editc(fldAttr.flda0320.length: 'Z')) + ')';

               when (fldAttr.sqlType = cSQL_TYPE_SMALLINT  ) or
                    (fldAttr.sqlType = cSQL_TYPE_INTEGER   ) or
                    (fldAttr.sqlType = cSQL_TYPE_BIGINT    ) or
                    (fldAttr.sqlType = cSQL_TYPE_DOUBLE    ) or
                    (fldAttr.sqlType = cSQL_TYPE_FLOAT     ) or
                    (fldAttr.sqlType = cSQL_TYPE_REAL      ) or
                    (fldAttr.sqlType = cSQL_TYPE_DATE      ) or
                    (fldAttr.sqlType = cSQL_TYPE_TIME      ) or
                    (fldAttr.sqlType = cSQL_TYPE_TIMESTAMP );

                  sqlStrFld = sqlStrFld + '  ' + fldAttr.sqlType;

               when (fldAttr.sqlType = cSQL_TYPE_GRAPHIC   ) or
                    (fldAttr.sqlType = cSQL_TYPE_VARGRAPHIC);

                  sqlStrFld = sqlStrFld + '  ' + fldAttr.sqlType + ' (' +
                              %trim(%editc(fldAttr.flda0320.digits: 'Z')) + ')';

               when (fldAttr.sqlType = cSQL_TYPE_DECIMAL   ) or
                    (fldAttr.sqlType = cSQL_TYPE_NUMERIC   );

                  sqlStrFld = sqlStrFld + '  ' + fldAttr.sqltype + ' (' +
                              %trim(%editc(fldAttr.flda0320.digits: 'Z')) +
                              ', ' + %char(fldAttr.flda0320.decPos) + ')';

               when (fldAttr.sqlType = cSQL_TYPE_BLOB      ) or
                    (fldAttr.sqlType = cSQL_TYPE_CLOB      );

                  sqlStrFld = sqlStrFld + '  ' + cSQL_TYPE_CHARACTER + ' (' +
                        %trim(%editc(fldAttr.flda0320.buffLength: 'Z')) + ')';

               endsl;

               // ... CCSID
               // if (fldAttr.sqlType = cSQL_TYPE_CHARACTER or
               //     fldAttr.sqlType = cSQL_TYPE_VARCHAR  );
               //    sqlStrFld = sqlStrFld + ' FOR SBCS DATA';
               // endif;
               if (hasCcsidClause(fldAttr.flda0320.type
                                  : fldAttr.flda0320.ccsid));
                  sqlStrFld = sqlStrFld +
                              ' CCSID ' + %char(fldAttr.flda0320.ccsid);
               endif;

               // ... NULL capability
               if (fldAttr.flda0320.alwNull = cFalse);
                  sqlStrFld = sqlStrFld + ' NOT NULL WITH DEFAULT';
               endif;

               // --------------------------------------------------
               // produce SQL command: ALTER TABLE (text)
               // --------------------------------------------------
               sqlStrText = sqlStrText +
                            f_addQuotes(fldAttr.flda0320.alias: cDOUBLE_QUOTE) +
                            ' TEXT IS ' +
                            cSINGLE_QUOTE +
                            f_replace(cSINGLE_QUOTE:
                                      cSINGLE_QUOTE + cSINGLE_QUOTE:
                                      %trim(fldAttr.flda0320.text)) +
                            cSINGLE_QUOTE;

               // --------------------------------------------------
               // produce SQL command: ALTER TABLE (column heading)
               // --------------------------------------------------
               sqlStrCHdg = sqlStrCHdg +
                            f_addQuotes(fldAttr.flda0320.alias: cDOUBLE_QUOTE) +
                            ' IS ' +
                            cSINGLE_QUOTE +
                            f_replace(cSINGLE_QUOTE:
                                      cSINGLE_QUOTE + cSINGLE_QUOTE:
                                      fldAttr.flda0320.colHdg1  +
                                      fldAttr.flda0320.colHdg2  +
                                      fldAttr.flda0320.colHdg3) +
                            cSINGLE_QUOTE;

               if (x <> BasicList_getNumE(rtxToken.hList));
                  sqlStrFld  = sqlStrFld  + ', ';
                  sqlStrText = sqlStrText + ', ';
                  sqlStrCHdg = sqlStrCHdg + ', ';
               endif;
            endfor;

            // Finish SQL statements
            sqlStrFld  = sqlStrFld + ')';
            sqlStrText = sqlStrText+ ')';
            sqlStrCHdg = sqlStrCHdg+ ')';

            // Create Outfile
            Message_sendStatusMsg('USR0003');

            dou '1';
               rc = SQLCLI_executeDirect(rtxToken.hSqlCli: sqlStrFld);
               if (rc = SQL_ERROR);
                  clear USR0024;
                  USR00241 = sqlStrFld;
                  Message_sendDiagMsg(f_newMsg('USR0024': USR0024));
                  leave;
               endif;

               rc = SQLCLI_executeDirect(rtxToken.hSqlCli: sqlStrText);
               if (rc = SQL_ERROR);
                  clear USR0025;
                  USR00251 = sqlStrText;
                  Message_sendDiagMsg(f_newMsg('USR0025': USR0025));
                  leave;
               endif;

               rc = SQLCLI_executeDirect(rtxToken.hSqlCli: sqlStrCHdg);
               if (rc = SQL_ERROR);
                  clear USR0026;
                  USR00261 = sqlStrCHdg;
                  Message_sendDiagMsg(f_newMsg('USR0026': USR0026));
                  leave;
               endif;

               msg = f_newMsg('TXT0001');
               text = f_rtvMsgText(msg);
               text = f_addQuotes(%trimR(text): cSINGLE_QUOTE);

               sqlStrDesc = 'LABEL ON TABLE ' + %trim(i_outLib) + '.' +
                                                %trim(i_outFile) +
                            ' IS ' + text;

               rc = SQLCLI_executeDirect(rtxToken.hSqlCli: sqlStrDesc);
               if (rc = SQL_ERROR);
                  clear USR0027;
                  USR00271 = sqlStrDesc;
                  Message_sendDiagMsg(f_newMsg('USR0027': USR0027));
                  leave;
               endif;
            enddo;

            if (rc = SQL_ERROR);
               Message_sendDiagMsg(SQLCLI_Error_get());
            endif;

            // Disconnect from DB Server
            SQLCLI_terminate(rtxToken.hSqlCli);

            // Unregister abnormal end procedure
            CEEUTX(%paddr('p_abnEndProc'): *omit);

            isOK = cTrue;
         enddo;

         // Delete temporary objects
         Message_sendStatusMsg('USR0004');

         // House keeping
         // ... list of columns
         if (not BasicList_isNull(rtxToken.hList));
            BasicList_delete(rtxToken.hList);
            rtxToken.hList = BasicList_null();
         endif;
         // ... SQL call level interface
         if (not SQLCLI_isNull(rtxToken.hSqlCli));
            SQLCLI_terminate(rtxToken.hSqlCli);
            rtxToken.hSqlCli = SQLCLI_null();
         endif;

         return isOK;

      /END-FREE
     P                 E
      *
      *=====================================================================*
      *  Terminate SQL connection
      *=====================================================================*
      *
     P p_abnEndProc...
     P                 B
     D                 PI
     D  i_pRtxToken                    *   const
      *
     D rtxToken        DS                  likeds(rtxToken_t) based(i_pRtxToken)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         if (not BasicList_isNull(rtxToken.hList));
            BasicList_delete(rtxToken.hList);
            rtxToken.hList = BasicList_null();
         endif;

         SQLCLI_shutdown();
         rtxToken.hSqlCli = SQLCLI_null();

      /END-FREE
     P                 E
      *
