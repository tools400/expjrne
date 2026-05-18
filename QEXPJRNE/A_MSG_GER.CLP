     /*-----------------------------------------------------------------------*/
     /* STRPREPRC Compile Options:                                            */
     /* >>PRE-COMPILER<<                                                      */
     /*  >>CRTCMD<<   CRTBNDCL   PGM(QTEMP/&OB) +                             */
     /*                          SRCFILE(&SL/&SF) SRCMBR(&SM) +               */
     /*                          OPTION(*EVENTF);                             */
     /*   >>COMPILE<<                                                         */
     /*    >>PARM<<  TEXT('Tool: EXPJRNE    (Export Journal Entries  ) Ger'); */
     /*   >>END-COMPILE<<                                                     */
     /*   >>EXECUTE<<                                                         */
     /*   >>CMD<<     CALL PGM(QTEMP/&OB) PARM(&LI &OB);                      */
     /*   >>CMD<<     DLTPGM PGM(QTEMP/&OB);                                  */
     /* >>END-PRE-COMPILER<<                                                  */
     /*-----------------------------------------------------------------------*/
             PGM        PARM(&LI)

             DCL        VAR(&LI) TYPE(*CHAR) LEN(10)

     /*-------------------------------------------------------------*/
     /*   Cmd-ADDMSGD fr Message-ID :   TXT0001                    */
     /* EXPJRNE - Exportierte Journaleintrge                       */
     /*-------------------------------------------------------------*/

             ADDMSGD +
                MSGID(TXT0001) +
                MSGF(&LI/EXPJRNE) +
                MSG(+
'EXPJRNE - Exportierte Journaleintrge'                               +
                ) +
                SEV(00) +
     /*   Keine Ersatzvariablen definiert!                          */ +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

     /*-------------------------------------------------------------*/
     /*   Cmd-ADDMSGD fr Message-ID :   USR0001                    */
     /* Erzeugen SQL 'CREATE TABLE' Befehle ...                     */
     /*-------------------------------------------------------------*/

             ADDMSGD +
                MSGID(USR0001) +
                MSGF(&LI/EXPJRNE) +
                MSG(+
'Erzeugen SQL ''CREATE TABLE'' Befehle ...'                           +
                ) +
                SEV(00) +
     /*   Keine Ersatzvariablen definiert!                          */ +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

     /*-------------------------------------------------------------*/
     /*   Cmd-ADDMSGD fr Message-ID :   USR0002                    */
     /* Abrufen Format der Ausgabedatei ...                         */
     /*-------------------------------------------------------------*/

             ADDMSGD +
                MSGID(USR0002) +
                MSGF(&LI/EXPJRNE) +
                MSG(+
'Abrufen Format der Ausgabedatei ...'                                 +
                ) +
                SEV(00) +
     /*   Keine Ersatzvariablen definiert!                          */ +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

     /*-------------------------------------------------------------*/
     /*   Cmd-ADDMSGD fr Message-ID :   USR0003                    */
     /* Erstellen der Ausgabedatei ...                              */
     /*-------------------------------------------------------------*/

             ADDMSGD +
                MSGID(USR0003) +
                MSGF(&LI/EXPJRNE) +
                MSG(+
'Erstellen der Ausgabedatei ...'                                      +
                ) +
                SEV(00) +
     /*   Keine Ersatzvariablen definiert!                          */ +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

     /*-------------------------------------------------------------*/
     /*   Cmd-ADDMSGD fr Message-ID :   USR0004                    */
     /* Lschen temporrer Arbeitsobjekte ...                       */
     /*-------------------------------------------------------------*/

             ADDMSGD +
                MSGID(USR0004) +
                MSGF(&LI/EXPJRNE) +
                MSG(+
'Lschen temporrer Arbeitsobjekte ...'                               +
                ) +
                SEV(00) +
     /*   Keine Ersatzvariablen definiert!                          */ +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

     /*-------------------------------------------------------------*/
     /*   Cmd-ADDMSGD fr Message-ID :   USR0005                    */
     /* Standardname fr Ausgabedatei kann nicht generiert werden.  */
     /*-------------------------------------------------------------*/

             ADDMSGD +
                MSGID(USR0005) +
                MSGF(&LI/EXPJRNE) +
                MSG(+
'Standardname fr Ausgabedatei kann nicht generiert werden. Name der D-
atei zu lang.'                                                        +
                ) +
                SEV(00) +
     /*   Keine Ersatzvariablen definiert!                          */ +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

     /*-------------------------------------------------------------*/
     /*   Cmd-ADDMSGD fr Message-ID :   USR0006                    */
     /* Stze knnen nicht hinzugefgt werden, wenn die Ausgabedate */
     /*-------------------------------------------------------------*/

             ADDMSGD +
                MSGID(USR0006) +
                MSGF(&LI/EXPJRNE) +
                MSG(+
'Stze knnen nicht hinzugefgt werden, wenn die Ausgabedatei neu erst-
ellt werden soll.'                                                    +
                ) +
                SEV(00) +
     /*   Keine Ersatzvariablen definiert!                          */ +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

     /*-------------------------------------------------------------*/
     /*   Cmd-ADDMSGD fr Message-ID :   USR0007                    */
     /* Journalzuordnung wird ermittelt ...                         */
     /*-------------------------------------------------------------*/

             ADDMSGD +
                MSGID(USR0007) +
                MSGF(&LI/EXPJRNE) +
                MSG(+
'Journalzuordnung wird ermittelt ...'                                 +
                ) +
                SEV(00) +
     /*   Keine Ersatzvariablen definiert!                          */ +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

     /*-------------------------------------------------------------*/
     /*   Cmd-ADDMSGD fr Message-ID :   USR0008                    */
     /* Ausgewhltes Objekt wird nicht journalisiert.               */
     /*-------------------------------------------------------------*/

             ADDMSGD +
                MSGID(USR0008) +
                MSGF(&LI/EXPJRNE) +
                MSG(+
'Ausgewhltes Objekt wird nicht journalisiert.'                       +
                ) +
                SEV(00) +
     /*   Keine Ersatzvariablen definiert!                          */ +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

     /*-------------------------------------------------------------*/
     /*   Cmd-ADDMSGD fr Message-ID :   USR0009                    */
     /* Satzlnge konnte nicht ermittelt werden.                    */
     /*-------------------------------------------------------------*/

             ADDMSGD +
                MSGID(USR0009) +
                MSGF(&LI/EXPJRNE) +
                MSG(+
'Satzlnge konnte nicht ermittelt werden.'                            +
                ) +
                SEV(00) +
     /*   Keine Ersatzvariablen definiert!                          */ +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

     /*-------------------------------------------------------------*/
     /*   Cmd-ADDMSGD fr Message-ID :   USR0010                    */
     /* Ausgabedatei konnte nicht erstellt werden.                  */
     /*-------------------------------------------------------------*/

             ADDMSGD +
                MSGID(USR0010) +
                MSGF(&LI/EXPJRNE) +
                MSG(+
'Ausgabedatei konnte nicht erstellt werden.'                          +
                ) +
                SEV(00) +
     /*   Keine Ersatzvariablen definiert!                          */ +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

     /*-------------------------------------------------------------*/
     /*   Cmd-ADDMSGD fr Message-ID :   USR0011                    */
     /* Export der Journaleintrge luft ...                        */
     /*-------------------------------------------------------------*/

             ADDMSGD +
                MSGID(USR0011) +
                MSGF(&LI/EXPJRNE) +
                MSG(+
'Export der Journaleintrge luft ...'                                +
                ) +
                SEV(00) +
     /*   Keine Ersatzvariablen definiert!                          */ +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

     /*-------------------------------------------------------------*/
     /*   Cmd-ADDMSGD fr Message-ID :   USR0012                    */
     /* Export der Journaleintrge luft (&1) ...                   */
     /*-------------------------------------------------------------*/

             ADDMSGD +
                MSGID(USR0012) +
                MSGF(&LI/EXPJRNE) +
                MSG(+
'Export der Journaleintrge luft (&1) ...'                           +
                ) +
                SEV(00) +
                FMT( +
                    (*DEC 0015 0) +
                ) +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

     /*-------------------------------------------------------------*/
     /*   Cmd-ADDMSGD fr Message-ID :   USR0014                    */
     /* &3 Journaleintrge in Datei &2/&1 gestellt.                 */
     /*-------------------------------------------------------------*/

             ADDMSGD +
                MSGID(USR0014) +
                MSGF(&LI/EXPJRNE) +
                MSG(+
'&3 Journaleintrge in Datei &2/&1 gestellt.'                         +
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
     /*   Cmd-ADDMSGD fr Message-ID :   USR0015                    */
     /* Keine Journalaufzeichnungen fr Datei &2/&1 gefunden.       */
     /*-------------------------------------------------------------*/

             ADDMSGD +
                MSGID(USR0015) +
                MSGF(&LI/EXPJRNE) +
                MSG(+
'Keine Journalaufzeichnungen fr Datei &2/&1 gefunden.'               +
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
     /*   Cmd-ADDMSGD fr Message-ID :   USR0016                    */
     /* Befehl fehlerhaft beendet - Siehe Jobprotokoll.             */
     /*-------------------------------------------------------------*/

             ADDMSGD +
                MSGID(USR0016) +
                MSGF(&LI/EXPJRNE) +
                MSG(+
'Befehl fehlerhaft beendet - Siehe Jobprotokoll.'                     +
                ) +
                SEV(00) +
     /*   Keine Ersatzvariablen definiert!                          */ +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

     /*-------------------------------------------------------------*/
     /*   Cmd-ADDMSGD fr Message-ID :   USR0017                    */
     /* Datentyp von Feld &1 wird nicht untersttzt.                */
     /*-------------------------------------------------------------*/

             ADDMSGD +
                MSGID(USR0017) +
                MSGF(&LI/EXPJRNE) +
                MSG(+
'Datentyp von Feld &1 wird nicht untersttzt.'                        +
                ) +
                SEV(00) +
                FMT( +
                    (*CHAR 0010) +
                ) +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

     /*-------------------------------------------------------------*/
     /*   Cmd-ADDMSGD fr Message-ID :   USR0018                    */
     /* &1 Journaleintrge aufgrund von Fehlern bergangen.         */
     /*-------------------------------------------------------------*/

             ADDMSGD +
                MSGID(USR0018) +
                MSGF(&LI/EXPJRNE) +
                MSG(+
'&1 Journaleintrge aufgrund von Fehlern bergangen.'                 +
                ) +
                SECLVL(+
'&N &N Information . . :   &1 Journaleintrge wurden nicht exportiert,-
 weil die Daten unvollstndig waren oder weil im Journal der Parameter-
 ''MINENTDTA'' gesetzt ist.'                                          +
                ) +
                SEV(00) +
                FMT( +
                    (*CHAR 0010) +
                ) +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

     /*-------------------------------------------------------------*/
     /*   Cmd-ADDMSGD fr Message-ID :   USR0019                    */
     /* Feld oder Datzformat &1 umbenannt nach &2.                  */
     /*-------------------------------------------------------------*/

             ADDMSGD +
                MSGID(USR0019) +
                MSGF(&LI/EXPJRNE) +
                MSG(+
'Feld oder Datzformat &1 umbenannt nach &2.'                          +
                ) +
                SECLVL(+
'&N &N Information . . :   Feld oder Satzformat &1 wurde nach &2 umben-
annt, weil der Name &1 ungltige Zeichen beinhaltet.'                 +
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
     /*   Cmd-ADDMSGD fr Message-ID :   USR0020                    */
     /* Unerlaubter Speicherzugriff. Programm beendet.              */
     /*-------------------------------------------------------------*/

             ADDMSGD +
                MSGID(USR0020) +
                MSGF(&LI/EXPJRNE) +
                MSG(+
'Unerlaubter Speicherzugriff. Programm beendet.'                      +
                ) +
                SECLVL(+
'&N &N Information . . :   Es wurde versucht auf Speicherbereiche auss-
erhalb der zulssigen Grenzen zuzugreifen. Bitte informieren Sie den E-
ntwickler ber diesen Fehler.'                                        +
                ) +
                SEV(00) +
     /*   Keine Ersatzvariablen definiert!                          */ +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

     /*-------------------------------------------------------------*/
     /*   Cmd-ADDMSGD fr Message-ID :   USR0021                    */
     /* Aktualittsprfung fr Datei &1 in Bibliothek &2.           */
     /*-------------------------------------------------------------*/

             ADDMSGD +
                MSGID(USR0021) +
                MSGF(&LI/EXPJRNE) +
                MSG(+
'Aktualittsprfung fr Datei &1 in Bibliothek &2.'                   +
                ) +
                SECLVL(+
'&N &N Information . . :   Die Anzahl Felder sind unterschiedlich.'   +
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
     /*   Cmd-ADDMSGD fr Message-ID :   USR0022                    */
     /* Aktualittsprfung fr Feld &3 in Datei &1 in Bibliothek &2 */
     /*-------------------------------------------------------------*/

             ADDMSGD +
                MSGID(USR0022) +
                MSGF(&LI/EXPJRNE) +
                MSG(+
'Aktualittsprfung fr Feld &3 in Datei &1 in Bibliothek &2.'        +
                ) +
                SECLVL(+
'&N &N Information . . :   Die Attribute von Feld &3 in der Datei &1 i-
n der Bibliothek &2 entsprechen nicht den erwarteten Werten.'         +
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
     /*   Cmd-ADDMSGD fr Message-ID :   USR0023                    */
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
     /*   Cmd-ADDMSGD fr Message-ID :   USR0024                    */
     /* Ausfhrung der SQL Anweisung zum Erstellen der Ausgabedatei */
     /*-------------------------------------------------------------*/

             ADDMSGD +
                MSGID(USR0024) +
                MSGF(&LI/EXPJRNE) +
                MSG(+
'Ausfhrung der SQL Anweisung zum Erstellen der Ausgabedatei fehlgesch-
lagen.'                                                               +
                ) +
                SECLVL(+
'&N &N SQL Anweisung . :   &1'                                        +
                ) +
                SEV(00) +
                FMT( +
                    (*CHAR 0512) +
                ) +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

     /*-------------------------------------------------------------*/
     /*   Cmd-ADDMSGD fr Message-ID :   USR0025                    */
     /* Ausfhrung der SQL Anweisung zum Setzen der Feldbeschreibun */
     /*-------------------------------------------------------------*/

             ADDMSGD +
                MSGID(USR0025) +
                MSGF(&LI/EXPJRNE) +
                MSG(+
'Ausfhrung der SQL Anweisung zum Setzen der Feldbeschreibungen der Au-
sgabedatei fehlgeschlagen.'                                           +
                ) +
                SECLVL(+
'&N &N SQL Anweisung . :   &1'                                        +
                ) +
                SEV(00) +
                FMT( +
                    (*CHAR 0512) +
                ) +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

     /*-------------------------------------------------------------*/
     /*   Cmd-ADDMSGD fr Message-ID :   USR0026                    */
     /* Ausfhrung der ASL Anweisung zum setzen der Spaltenberschr */
     /*-------------------------------------------------------------*/

             ADDMSGD +
                MSGID(USR0026) +
                MSGF(&LI/EXPJRNE) +
                MSG(+
'Ausfhrung der ASL Anweisung zum setzen der Spaltenberschriften der -
Felder der Ausgabedatei fehlgeschlagen.'                              +
                ) +
                SECLVL(+
'&N &N SQL Anweisung . :   &1'                                        +
                ) +
                SEV(00) +
                FMT( +
                    (*CHAR 0512) +
                ) +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

     /*-------------------------------------------------------------*/
     /*   Cmd-ADDMSGD fr Message-ID :   USR0027                    */
     /* Ausfhrung der SQL Anweisung zum Setzen der Textbeschreibun */
     /*-------------------------------------------------------------*/

             ADDMSGD +
                MSGID(USR0027) +
                MSGF(&LI/EXPJRNE) +
                MSG(+
'Ausfhrung der SQL Anweisung zum Setzen der Textbeschreibung der Ausg-
abedatei fehlgeschlagen.'                                             +
                ) +
                SECLVL(+
'&N &N SQL Anweisung . :   &1'                                        +
                ) +
                SEV(00) +
                FMT( +
                    (*CHAR 0512) +
                ) +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

     /*-------------------------------------------------------------*/
     /*   Cmd-ADDMSGD fr Message-ID :   USR0028                    */
     /* Wert fr Parameter OBJTYPE ist ungltig.                    */
     /*-------------------------------------------------------------*/

             ADDMSGD +
                MSGID(USR0028) +
                MSGF(&LI/EXPJRNE) +
                MSG(+
'Wert fr Parameter OBJTYPE ist ungltig.'                            +
                ) +
                SECLVL(+
'&N &N Ursache . . . . :   Der Wert &1 wird von dem aktuellen Release -
des Betriebssystems nicht untersttzt. Der mindestens erforderliche Re-
leasestand ist V5R4M0. Der aktuelle Releasestand ist: &2.'            +
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
     /*   Cmd-ADDMSGD fr Message-ID :   USR0029                    */
     /* Die Ausgabedatei darf nicht identisch mit der Eingabedatei  */
     /*-------------------------------------------------------------*/

             ADDMSGD +
                MSGID(USR0029) +
                MSGF(&LI/EXPJRNE) +
                MSG(+
'Die Ausgabedatei darf nicht identisch mit der Eingabedatei sein.'    +
                ) +
                SECLVL(+
'&N &N Ursache . . . . :   Die Ausgabedatei darf nicht identisch mit d-
er Datei sein, deren Journaleintrge exportiert werden. Bitte whlen s-
ie einen anderen Namen fr die Ausgabedatei und fhren sie die Exporta-
nforderung erneut aus.'                                               +
                ) +
                SEV(00) +
     /*   Keine Ersatzvariablen definiert!                          */ +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

     /*-------------------------------------------------------------*/
     /*   Cmd-ADDMSGD fr Message-ID :   USR0030                    */
     /* Field overflow occurred in field: &1                        */
     /*-------------------------------------------------------------*/

             ADDMSGD +
                MSGID(USR0030) +
                MSGF(&LI/EXPJRNE) +
                MSG(+
'Feldberlauf aufgetreten in Feld: &1'                                +
                ) +
                SECLVL(+
'&N &N Ursache . . . . :   Ein Wert fr Feld &1 hat den maximal mglic-
hen Wert berschritten. Der Fehler ist abgefangen worden und der Wert -
wurde gesetzt auf: wert - maxWert - 1'                                +
                ) +
                SEV(00) +
                FMT( +
                    (*CHAR 0010) +
                ) +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

     /*-------------------------------------------------------------*/
     /*   Cmd-ADDMSGD fr Message-ID :   USR0031                    */
     /* Field overflow occurred in field: &1                        */
     /*-------------------------------------------------------------*/

             ADDMSGD +
                MSGID(USR0031) +
                MSGF(&LI/EXPJRNE) +
                MSG(+
'Ungltiges Zeitstempelfeld: &1.'                                     +
                ) +
                SECLVL(+
'&N &N Ursache . . . . :   Die angegebene Anzahl von Mikrosekunden wir-
d nicht von DDS untersttzt. Anzahl Mikrosekunden: &2. &N Lsung  . . -
. . :   Verwenden Sie SQL zur Erzeugung der Ausgabedatei und setzen Si-
e dafr den Parameter CRTFILE auf *SQL.'                              +
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
     /*   Cmd-ADDMSGD fr Message-ID :   USR0101                    */
     /* Erzeugen temporre Quellendatei ...                         */
     /*-------------------------------------------------------------*/

             ADDMSGD +
                MSGID(USR0101) +
                MSGF(&LI/EXPJRNE) +
                MSG(+
'Erzeugen temporre Quellendatei ...'                                 +
                ) +
                SEV(00) +
     /*   Keine Ersatzvariablen definiert!                          */ +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

     /*-------------------------------------------------------------*/
     /*   Cmd-ADDMSGD fr Message-ID :   USR0102                    */
     /* Abrufen Format der Ausgabedatei ...                         */
     /*-------------------------------------------------------------*/

             ADDMSGD +
                MSGID(USR0102) +
                MSGF(&LI/EXPJRNE) +
                MSG(+
'Abrufen Format der Ausgabedatei ...'                                 +
                ) +
                SEV(00) +
     /*   Keine Ersatzvariablen definiert!                          */ +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

     /*-------------------------------------------------------------*/
     /*   Cmd-ADDMSGD fr Message-ID :   USR0103                    */
     /* Erstellen der Ausgabedatei ...                              */
     /*-------------------------------------------------------------*/

             ADDMSGD +
                MSGID(USR0103) +
                MSGF(&LI/EXPJRNE) +
                MSG(+
'Erstellen der Ausgabedatei ...'                                      +
                ) +
                SEV(00) +
     /*   Keine Ersatzvariablen definiert!                          */ +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

     /*-------------------------------------------------------------*/
     /*   Cmd-ADDMSGD fr Message-ID :   USR0104                    */
     /* Lschen temporrer Arbeitsobjekte ...                       */
     /*-------------------------------------------------------------*/

             ADDMSGD +
                MSGID(USR0104) +
                MSGF(&LI/EXPJRNE) +
                MSG(+
'Lschen temporrer Arbeitsobjekte ...'                               +
                ) +
                SEV(00) +
     /*   Keine Ersatzvariablen definiert!                          */ +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

     /*-------------------------------------------------------------*/
     /*   Cmd-ADDMSGD fr Message-ID :   USR0200                    */
     /* Verbinden mit Datenbankserver ...                           */
     /*-------------------------------------------------------------*/

             ADDMSGD +
                MSGID(USR0200) +
                MSGF(&LI/EXPJRNE) +
                MSG(+
'Verbinden mit Datenbankserver ...'                                   +
                ) +
                SEV(00) +
     /*   Keine Ersatzvariablen definiert!                          */ +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

     /*-------------------------------------------------------------*/
     /*   Cmd-ADDMSGD fr Message-ID :   USR0201                    */
     /* Trennen von Datenbankserver ...                             */
     /*-------------------------------------------------------------*/

             ADDMSGD +
                MSGID(USR0201) +
                MSGF(&LI/EXPJRNE) +
                MSG(+
'Trennen von Datenbankserver ...'                                     +
                ) +
                SEV(00) +
     /*   Keine Ersatzvariablen definiert!                          */ +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

             RCLRSC LVL(*)

             ENDPGM
