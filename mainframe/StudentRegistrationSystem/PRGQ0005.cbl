      *>****************************************************************
      *> Author: Joby Chacko
      *> Date: 08-06-2026
      *> Purpose: Program that queries all student records
      *> Tectonics: cobc
      *>****************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. PRGQ0005.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.

           SELECT STUDENT-FILE ASSIGN TO "STUDENTS.dat"
               ORGANIZATION IS INDEXED
               ACCESS MODE IS SEQUENTIAL
               RECORD KEY IS STU-ID
               FILE STATUS IS WS-STUDENT-STATUS.

       DATA DIVISION.
       FILE SECTION.

       FD STUDENT-FILE.
       COPY "STUDENT.cpy".

       WORKING-STORAGE SECTION.

       01 WS-STUDENT-STATUS      PIC XX.

       01 WS-END-FILE            PIC X VALUE "N".
          88 END-OF-FILE         VALUE "Y".
          88 NOT-END-OF-FILE     VALUE "N".

       01 WS-TOTAL-STUDENTS      PIC 9(4) VALUE ZERO.

       PROCEDURE DIVISION.

       MAIN-PARA.
           DISPLAY " "
           DISPLAY "------------------------------------------------------------"
           DISPLAY "              C L A S S   R E P O R T"
           DISPLAY "------------------------------------------------------------"
           DISPLAY "ID    STUDENT NAME              BIRTHDAY   COURSE"
           DISPLAY "      INSERT DATE   UPDATE DATE"
           DISPLAY "------------------------------------------------------------"

           OPEN INPUT STUDENT-FILE

           IF WS-STUDENT-STATUS NOT = "00"
               DISPLAY "ERROR OPENING STUDENTS.dat"
               DISPLAY "FILE STATUS: " WS-STUDENT-STATUS
               STOP RUN
           END-IF

           PERFORM READ-STUDENT-FILE

           PERFORM UNTIL END-OF-FILE
               PERFORM DISPLAY-STUDENT-RECORD
               ADD 1 TO WS-TOTAL-STUDENTS
               PERFORM READ-STUDENT-FILE
           END-PERFORM

           DISPLAY "------------------------------------------------------------"
           DISPLAY "TOTAL STUDENTS: " WS-TOTAL-STUDENTS
           DISPLAY "------------------------------------------------------------"

           CLOSE STUDENT-FILE

           STOP RUN.

       READ-STUDENT-FILE.
           READ STUDENT-FILE NEXT RECORD
               AT END
                   SET END-OF-FILE TO TRUE
               NOT AT END
                   SET NOT-END-OF-FILE TO TRUE
           END-READ.

       DISPLAY-STUDENT-RECORD.
           DISPLAY STU-ID "  "
                   STU-NAME "  "
                   STU-BIRTHDAY "  "
                   STU-COURSE

           DISPLAY "      "
                   STU-INSERT-DATE "      "
                   STU-UPDATE-DATE.