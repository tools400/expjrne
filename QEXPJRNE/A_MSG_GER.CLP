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
     /*   Cmd-ADDMSGD für Message-ID :   TXT0001                    */
     /* EXPJRNE - Exportierte Journaleinträge                       */
     /*-------------------------------------------------------------*/

             ADDMSGD +
                MSGID(TXT0001) +
                MSGF(&LI/EXPJRNE) +
                MSG(+
'EXPJRNE - Exportierte Journaleinträge'                               +
                ) +
                SEV(00) +
     /*   Keine Ersatzvariablen definiert!                          */ +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

     /*-------------------------------------------------------------*/
     /*   Cmd-ADDMSGD für Message-ID :   USR0001                    */
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
     /*   Cmd-ADDMSGD für Message-ID :   USR0002                    */
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
     /*   Cmd-ADDMSGD für Message-ID :   USR0003                    */
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
     /*   Cmd-ADDMSGD für Message-ID :   USR0004                    */
     /* Löschen temporärer Arbeitsobjekte ...                       */
     /*-------------------------------------------------------------*/

             ADDMSGD +
                MSGID(USR0004) +
                MSGF(&LI/EXPJRNE) +
                MSG(+
'Löschen temporärer Arbeitsobjekte ...'                               +
                ) +
                SEV(00) +
     /*   Keine Ersatzvariablen definiert!                          */ +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

     /*-------------------------------------------------------------*/
     /*   Cmd-ADDMSGD für Message-ID :   USR0005                    */
     /* Standardname für Ausgabedatei kann nicht generiert werden.  */
     /*-------------------------------------------------------------*/

             ADDMSGD +
                MSGID(USR0005) +
                MSGF(&LI/EXPJRNE) +
                MSG(+
'Standardname für Ausgabedatei kann nicht generiert werden. Name der D-
atei zu lang.'                                                        +
                ) +
                SEV(00) +
     /*   Keine Ersatzvariablen definiert!                          */ +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

     /*-------------------------------------------------------------*/
     /*   Cmd-ADDMSGD für Message-ID :   USR0006                    */
     /* Sätze können nicht hinzugefügt werden, wenn die Ausgabedate */
     /*-------------------------------------------------------------*/

             ADDMSGD +
                MSGID(USR0006) +
                MSGF(&LI/EXPJRNE) +
                MSG(+
'Sätze können nicht hinzugefügt werden, wenn die Ausgabedatei neu erst-
ellt werden soll.'                                                    +
                ) +
                SEV(00) +
     /*   Keine Ersatzvariablen definiert!                          */ +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

     /*-------------------------------------------------------------*/
     /*   Cmd-ADDMSGD für Message-ID :   USR0007                    */
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
     /*   Cmd-ADDMSGD für Message-ID :   USR0008                    */
     /* Ausgewähltes Objekt wird nicht journalisiert.               */
     /*-------------------------------------------------------------*/

             ADDMSGD +
                MSGID(USR0008) +
                MSGF(&LI/EXPJRNE) +
                MSG(+
'Ausgewähltes Objekt wird nicht journalisiert.'                       +
                ) +
                SEV(00) +
     /*   Keine Ersatzvariablen definiert!                          */ +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

     /*-------------------------------------------------------------*/
     /*   Cmd-ADDMSGD für Message-ID :   USR0009                    */
     /* Satzlänge konnte nicht ermittelt werden.                    */
     /*-------------------------------------------------------------*/

             ADDMSGD +
                MSGID(USR0009) +
                MSGF(&LI/EXPJRNE) +
                MSG(+
'Satzlänge konnte nicht ermittelt werden.'                            +
                ) +
                SEV(00) +
     /*   Keine Ersatzvariablen definiert!                          */ +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

     /*-------------------------------------------------------------*/
     /*   Cmd-ADDMSGD für Message-ID :   USR0010                    */
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
     /*   Cmd-ADDMSGD für Message-ID :   USR0011                    */
     /* Export der Journaleinträge läuft ...                        */
     /*-------------------------------------------------------------*/

             ADDMSGD +
                MSGID(USR0011) +
                MSGF(&LI/EXPJRNE) +
                MSG(+
'Export der Journaleinträge läuft ...'                                +
                ) +
                SEV(00) +
     /*   Keine Ersatzvariablen definiert!                          */ +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

     /*-------------------------------------------------------------*/
     /*   Cmd-ADDMSGD für Message-ID :   USR0012                    */
     /* Export der Journaleinträge läuft (&1) ...                   */
     /*-------------------------------------------------------------*/

             ADDMSGD +
                MSGID(USR0012) +
                MSGF(&LI/EXPJRNE) +
                MSG(+
'Export der Journaleinträge läuft (&1) ...'                           +
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
     /* &3 Journaleinträge in Datei &2/&1 gestellt.                 */
     /*-------------------------------------------------------------*/

             ADDMSGD +
                MSGID(USR0014) +
                MSGF(&LI/EXPJRNE) +
                MSG(+
'&3 Journaleinträge in Datei &2/&1 gestellt.'                         +
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
     /* Keine Journalaufzeichnungen für Datei &2/&1 gefunden.       */
     /*-------------------------------------------------------------*/

             ADDMSGD +
                MSGID(USR0015) +
                MSGF(&LI/EXPJRNE) +
                MSG(+
'Keine Journalaufzeichnungen für Datei &2/&1 gefunden.'               +
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
     /*   Cmd-ADDMSGD für Message-ID :   USR0017                    */
     /* Datentyp von Feld &1 wird nicht unterstützt.                */
     /*-------------------------------------------------------------*/

             ADDMSGD +
                MSGID(USR0017) +
                MSGF(&LI/EXPJRNE) +
                MSG(+
'Datentyp von Feld &1 wird nicht unterstützt.'                        +
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
     /* &1 Journaleinträge aufgrund von Fehlern übergangen.         */
     /*-------------------------------------------------------------*/

             ADDMSGD +
                MSGID(USR0018) +
                MSGF(&LI/EXPJRNE) +
                MSG(+
'&1 Journaleinträge aufgrund von Fehlern übergangen.'                 +
                ) +
                SECLVL(+
'&N &N Information . . :   &1 Journaleinträge wurden nicht exportiert,-
 weil die Daten unvollständig waren oder weil im Journal der Parameter-
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
     /*   Cmd-ADDMSGD für Message-ID :   USR0019                    */
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
annt, weil der Name &1 ungültige Zeichen beinhaltet.'                 +
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
erhalb der zulässigen Grenzen zuzugreifen. Bitte informieren Sie den E-
ntwickler über diesen Fehler.'                                        +
                ) +
                SEV(00) +
     /*   Keine Ersatzvariablen definiert!                          */ +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

     /*-------------------------------------------------------------*/
     /*   Cmd-ADDMSGD für Message-ID :   USR0021                    */
     /* Aktualitätsprüfung für Datei &1 in Bibliothek &2.           */
     /*-------------------------------------------------------------*/

             ADDMSGD +
                MSGID(USR0021) +
                MSGF(&LI/EXPJRNE) +
                MSG(+
'Aktualitätsprüfung für Datei &1 in Bibliothek &2.'                   +
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
     /*   Cmd-ADDMSGD für Message-ID :   USR0022                    */
     /* Aktualitätsprüfung für Feld &3 in Datei &1 in Bibliothek &2 */
     /*-------------------------------------------------------------*/

             ADDMSGD +
                MSGID(USR0022) +
                MSGF(&LI/EXPJRNE) +
                MSG(+
'Aktualitätsprüfung für Feld &3 in Datei &1 in Bibliothek &2.'        +
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
     /* Ausführung der SQL Anweisung zum Erstellen der Ausgabedatei */
     /*-------------------------------------------------------------*/

             ADDMSGD +
                MSGID(USR0024) +
                MSGF(&LI/EXPJRNE) +
                MSG(+
'Ausführung der SQL Anweisung zum Erstellen der Ausgabedatei fehlgesch-
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
     /*   Cmd-ADDMSGD für Message-ID :   USR0025                    */
     /* Ausführung der SQL Anweisung zum Setzen der Feldbeschreibun */
     /*-------------------------------------------------------------*/

             ADDMSGD +
                MSGID(USR0025) +
                MSGF(&LI/EXPJRNE) +
                MSG(+
'Ausführung der SQL Anweisung zum Setzen der Feldbeschreibungen der Au-
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
     /*   Cmd-ADDMSGD für Message-ID :   USR0026                    */
     /* Ausführung der ASL Anweisung zum setzen der Spaltenüberschr */
     /*-------------------------------------------------------------*/

             ADDMSGD +
                MSGID(USR0026) +
                MSGF(&LI/EXPJRNE) +
                MSG(+
'Ausführung der ASL Anweisung zum setzen der Spaltenüberschriften der -
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
     /*   Cmd-ADDMSGD für Message-ID :   USR0027                    */
     /* Ausführung der SQL Anweisung zum Setzen der Textbeschreibun */
     /*-------------------------------------------------------------*/

             ADDMSGD +
                MSGID(USR0027) +
                MSGF(&LI/EXPJRNE) +
                MSG(+
'Ausführung der SQL Anweisung zum Setzen der Textbeschreibung der Ausg-
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
     /*   Cmd-ADDMSGD für Message-ID :   USR0028                    */
     /* Wert für Parameter OBJTYPE ist ungültig.                    */
     /*-------------------------------------------------------------*/

             ADDMSGD +
                MSGID(USR0028) +
                MSGF(&LI/EXPJRNE) +
                MSG(+
'Wert für Parameter OBJTYPE ist ungültig.'                            +
                ) +
                SECLVL(+
'&N &N Ursache . . . . :   Der Wert &1 wird von dem aktuellen Release -
des Betriebssystems nicht unterstützt. Der mindestens erforderliche Re-
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
     /*   Cmd-ADDMSGD für Message-ID :   USR0029                    */
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
er Datei sein, deren Journaleinträge exportiert werden. Bitte wählen s-
ie einen anderen Namen für die Ausgabedatei und führen sie die Exporta-
nforderung erneut aus.'                                               +
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
'Feldüberlauf aufgetreten in Feld: &1'                                +
                ) +
                SECLVL(+
'&N &N Ursache . . . . :   Ein Wert für Feld &1 hat den maximal möglic-
hen Wert überschritten. Der Fehler ist abgefangen worden und der Wert -
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
     /*   Cmd-ADDMSGD für Message-ID :   USR0031                    */
     /* Field overflow occurred in field: &1                        */
     /*-------------------------------------------------------------*/

             ADDMSGD +
                MSGID(USR0031) +
                MSGF(&LI/EXPJRNE) +
                MSG(+
'Ungültiges Zeitstempelfeld: &1.'                                     +
                ) +
                SECLVL(+
'&N &N Ursache . . . . :   Die angegebene Anzahl von Mikrosekunden wir-
d nicht von DDS unterstützt. Anzahl Mikrosekunden: &2. &N Lösung  . . -
. . :   Verwenden Sie SQL zur Erzeugung der Ausgabedatei und setzen Si-
e dafür den Parameter CRTFILE auf *SQL.'                              +
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
     /* Erzeugen temporäre Quellendatei ...                         */
     /*-------------------------------------------------------------*/

             ADDMSGD +
                MSGID(USR0101) +
                MSGF(&LI/EXPJRNE) +
                MSG(+
'Erzeugen temporäre Quellendatei ...'                                 +
                ) +
                SEV(00) +
     /*   Keine Ersatzvariablen definiert!                          */ +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

     /*-------------------------------------------------------------*/
     /*   Cmd-ADDMSGD für Message-ID :   USR0102                    */
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
     /*   Cmd-ADDMSGD für Message-ID :   USR0103                    */
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
     /*   Cmd-ADDMSGD für Message-ID :   USR0104                    */
     /* Löschen temporärer Arbeitsobjekte ...                       */
     /*-------------------------------------------------------------*/

             ADDMSGD +
                MSGID(USR0104) +
                MSGF(&LI/EXPJRNE) +
                MSG(+
'Löschen temporärer Arbeitsobjekte ...'                               +
                ) +
                SEV(00) +
     /*   Keine Ersatzvariablen definiert!                          */ +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

     /*-------------------------------------------------------------*/
     /*   Cmd-ADDMSGD für Message-ID :   USR0200                    */
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
     /*   Cmd-ADDMSGD für Message-ID :   USR0201                    */
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
