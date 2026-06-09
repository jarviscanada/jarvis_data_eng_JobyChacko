      *>****************************************************************
      *> Author: Joby Chacko
      *> Date: 08-06-2026
      *> Purpose: Program that deletes a student record
      *> Tectonics: cobc
      *>****************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. PRGD0004.

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
       01 WS-CONFIRM             PIC X.

       PROCEDURE DIVISION.

       MAIN-PARA.
           DISPLAY " "
           DISPLAY "+---------------------------------------+"
           DISPLAY "|   D E L E T E   S T U D E N T         |"
           DISPLAY "+---------------------------------------+"
           DISPLAY " "

           DISPLAY "ENTER STUDENT ID (4 DIGITS) >> "
           ACCEPT WS-ENTERED-ID

           MOVE WS-ENTERED-ID TO STU-ID

           OPEN I-O STUDENT-FILE

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
                   CLOSE STUDENT-FILE
                   STOP RUN
               NOT INVALID KEY
                   DISPLAY " "
                   DISPLAY "<--- STUDENT TO BE DELETED --->"
                   PERFORM DISPLAY-STUDENT-RECORD
           END-READ

           DISPLAY " "
           DISPLAY "ARE YOU SURE YOU WANT TO DELETE THIS STUDENT?"
           DISPLAY "ENTER Y TO DELETE OR N TO CANCEL >> "
           ACCEPT WS-CONFIRM

           IF WS-CONFIRM = "Y" OR WS-CONFIRM = "y"
               DELETE STUDENT-FILE
                   INVALID KEY
                       DISPLAY " "
                       DISPLAY "ERROR DELETING STUDENT."
                       DISPLAY "FILE STATUS: " WS-STUDENT-STATUS
                   NOT INVALID KEY
                       DISPLAY " "
                       DISPLAY "STUDENT DELETED SUCCESSFULLY."
               END-DELETE
           ELSE
               DISPLAY " "
               DISPLAY "DELETE CANCELLED."
           END-IF

           CLOSE STUDENT-FILE

           STOP RUN.

       DISPLAY-STUDENT-RECORD.
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