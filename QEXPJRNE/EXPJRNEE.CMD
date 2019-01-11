/* =================================================================== */
/*                                                                     */
/*  Application . : EXPJRNE                                            */
/*  Object  . . . : EXPJRNE                                            */
/*  Description . : Export Journal Entries - Eng                       */
/*  Author  . . . : Thomas Raddatz   <thomas.raddatz@tools400.de>      */
/*  Date  . . . . : 22.05.2002                                         */
/*                                                                     */
/* =================================================================== */
/*                                                                     */
/*  This software is free software, you can redistribute it and/or     */
/*  modify it under the terms of the GNU General Public License (GPL)  */
/*  as published by the Free Software Foundation.                      */
/*                                                                     */
/*  See GNU General Public License for details.                        */
/*          http://www.opensource.org                                  */
/*          http://www.opensource.org/licenses/gpl-license.html        */
/*                                                                     */
/* =================================================================== */
/*  History:                                                           */
/*                                                                     */
/*  Date        Name          Comment                                  */
/*  ----------  ------------  ---------------------------------------  */
/*  10.11.2005  Th.Raddatz    Added option to select between outfile   */
/*                            types: *TYPE1 / *TYPE2.                  */
/*                                                                     */
/*  15.06.2007  Th.Raddatz    Added parameter RCVRNG.                  */
/*                                                                     */
/*  19.09.2008  Th.Raddatz    Changed name of message file to EXPJRNE. */
/*                            Added parameter prompt override          */
/*                            program.                                 */
/*                                                                     */
/*  20.09.2008  Th.Raddatz    Redesigned EXPJRNE to support additional */
/*                            object types, starting with *DTAARA.     */
/*                                                                     */
/*  08.02.2014  Th.Raddatz    Added parameter JRN.                     */
/*                                                                     */
/*  08.10.2014  Th.Raddatz    Added parameter TPLFILE.                 */
/*                                                                     */
/*  02.01.2015  Th.Raddatz    Added option *OBJ to parameter OUTFILE.  */
/*                                                                     */
/*  24.01.2015  Th.Raddatz    Added option *USER to parameter OUTFILE. */
/*                                                                     */
/*  04.10.2018  Th.Raddatz    Added outfile types *TYPE4 and *TYPE5.   */
/*                                                                     */
/* =================================================================== */
/* >>PRE-COMPILER<<                                                    */
/*   >>CRTCMD<< CRTCMD       CMD(&LI/EXPJRNE) +                        */
/*                           SRCFILE(&SL/&SF) +                        */
/*                           SRCMBR(&SM);                              */
/*   >>IMPORTANT<<                                                     */
/*     >>PARM<< PGM(&LI/EXPJRNEC);                                     */
/*     >>PARM<< PMTOVRPGM(&LI/EXPJRNECP);                              */
/*     >>PARM<< HLPPNLGRP(&LI/EXPJRNEP);                               */
/*     >>PARM<< HLPID(EXPJRNE);                                        */
/*   >>END-IMPORTANT<<                                                 */
/*   >>EXECUTE<<                                                       */
/* >>END-PRE-COMPILER<<                                                */
/* =================================================================== */
           CMD      PROMPT('Export Journal Entries')

             PARM       KWD(OBJ)                         +
                          TYPE(QUAL1)                    +
                          MIN(1)                         +
                          PROMPT('Object' 1)

             PARM       KWD(FROMDATE)                    +
                          TYPE(*DATE)                    +
                          MIN(1)                         +
                          CHOICE(*PGM)                   +
                          CHOICEPGM(*LIBL/EXPJRNECC)     +
                          PROMPT('Starting date' 4)

             PARM       KWD(FROMTIME)                    +
                          TYPE(*TIME)                    +
                          MIN(1)                         +
                          CHOICE('Time (hh:mm:ss)')      +
                          PROMPT('Starting time' 5)

             PARM       KWD(TODATE)                      +
                          TYPE(*DATE)                    +
                          MIN(1)                         +
                          CHOICE(*PGM)                   +
                          CHOICEPGM(*LIBL/EXPJRNECC)     +
                          PROMPT('Ending date' 6)

             PARM       KWD(TOTIME)                      +
                          TYPE(*TIME)                    +
                          MIN(1)                         +
                          CHOICE('Time (hh:mm:ss)')      +
                          PROMPT('Ending time' 7)

             PARM       KWD(OBJTYPE)                     +
                          TYPE(*CHAR)                    +
                          LEN(10)                        +
                          MIN(0)                         +
                          DFT(*FILE)                     +
                          RSTD(*YES)                     +
                          VALUES(*FILE                   +
                                 *DTAARA                 +
                                 *DTAQ   )               +
                          PROMPT('Object type' 2)

             PARM       KWD(MBR)                         +
                          TYPE(*NAME)                    +
                          MIN(0)                         +
                          DFT(*FIRST)                    +
                          SPCVAL((*FIRST)                +
                                 (*ALL  ))               +
                          PROMPT('Member' 3)

             PARM       KWD(OUTFILE)                     +
                          TYPE(QUAL2)                    +
                          MIN(0)                         +
                          CHOICE(*NONE)                  +
                          PROMPT('File to receive output' 9)

             PARM       KWD(OUTMBR)                      +
                          MIN(0)                         +
                          TYPE(ELEM1)                    +
                          PROMPT('Output member options' 10)

             PARM       KWD(CRTFILE)                     +
                          TYPE(*CHAR)                    +
                          LEN(1)                         +
                          MIN(0)                         +
                          DFT(*NO)                       +
                          RSTD(*YES)                     +
                          SPCVAL((*YES 'Y')              +
                                 (*NO  'N')              +
                                 (*SQL 'Y')              +
                                 (*DDS 'D'))             +
                          PROMPT('Create outfile' 11)

             PARM       KWD(TPLFILE)                     +
                          TYPE(QUAL4)                    +
                          MIN(0)                         +
                          DFT(*OBJECT)                   +
                          SNGVAL(*OBJECT)                +
                          PROMPT('Template file' 12)

             PARM       KWD(OUTFILFMT)                   +
                          TYPE(*CHAR)                    +
                          LEN(10)                        +
                          MIN(0)                         +
                          DFT(*TYPE1)                    +
                          RSTD(*YES)                     +
                          VALUES(*TYPE1                  +
                                 *TYPE2                  +
                                 *TYPE3                  +
                                 *TYPE4                  +
                                 *TYPE5)                 +
                          PROMPT('Outfile format'  8)

             PARM       KWD(JRN)                         +
                          TYPE(JRN)                      +
                          DFT(*OBJ)                      +
                          SNGVAL(*OBJ)                   +
                          PROMPT('Journal' 15)

             PARM       KWD(RCVRNG)                      +
                          TYPE(RCVRNG)                   +
                          DFT(*CURCHAIN)                 +
                          SNGVAL((*CURCHAIN)             +
                                 (*CURRENT ))            +
                          PROMPT('Range of journal receivers' 16)

             PARM       KWD(SIZE)                        +
                          TYPE(SIZE)                     +
                          SNGVAL((*NOMAX 0))             +
                          PROMPT('Member size' 13)

             PARM       KWD(LVLCHK)                      +
                          TYPE(*CHAR)                    +
                          LEN(1)                         +
                          MIN(0)                         +
                          DFT(*NO)                       +
                          RSTD(*YES)                     +
                          SPCVAL((*YES 'Y')              +
                                 (*NO  'N'))             +
                          PROMPT('Record format level check' 14)

