     /*-----------------------------------------------------------------------*/
     /* STRPREPRC Compile Options:                                            */
     /* >>PRE-COMPILER<<                                                      */
     /*  >>CRTCMD<<   CRTBNDCL   PGM(QTEMP/&OB) +                             */
     /*                          SRCFILE(&SL/&SF) SRCMBR(&SM) +               */
     /*                          OPTION(*EVENTF);                             */
     /*   >>COMPILE<<                                                         */
     /*    >>PARM<<  TEXT('Tool: EXPJRNE    (Export Journal Entries  ) Eng'); */
     /*   >>END-COMPILE<<                                                     */
     /*   >>EXECUTE<<                                                         */
     /*   >>CMD<<     CALL PGM(QTEMP/&OB) PARM(&LI &OB);                      */
     /*   >>CMD<<     DLTPGM PGM(QTEMP/&OB);                                  */
     /* >>END-PRE-COMPILER<<                                                  */
     /*-----------------------------------------------------------------------*/
             PGM        PARM(&LI)

             DCL        VAR(&LI) TYPE(*CHAR) LEN(10)

     /*-------------------------------------------------------------*/
     /*   Cmd-ADDMSGD für Message-ID :   TXT0001                    */
     /* EXPJRNE - Exported journal entries                          */
     /*-------------------------------------------------------------*/

             ADDMSGD +
                MSGID(TXT0001) +
                MSGF(&LI/EXPJRNE) +
                MSG(+
'EXPJRNE - Exported journal entries'                                  +
                ) +
                SEV(00) +
     /*   Keine Ersatzvariablen definiert!                          */ +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

     /*-------------------------------------------------------------*/
     /*   Cmd-ADDMSGD für Message-ID :   USR0001                    */
     /* Producing SQL 'CREATE TABLE' commands ...                   */
     /*-------------------------------------------------------------*/

             ADDMSGD +
                MSGID(USR0001) +
                MSGF(&LI/EXPJRNE) +
                MSG(+
'Producing SQL ''CREATE TABLE'' commands ...'                         +
                ) +
                SEV(00) +
     /*   Keine Ersatzvariablen definiert!                          */ +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

     /*-------------------------------------------------------------*/
     /*   Cmd-ADDMSGD für Message-ID :   USR0002                    */
     /* Retrieving outfile record format ...                        */
     /*-------------------------------------------------------------*/

             ADDMSGD +
                MSGID(USR0002) +
                MSGF(&LI/EXPJRNE) +
                MSG(+
'Retrieving outfile record format ...'                                +
                ) +
                SEV(00) +
     /*   Keine Ersatzvariablen definiert!                          */ +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

     /*-------------------------------------------------------------*/
     /*   Cmd-ADDMSGD für Message-ID :   USR0003                    */
     /* Creating outfile ...                                        */
     /*-------------------------------------------------------------*/

             ADDMSGD +
                MSGID(USR0003) +
                MSGF(&LI/EXPJRNE) +
                MSG(+
'Creating outfile ...'                                                +
                ) +
                SEV(00) +
     /*   Keine Ersatzvariablen definiert!                          */ +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

     /*-------------------------------------------------------------*/
     /*   Cmd-ADDMSGD für Message-ID :   USR0004                    */
     /* Deleting temporary objects ...                              */
     /*-------------------------------------------------------------*/

             ADDMSGD +
                MSGID(USR0004) +
                MSGF(&LI/EXPJRNE) +
                MSG(+
'Deleting temporary objects ...'                                      +
                ) +
                SEV(00) +
     /*   Keine Ersatzvariablen definiert!                          */ +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

     /*-------------------------------------------------------------*/
     /*   Cmd-ADDMSGD für Message-ID :   USR0005                    */
     /* Outfile default name can not be generated. File name to lon */
     /*-------------------------------------------------------------*/

             ADDMSGD +
                MSGID(USR0005) +
                MSGF(&LI/EXPJRNE) +
                MSG(+
'Outfile default name can not be generated. File name to long.'       +
                ) +
                SEV(00) +
     /*   Keine Ersatzvariablen definiert!                          */ +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

     /*-------------------------------------------------------------*/
     /*   Cmd-ADDMSGD für Message-ID :   USR0006                    */
     /* Records can not be added when a new outfile is created.     */
     /*-------------------------------------------------------------*/

             ADDMSGD +
                MSGID(USR0006) +
                MSGF(&LI/EXPJRNE) +
                MSG(+
'Records can not be added when a new outfile is created.'             +
                ) +
                SEV(00) +
     /*   Keine Ersatzvariablen definiert!                          */ +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

     /*-------------------------------------------------------------*/
     /*   Cmd-ADDMSGD für Message-ID :   USR0007                    */
     /* Retrieving journal information ...                          */
     /*-------------------------------------------------------------*/

             ADDMSGD +
                MSGID(USR0007) +
                MSGF(&LI/EXPJRNE) +
                MSG(+
'Retrieving journal information ...'                                  +
                ) +
                SEV(00) +
     /*   Keine Ersatzvariablen definiert!                          */ +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

     /*-------------------------------------------------------------*/
     /*   Cmd-ADDMSGD für Message-ID :   USR0008                    */
     /* Specified object is not journaled. Journal records can not  */
     /*-------------------------------------------------------------*/

             ADDMSGD +
                MSGID(USR0008) +
                MSGF(&LI/EXPJRNE) +
                MSG(+
'Specified object is not journaled. Journal records can not be exporte-
d.'                                                                   +
                ) +
                SEV(00) +
     /*   Keine Ersatzvariablen definiert!                          */ +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

     /*-------------------------------------------------------------*/
     /*   Cmd-ADDMSGD für Message-ID :   USR0009                    */
     /* File record length could not be determined.                 */
     /*-------------------------------------------------------------*/

             ADDMSGD +
                MSGID(USR0009) +
                MSGF(&LI/EXPJRNE) +
                MSG(+
'File record length could not be determined.'                         +
                ) +
                SEV(00) +
     /*   Keine Ersatzvariablen definiert!                          */ +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

     /*-------------------------------------------------------------*/
     /*   Cmd-ADDMSGD für Message-ID :   USR0010                    */
     /* Outfile could not be created.                               */
     /*-------------------------------------------------------------*/

             ADDMSGD +
                MSGID(USR0010) +
                MSGF(&LI/EXPJRNE) +
                MSG(+
'Outfile could not be created.'                                       +
                ) +
                SEV(00) +
     /*   Keine Ersatzvariablen definiert!                          */ +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

     /*-------------------------------------------------------------*/
     /*   Cmd-ADDMSGD für Message-ID :   USR0011                    */
     /* Exporting journal entries ...                               */
     /*-------------------------------------------------------------*/

             ADDMSGD +
                MSGID(USR0011) +
                MSGF(&LI/EXPJRNE) +
                MSG(+
'Exporting journal entries ...'                                       +
                ) +
                SEV(00) +
     /*   Keine Ersatzvariablen definiert!                          */ +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

     /*-------------------------------------------------------------*/
     /*   Cmd-ADDMSGD für Message-ID :   USR0012                    */
     /* Exporting journal entries (&1) ...                          */
     /*-------------------------------------------------------------*/

             ADDMSGD +
                MSGID(USR0012) +
                MSGF(&LI/EXPJRNE) +
                MSG(+
'Exporting journal entries (&1) ...'                                  +
                ) +
                SEV(00) +
                FMT( +
                    (*DEC 0015 0) +
                ) +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

     /*-------------------------------------------------------------*/
     /*   Cmd-ADDMSGD für Message-ID :   USR0014                    */
     /* &3 Journal entries exported to outfile &2/&1.               */
     /*-------------------------------------------------------------*/

             ADDMSGD +
                MSGID(USR0014) +
                MSGF(&LI/EXPJRNE) +
                MSG(+
'&3 Journal entries exported to outfile &2/&1.'                       +
                ) +
                SEV(00) +
                FMT( +
                    (*CHAR 0010) +
                    (*CHAR 0010) +
                    (*CHAR 0010) +
                ) +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

     /*-------------------------------------------------------------*/
     /*   Cmd-ADDMSGD für Message-ID :   USR0015                    */
     /* No journal entries available for file &2/&1.                */
     /*-------------------------------------------------------------*/

             ADDMSGD +
                MSGID(USR0015) +
                MSGF(&LI/EXPJRNE) +
                MSG(+
'No journal entries available for file &2/&1.'                        +
                ) +
                SEV(00) +
                FMT( +
                    (*CHAR 0010) +
                    (*CHAR 0010) +
                ) +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

     /*-------------------------------------------------------------*/
     /*   Cmd-ADDMSGD für Message-ID :   USR0016                    */
     /* Command ended in error - See joblog.                        */
     /*-------------------------------------------------------------*/

             ADDMSGD +
                MSGID(USR0016) +
                MSGF(&LI/EXPJRNE) +
                MSG(+
'Command ended in error - See joblog.'                                +
                ) +
                SEV(00) +
     /*   Keine Ersatzvariablen definiert!                          */ +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

     /*-------------------------------------------------------------*/
     /*   Cmd-ADDMSGD für Message-ID :   USR0017                    */
     /* Data type of field &1 is not supported.                     */
     /*-------------------------------------------------------------*/

             ADDMSGD +
                MSGID(USR0017) +
                MSGF(&LI/EXPJRNE) +
                MSG(+
'Data type of field &1 is not supported.'                             +
                ) +
                SEV(00) +
                FMT( +
                    (*CHAR 0010) +
                ) +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

     /*-------------------------------------------------------------*/
     /*   Cmd-ADDMSGD für Message-ID :   USR0018                    */
     /* Skipped &1 journal entries due to errors.                   */
     /*-------------------------------------------------------------*/

             ADDMSGD +
                MSGID(USR0018) +
                MSGF(&LI/EXPJRNE) +
                MSG(+
'Skipped &1 journal entries due to errors.'                           +
                ) +
                SECLVL(+
'&N &N Information . . :   &1 journal entries have not been exported b-
ecause of incomplete data or because of journal parameter ''MINENTDTA'-
'.'                                                                   +
                ) +
                SEV(00) +
                FMT( +
                    (*CHAR 0010) +
                ) +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

     /*-------------------------------------------------------------*/
     /*   Cmd-ADDMSGD für Message-ID :   USR0019                    */
     /* Renamed field or record format &1 to &2.                    */
     /*-------------------------------------------------------------*/

             ADDMSGD +
                MSGID(USR0019) +
                MSGF(&LI/EXPJRNE) +
                MSG(+
'Renamed field or record format &1 to &2.'                            +
                ) +
                SECLVL(+
'&N &N Information . . :   Field or record format &1 has been renamed -
to &2 because the name contained invalid characters.'                 +
                ) +
                SEV(00) +
                FMT( +
                    (*CHAR 0010) +
                    (*CHAR 0010) +
                ) +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

     /*-------------------------------------------------------------*/
     /*   Cmd-ADDMSGD für Message-ID :   USR0020                    */
     /* Memory adressing violation. Program halted.                 */
     /*-------------------------------------------------------------*/

             ADDMSGD +
                MSGID(USR0020) +
                MSGF(&LI/EXPJRNE) +
                MSG(+
'Memory adressing violation. Program halted.'                         +
                ) +
                SECLVL(+
'&N &N Information . . :   The program tried to access memory outside -
the specified boundaries. Please report that error to the developer.' +
                ) +
                SEV(00) +
     /*   Keine Ersatzvariablen definiert!                          */ +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

     /*-------------------------------------------------------------*/
     /*   Cmd-ADDMSGD für Message-ID :   USR0021                    */
     /* Level check on file &1 in library &2.                       */
     /*-------------------------------------------------------------*/

             ADDMSGD +
                MSGID(USR0021) +
                MSGF(&LI/EXPJRNE) +
                MSG(+
'Level check on file &1 in library &2.'                               +
                ) +
                SECLVL(+
'&N &N Information . . :   Number of fields do not match.'            +
                ) +
                SEV(00) +
                FMT( +
                    (*CHAR 0010) +
                    (*CHAR 0010) +
                ) +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

     /*-------------------------------------------------------------*/
     /*   Cmd-ADDMSGD für Message-ID :   USR0022                    */
     /* Level check on field &3 in file &1 in library &2.           */
     /*-------------------------------------------------------------*/

             ADDMSGD +
                MSGID(USR0022) +
                MSGF(&LI/EXPJRNE) +
                MSG(+
'Level check on field &3 in file &1 in library &2.'                   +
                ) +
                SECLVL(+
'&N &N Information . . :   Attributes of field &3 in file &1 in librar-
y &2 do not match expected values.'                                   +
                ) +
                SEV(00) +
                FMT( +
                    (*CHAR 0010) +
                    (*CHAR 0010) +
                    (*CHAR 0010) +
                ) +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

     /*-------------------------------------------------------------*/
     /*   Cmd-ADDMSGD für Message-ID :   USR0023                    */
     /* &1: &2                                                      */
     /*-------------------------------------------------------------*/

             ADDMSGD +
                MSGID(USR0023) +
                MSGF(&LI/EXPJRNE) +
                MSG(+
'&1: &2'                                                              +
                ) +
                SEV(00) +
                FMT( +
                    (*DEC 0010 0) +
                    (*CHAR 0256) +
                ) +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

     /*-------------------------------------------------------------*/
     /*   Cmd-ADDMSGD für Message-ID :   USR0024                    */
     /* Failed to execute SQL statement to create the output file.  */
     /*-------------------------------------------------------------*/

             ADDMSGD +
                MSGID(USR0024) +
                MSGF(&LI/EXPJRNE) +
                MSG(+
'Failed to execute SQL statement to create the output file.'          +
                ) +
                SECLVL(+
'&N &N SQL statement . :   &1'                                        +
                ) +
                SEV(00) +
                FMT( +
                    (*CHAR 0512) +
                ) +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

     /*-------------------------------------------------------------*/
     /*   Cmd-ADDMSGD für Message-ID :   USR0025                    */
     /* Failed to execute SQL statement to set the field descriptio */
     /*-------------------------------------------------------------*/

             ADDMSGD +
                MSGID(USR0025) +
                MSGF(&LI/EXPJRNE) +
                MSG(+
'Failed to execute SQL statement to set the field description of the o-
utput file.'                                                          +
                ) +
                SECLVL(+
'&N &N SQL statement . :   &1'                                        +
                ) +
                SEV(00) +
                FMT( +
                    (*CHAR 0512) +
                ) +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

     /*-------------------------------------------------------------*/
     /*   Cmd-ADDMSGD für Message-ID :   USR0026                    */
     /* Failed to execute SQL statement to set the column headings  */
     /*-------------------------------------------------------------*/

             ADDMSGD +
                MSGID(USR0026) +
                MSGF(&LI/EXPJRNE) +
                MSG(+
'Failed to execute SQL statement to set the column headings of the out-
put file.'                                                            +
                ) +
                SECLVL(+
'&N &N SQL statement . :   &1'                                        +
                ) +
                SEV(00) +
                FMT( +
                    (*CHAR 0512) +
                ) +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

     /*-------------------------------------------------------------*/
     /*   Cmd-ADDMSGD für Message-ID :   USR0027                    */
     /* Failed to execute SQL statement to set the text description */
     /*-------------------------------------------------------------*/

             ADDMSGD +
                MSGID(USR0027) +
                MSGF(&LI/EXPJRNE) +
                MSG(+
'Failed to execute SQL statement to set the text description of the ou-
tput file.'                                                           +
                ) +
                SECLVL(+
'&N &N SQL statement . :   &1'                                        +
                ) +
                SEV(00) +
                FMT( +
                    (*CHAR 0512) +
                ) +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

     /*-------------------------------------------------------------*/
     /*   Cmd-ADDMSGD für Message-ID :   USR0028                    */
     /* Parameter OBJTYPE contains an invalid value.                */
     /*-------------------------------------------------------------*/

             ADDMSGD +
                MSGID(USR0028) +
                MSGF(&LI/EXPJRNE) +
                MSG(+
'Parameter OBJTYPE contains an invalid value.'                        +
                ) +
                SECLVL(+
'&N &N Cause . . . . . :   Value &1 is not supported by the current re-
lease level of the operating system. The minimum release level is V5R4-
M0. The release level of your system is: &2.'                         +
                ) +
                SEV(00) +
                FMT( +
                    (*CHAR 0010) +
                    (*CHAR 0006) +
                ) +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

     /*-------------------------------------------------------------*/
     /*   Cmd-ADDMSGD für Message-ID :   USR0029                    */
     /* Output file must be different from the input file.          */
     /*-------------------------------------------------------------*/

             ADDMSGD +
                MSGID(USR0029) +
                MSGF(&LI/EXPJRNE) +
                MSG(+
'Output file must be different from the input file.'                  +
                ) +
                SECLVL(+
'&N &N Cause . . . . . :   The output file must not be the same file t-
he journal entries are exported from. Please choose a different name f-
for the output file and try your request again.'                      +
                ) +
                SEV(00) +
     /*   Keine Ersatzvariablen definiert!                          */ +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

     /*-------------------------------------------------------------*/
     /*   Cmd-ADDMSGD für Message-ID :   USR0030                    */
     /* Field overflow occurred in field: &1                        */
     /*-------------------------------------------------------------*/

             ADDMSGD +
                MSGID(USR0030) +
                MSGF(&LI/EXPJRNE) +
                MSG(+
'Field overflow occurred in field: &1'                                +
                ) +
                SECLVL(+
'&N &N Cause . . . . . :   A value for field &1 has exceeded the maxim-
um possible value. The error has been caught and the field value was s-
et to: value - maxValue - 1'                                          +
                ) +
                SEV(00) +
                FMT( +
                    (*CHAR 0010) +
                ) +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

     /*-------------------------------------------------------------*/
     /*   Cmd-ADDMSGD für Message-ID :   USR0031                    */
     /* Field overflow occurred in field: &1                        */
     /*-------------------------------------------------------------*/

             ADDMSGD +
                MSGID(USR0031) +
                MSGF(&LI/EXPJRNE) +
                MSG(+
'Invalid timestamp field: &1.'                                        +
                ) +
                SECLVL(+
'&N &N Cause . . . . . :   The number of fractional-seconds is not sup-
ported by DDS. Number of fractional-seconds: &2. &N Solution  . . . : -
  Set parameter CRTFILE to *SQL to use SQL for creating the output fil-
e.'                                                                   +
                ) +
                SEV(00) +
                FMT( +
                    (*CHAR 0010) +
                    (*DEC 2 0) +
                ) +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

     /*-------------------------------------------------------------*/
     /*   Cmd-ADDMSGD für Message-ID :   USR0101                    */
     /* Create temporary source file ...                            */
     /*-------------------------------------------------------------*/

             ADDMSGD +
                MSGID(USR0101) +
                MSGF(&LI/EXPJRNE) +
                MSG(+
'Create temporary source file ...'                                    +
                ) +
                SEV(00) +
     /*   Keine Ersatzvariablen definiert!                          */ +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

     /*-------------------------------------------------------------*/
     /*   Cmd-ADDMSGD für Message-ID :   USR0102                    */
     /* Retrieving outfile record format ...                        */
     /*-------------------------------------------------------------*/

             ADDMSGD +
                MSGID(USR0102) +
                MSGF(&LI/EXPJRNE) +
                MSG(+
'Retrieving outfile record format ...'                                +
                ) +
                SEV(00) +
     /*   Keine Ersatzvariablen definiert!                          */ +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

     /*-------------------------------------------------------------*/
     /*   Cmd-ADDMSGD für Message-ID :   USR0103                    */
     /* Creating outfile ...                                        */
     /*-------------------------------------------------------------*/

             ADDMSGD +
                MSGID(USR0103) +
                MSGF(&LI/EXPJRNE) +
                MSG(+
'Creating outfile ...'                                                +
                ) +
                SEV(00) +
     /*   Keine Ersatzvariablen definiert!                          */ +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

     /*-------------------------------------------------------------*/
     /*   Cmd-ADDMSGD für Message-ID :   USR0104                    */
     /* Deleting temporary objects ...                              */
     /*-------------------------------------------------------------*/

             ADDMSGD +
                MSGID(USR0104) +
                MSGF(&LI/EXPJRNE) +
                MSG(+
'Deleting temporary objects ...'                                      +
                ) +
                SEV(00) +
     /*   Keine Ersatzvariablen definiert!                          */ +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

     /*-------------------------------------------------------------*/
     /*   Cmd-ADDMSGD für Message-ID :   USR0200                    */
     /* Connecting to DB Server ...                                 */
     /*-------------------------------------------------------------*/

             ADDMSGD +
                MSGID(USR0200) +
                MSGF(&LI/EXPJRNE) +
                MSG(+
'Connecting to DB Server ...'                                         +
                ) +
                SEV(00) +
     /*   Keine Ersatzvariablen definiert!                          */ +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

     /*-------------------------------------------------------------*/
     /*   Cmd-ADDMSGD für Message-ID :   USR0201                    */
     /* Disconnecting from DB server ...                            */
     /*-------------------------------------------------------------*/

             ADDMSGD +
                MSGID(USR0201) +
                MSGF(&LI/EXPJRNE) +
                MSG(+
'Disconnecting from DB server ...'                                    +
                ) +
                SEV(00) +
     /*   Keine Ersatzvariablen definiert!                          */ +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

             RCLRSC LVL(*)

             ENDPGM
