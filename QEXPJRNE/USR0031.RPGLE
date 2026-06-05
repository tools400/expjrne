**FREE
// ---------------------------------------------------------------
//  Data structure for message ID: USR0031

//  Ungültiges Zeitstempelfeld: &1.

dcl-ds USR0031;
  USR00311        char(10) inz(*BLANKS);
  USR00312        packed(2) inz(*ZEROS );
end-ds;
dcl-s USR0031_SIZE    int(10) inz(12);
