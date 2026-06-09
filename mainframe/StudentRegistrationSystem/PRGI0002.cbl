      *>****************************************************************
      *> Author: Joby Chacko
      *> Date: 08-06-2026
      *> Purpose: Program that inserts a new student record
      *> Tectonics: cobc
      *>****************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. PRGI0002.

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

       01 WS-END-FILE            PIC X VALUE "N".
          88 END-OF-FILE         VALUE "Y".
          88 NOT-END-OF-FILE     VALUE "N".

       01 WS-HIGHEST-ID          PIC 9(4) VALUE ZERO.
       01 WS-NEW-ID              PIC 9(4) VALUE ZERO.
       01 WS-START-ID            PIC 9(4) VALUE ZERO.

       01 WS-NEW-NAME            PIC X(25).
       01 WS-NEW-BIRTHDAY        PIC 9(8).
       01 WS-NEW-COURSE          PIC X(15).

       01 WS-CURRENT-DATE        PIC 9(8).

       PROCEDURE DIVISION.

       MAIN-PARA.
           DISPLAY " "
           DISPLAY "+-----------------------------------+"
           DISPLAY "|   A D D   N E W   S T U D E N T   |"
           DISPLAY "+-----------------------------------+"
           DISPLAY " "

           ACCEPT WS-CURRENT-DATE FROM DATE YYYYMMDD

           DISPLAY "ENTER FULL NAME (MAX 25 CHARACTERS) >> "
           ACCEPT WS-NEW-NAME

           DISPLAY "ENTER BIRTHDAY (YYYYMMDD) >> "
           ACCEPT WS-NEW-BIRTHDAY

           DISPLAY "ENTER COURSE (MAX 15 CHARACTERS) >> "
           ACCEPT WS-NEW-COURSE

           OPEN I-O STUDENT-FILE

           IF WS-STUDENT-STATUS NOT = "00"
               DISPLAY "ERROR OPENING STUDENTS.dat"
               DISPLAY "FILE STATUS: " WS-STUDENT-STATUS
               STOP RUN
           END-IF

           PERFORM FIND-HIGHEST-ID

           ADD 1 TO WS-HIGHEST-ID GIVING WS-NEW-ID

           MOVE WS-NEW-ID       TO STU-ID
           MOVE WS-NEW-NAME     TO STU-NAME
           MOVE WS-NEW-BIRTHDAY TO STU-BIRTHDAY
           MOVE WS-NEW-COURSE   TO STU-COURSE
           MOVE WS-CURRENT-DATE TO STU-INSERT-DATE
           MOVE ZEROES          TO STU-UPDATE-DATE

           WRITE STUDENT-REC
               INVALID KEY
                   DISPLAY " "
                   DISPLAY "ERROR INSERTING STUDENT."
                   DISPLAY "FILE STATUS: " WS-STUDENT-STATUS
               NOT INVALID KEY
                   DISPLAY " "
                   DISPLAY "NEW STUDENT INSERTED SUCCESSFULLY."
                   DISPLAY "NEW STUDENT ID: " STU-ID
           END-WRITE

           CLOSE STUDENT-FILE

           STOP RUN.

       FIND-HIGHEST-ID.
           MOVE "N" TO WS-END-FILE
           MOVE ZERO TO WS-HIGHEST-ID
           MOVE ZERO TO WS-START-ID
           MOVE WS-START-ID TO STU-ID

           START STUDENT-FILE
               KEY IS GREATER THAN OR EQUAL TO STU-ID
               INVALID KEY
                   SET END-OF-FILE TO TRUE
               NOT INVALID KEY
                   CONTINUE
           END-START

           PERFORM UNTIL END-OF-FILE
               PERFORM READ-NEXT-STUDENT

               IF NOT END-OF-FILE
                   IF STU-ID > WS-HIGHEST-ID
                       MOVE STU-ID TO WS-HIGHEST-ID
                   END-IF
               END-IF
           END-PERFORM.

       READ-NEXT-STUDENT.
           READ STUDENT-FILE NEXT RECORD
               AT END
                   SET END-OF-FILE TO TRUE
               NOT AT END
                   SET NOT-END-OF-FILE TO TRUE
           END-READ.