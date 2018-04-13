-- ======================================================================== */
--      >>PRE-COMPILER<<                                                    */
--        >>CRTCMD<< RUNSQLSTM    SRCFILE(&SL/&SF) +                        */
--                                SRCMBR(&SM);                              */
--        >>IMPORTANT<<                                                     */
--          >>PARM<< COMMIT(*NONE);                                         */
--          >>PARM<< NAMING(*SQL);                                          */
--          >>PARM<< DATFMT(*ISO);                                          */
--          >>PARM<< TIMFMT(*ISO);                                          */
--          >>PARM<< DFTRDBCOL("&LI");                                      */
--          >>PARM<< PROCESS(*RUN);                                         */
--        >>END-IMPORTANT<<                                                 */
--        >>EXECUTE<<                                                       */
--      >>END-PRE-COMPILER<<                                                */
-- =========================================================================*/

    CREATE TABLE "EXPJRNE.SQ" (
       SCHAR             CHARACTER  ( 10) NOT NULL WITH DEFAULT,
       VCHAR             VARCHAR    ( 10) NOT NULL WITH DEFAULT,
       SGRAPHIC          GRAPHIC    ( 10) NOT NULL WITH DEFAULT,
       VGRAPHIC          VARGRAPHIC ( 10) NOT NULL WITH DEFAULT,
       SMALLINT          SMALLINT         NOT NULL WITH DEFAULT,
       INTEGER           INT              NOT NULL WITH DEFAULT,
       BIGINT            BIGINT           NOT NULL WITH DEFAULT,
       DECIMAL           DEC      ( 7, 2) NOT NULL WITH DEFAULT,
       NUMERIC           NUMERIC  ( 7, 2) NOT NULL WITH DEFAULT,
       SDOUBLE           DOUBLE           NOT NULL WITH DEFAULT,
       FLOAT             FLOAT            NOT NULL WITH DEFAULT,
       REAL              REAL             NOT NULL WITH DEFAULT,
       SDATE             DATE             NOT NULL WITH DEFAULT,
       STIME             TIME             NOT NULL WITH DEFAULT,
       STIMESTAMP        TIMESTAMP        NOT NULL WITH DEFAULT);