/* ----------------------------------------------------------------- */

 QUAL1:      QUAL       TYPE(*NAME)                      +
                          LEN(10)                        +
                          MIN(1)
             QUAL       TYPE(*NAME)                      +
                          LEN(10)                        +
                          DFT(*LIBL)                     +
                          SPCVAL((*LIBL  )               +
                                 (*CURLIB))             +
                          PROMPT('Library')

QUAL2:       QUAL       TYPE(*NAME)                      +
                          LEN(10)                        +
                          MIN(0)                         +
                          DFT(*DFT)                      +
                          SPCVAL((*DFT)                  +
                                 (*OBJ))
             QUAL       TYPE(*NAME)                      +
                          LEN(10)                        +
                          MIN(0)                         +
                          DFT(*LIBL)                     +
                          SPCVAL((*LIBL  )               +
                                 (*CURLIB)               +
                                 (*USER  ))              +
                          PROMPT('Library')

QUAL3:       QUAL       TYPE(*NAME)                      +
                          LEN(10)                        +
                          MIN(0)
             QUAL       TYPE(*NAME)                      +
                          LEN(10)                        +
                          MIN(0)                         +
                          DFT(*LIBL)                     +
                          SPCVAL((*LIBL  )               +
                                 (*CURLIB))              +
                          PROMPT('Library')

QUAL4:       QUAL       TYPE(*NAME)                      +
                          LEN(10)                        +
                          MIN(0)
             QUAL       TYPE(*NAME)                      +
                          LEN(10)                        +
                          MIN(0)                         +
                          DFT(*LIBL)                     +
                          SPCVAL((*LIBL  )               +
                                 (*CURLIB))              +
                          PROMPT('Library')

JRN:         QUAL       TYPE(*NAME)                      +
                          LEN(10)                        +
                          MIN(0)
             QUAL       TYPE(*NAME)                      +
                          LEN(10)                        +
                          MIN(0)                         +
                          DFT(*LIBL)                     +
                          SPCVAL((*LIBL  )               +
                                 (*CURLIB))              +
                          PROMPT('Library')

 ELEM1:      ELEM       TYPE(*CHAR)                      +
                          LEN(10)                        +
                          RSTD(*YES)                     +
                          VALUES((*REPLACE)              +
                                 (*ADD    ))             +
                          DFT(*REPLACE)                  +
                          PROMPT('Replace or add records')

 RCVRNG:     ELEM       TYPE(QUAL3)                      +
                          MIN(0)                         +
                          PROMPT('Starting journal receiver')
             ELEM       TYPE(QUAL3)                      +
                          MIN(0)                         +
                          SNGVAL((*CURRENT))             +
                          PROMPT('Ending journal receiver')

 SIZE:       ELEM       TYPE(*INT4)                      +
                          DFT(*SAME)                     +
                          RANGE(1 2147483646)            +
                          SPCVAL((*SAME  -2))            +
                          PROMPT('Initial number of records')
             ELEM       TYPE(*INT2)                      +
                          DFT(*SAME)                     +
                          RANGE(0 32767)                 +
                          SPCVAL((*SAME  -2))            +
                          PROMPT('Increment number of records')
             ELEM       TYPE(*INT2)                      +
                          DFT(*SAME)                     +
                          RANGE(0 32767)                 +
                          SPCVAL((*SAME  -2))            +
                          PROMPT('Maximum increments')

