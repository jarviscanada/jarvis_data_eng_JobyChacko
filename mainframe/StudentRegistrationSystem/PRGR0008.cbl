      *>****************************************************************
      *> Author: Joby Chacko
      *> Date: 08-06-2026
      *> Purpose: Program that generates a course-wise student report
      *> Tectonics: cobc
      *>****************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. PRGR0008.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.

           SELECT STUDENT-FILE ASSIGN TO "STUDENTS.dat"
               ORGANIZATION IS INDEXED
               ACCESS MODE IS SEQUENTIAL
               RECORD KEY IS STU-ID
               FILE STATUS IS WS-STUDENT-STATUS.

           SELECT SORT-FILE ASSIGN TO "SORTWORK.tmp".

           SELECT REPORT-FILE ASSIGN TO "COURSE_REPORT.txt"
               ORGANIZATION IS LINE SEQUENTIAL
               FILE STATUS IS WS-REPORT-STATUS.

       DATA DIVISION.
       FILE SECTION.

       FD STUDENT-FILE.
       COPY "STUDENT.cpy".

       SD SORT-FILE.
       01 SORT-REC.
          05 SORT-ID              PIC 9(4).
          05 SORT-NAME            PIC X(25).
          05 SORT-BIRTHDAY        PIC 9(8).
          05 SORT-COURSE          PIC X(15).
          05 SORT-INSERT-DATE     PIC 9(8).
          05 SORT-UPDATE-DATE     PIC 9(8).

       FD REPORT-FILE.
       01 REPORT-LINE             PIC X(120).

       WORKING-STORAGE SECTION.

       01 WS-STUDENT-STATUS       PIC XX.
       01 WS-REPORT-STATUS        PIC XX.

       01 WS-END-FILE             PIC X VALUE "N".
          88 END-OF-FILE          VALUE "Y".
          88 NOT-END-OF-FILE      VALUE "N".

       01 WS-END-SORT             PIC X VALUE "N".
          88 END-OF-SORT          VALUE "Y".
          88 NOT-END-OF-SORT      VALUE "N".

       01 WS-CURRENT-COURSE       PIC X(15) VALUE SPACES.
       01 WS-TOTAL-STUDENTS       PIC 9(4) VALUE ZERO.

       PROCEDURE DIVISION.

       MAIN-PARA.
           DISPLAY " "
           DISPLAY "-------------------------------------------"
           DISPLAY "PRGR0008 - COURSE-WISE STUDENT REPORT"
           DISPLAY "-------------------------------------------"
           DISPLAY "GENERATING COURSE_REPORT.txt..."

           SORT SORT-FILE
               ON ASCENDING KEY SORT-COURSE
               ON ASCENDING KEY SORT-ID
               INPUT PROCEDURE IS LOAD-SORT-FILE
               OUTPUT PROCEDURE IS CREATE-REPORT

           DISPLAY " "
           DISPLAY "REPORT CREATED SUCCESSFULLY."
           DISPLAY "FILE NAME: COURSE_REPORT.txt"
           DISPLAY "TOTAL STUDENTS: " WS-TOTAL-STUDENTS

           STOP RUN.

       LOAD-SORT-FILE.
           OPEN INPUT STUDENT-FILE

           IF WS-STUDENT-STATUS NOT = "00"
               DISPLAY "ERROR OPENING STUDENTS.dat"
               DISPLAY "FILE STATUS: " WS-STUDENT-STATUS
               STOP RUN
           END-IF

           MOVE "N" TO WS-END-FILE

           PERFORM READ-STUDENT-FILE

           PERFORM UNTIL END-OF-FILE
               MOVE STU-ID          TO SORT-ID
               MOVE STU-NAME        TO SORT-NAME
               MOVE STU-BIRTHDAY    TO SORT-BIRTHDAY
               MOVE STU-COURSE      TO SORT-COURSE
               MOVE STU-INSERT-DATE TO SORT-INSERT-DATE
               MOVE STU-UPDATE-DATE TO SORT-UPDATE-DATE

               RELEASE SORT-REC

               PERFORM READ-STUDENT-FILE
           END-PERFORM

           CLOSE STUDENT-FILE.

       CREATE-REPORT.
           OPEN OUTPUT REPORT-FILE

           IF WS-REPORT-STATUS NOT = "00"
               DISPLAY "ERROR CREATING COURSE_REPORT.txt"
               DISPLAY "FILE STATUS: " WS-REPORT-STATUS
               STOP RUN
           END-IF

           MOVE ZERO TO WS-TOTAL-STUDENTS
           MOVE SPACES TO WS-CURRENT-COURSE
           MOVE "N" TO WS-END-SORT

           MOVE "============================================================"
               TO REPORT-LINE
           WRITE REPORT-LINE

           MOVE "                 STUDENT COURSE REPORT"
               TO REPORT-LINE
           WRITE REPORT-LINE

           MOVE "============================================================"
               TO REPORT-LINE
           WRITE REPORT-LINE

           RETURN SORT-FILE
               AT END
                   SET END-OF-SORT TO TRUE
               NOT AT END
                   SET NOT-END-OF-SORT TO TRUE
           END-RETURN

           PERFORM UNTIL END-OF-SORT
               IF SORT-COURSE NOT = WS-CURRENT-COURSE
                   MOVE SORT-COURSE TO WS-CURRENT-COURSE
                   PERFORM WRITE-COURSE-HEADER
               END-IF

               PERFORM WRITE-STUDENT-LINE
               ADD 1 TO WS-TOTAL-STUDENTS

               RETURN SORT-FILE
                   AT END
                       SET END-OF-SORT TO TRUE
                   NOT AT END
                       SET NOT-END-OF-SORT TO TRUE
               END-RETURN
           END-PERFORM

           MOVE SPACES TO REPORT-LINE
           WRITE REPORT-LINE

           MOVE "============================================================"
               TO REPORT-LINE
           WRITE REPORT-LINE

           MOVE SPACES TO REPORT-LINE
           STRING
               "TOTAL STUDENTS: "
               WS-TOTAL-STUDENTS
               DELIMITED BY SIZE
               INTO REPORT-LINE
           END-STRING
           WRITE REPORT-LINE

           MOVE "============================================================"
               TO REPORT-LINE
           WRITE REPORT-LINE

           CLOSE REPORT-FILE.

       READ-STUDENT-FILE.
           READ STUDENT-FILE NEXT RECORD
               AT END
                   SET END-OF-FILE TO TRUE
               NOT AT END
                   SET NOT-END-OF-FILE TO TRUE
           END-READ.

       WRITE-COURSE-HEADER.
           MOVE SPACES TO REPORT-LINE
           WRITE REPORT-LINE

           MOVE SPACES TO REPORT-LINE
           STRING
               "COURSE: "
               WS-CURRENT-COURSE
               DELIMITED BY SIZE
               INTO REPORT-LINE
           END-STRING
           WRITE REPORT-LINE

           MOVE "------------------------------------------------------------"
               TO REPORT-LINE
           WRITE REPORT-LINE

           MOVE "ID    STUDENT NAME              BIRTHDAY   INSERT     UPDATE"
               TO REPORT-LINE
           WRITE REPORT-LINE

           MOVE "------------------------------------------------------------"
               TO REPORT-LINE
           WRITE REPORT-LINE.

       WRITE-STUDENT-LINE.
           MOVE SPACES TO REPORT-LINE

           STRING
               SORT-ID
               "  "
               SORT-NAME
               "  "
               SORT-BIRTHDAY
               "  "
               SORT-INSERT-DATE
               "  "
               SORT-UPDATE-DATE
               DELIMITED BY SIZE
               INTO REPORT-LINE
           END-STRING

           WRITE REPORT-LINE.