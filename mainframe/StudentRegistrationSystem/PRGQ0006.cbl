      *>****************************************************************
      *> Author: Joby Chacko
      *> Date: 08-06-2026
      *> Purpose: Program that queries a student record by ID
      *> Tectonics: cobc
      *>****************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. PRGQ0006.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.

           SELECT STUDENT-FILE ASSIGN TO "STUDENTS.dat"
               ORGANIZATION IS INDEXED
               ACCESS MODE IS DYNAMIC
               RECORD KEY IS STU-ID
               FILE STATUS IS WS-STUDENT-STATUS.

       DATA DIVISION.
       FILE SECTION.

       FD STUDENT-FILE.
       COPY "STUDENT.cpy".

       WORKING-STORAGE SECTION.

       01 WS-STUDENT-STATUS      PIC XX.
       01 WS-ENTERED-ID          PIC 9(4).

       PROCEDURE DIVISION.

       MAIN-PARA.
           DISPLAY " "
           DISPLAY "+-------------------------------------------+"
           DISPLAY "|   Q U E R Y   S T U D E N T   B Y   I D   |"
           DISPLAY "+-------------------------------------------+"
           DISPLAY " "

           DISPLAY "ENTER STUDENT ID (4 DIGITS) >> "
           ACCEPT WS-ENTERED-ID

           MOVE WS-ENTERED-ID TO STU-ID

           OPEN INPUT STUDENT-FILE

           IF WS-STUDENT-STATUS NOT = "00"
               DISPLAY "ERROR OPENING STUDENTS.dat"
               DISPLAY "FILE STATUS: " WS-STUDENT-STATUS
               STOP RUN
           END-IF

           READ STUDENT-FILE
               KEY IS STU-ID
               INVALID KEY
                   DISPLAY " "
                   DISPLAY "STUDENT NOT FOUND."
                   DISPLAY "FILE STATUS: " WS-STUDENT-STATUS
               NOT INVALID KEY
                   PERFORM DISPLAY-STUDENT-RECORD
           END-READ

           CLOSE STUDENT-FILE

           STOP RUN.

       DISPLAY-STUDENT-RECORD.
           DISPLAY " "
           DISPLAY "------------------------------------------------------------"
           DISPLAY "ID    STUDENT NAME              BIRTHDAY   COURSE"
           DISPLAY "      INSERT DATE   UPDATE DATE"
           DISPLAY "------------------------------------------------------------"

           DISPLAY STU-ID "  "
                   STU-NAME "  "
                   STU-BIRTHDAY "  "
                   STU-COURSE

           DISPLAY "      "
                   STU-INSERT-DATE "      "
                   STU-UPDATE-DATE

           DISPLAY "------------------------------------------------------------".
