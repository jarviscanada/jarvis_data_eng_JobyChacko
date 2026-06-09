      *>****************************************************************
      *> Author: Joby Chacko
      *> Date: 08-06-2026
      *> Purpose: Program that displays the main menu and runs the
      *>          selected student registration program
      *> Tectonics: cobc
      *>****************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. PRGMENU.

       DATA DIVISION.
       WORKING-STORAGE SECTION.

       01 WS-OPTION              PIC 9 VALUE ZERO.
       01 WS-CONTINUE            PIC X VALUE SPACE.
       01 WS-SYSTEM-COMMAND      PIC X(50) VALUE SPACES.
       01 WS-SYSTEM-RESULT       PIC S9(9) COMP-5 VALUE ZERO.

       PROCEDURE DIVISION.

       MAIN-PARA.
           PERFORM UNTIL WS-OPTION = 9
               PERFORM DISPLAY-MENU

               DISPLAY "ENTER YOUR OPTION >> "
               ACCEPT WS-OPTION

               EVALUATE WS-OPTION
                   WHEN 1
                       MOVE "./PRGV0001" TO WS-SYSTEM-COMMAND
                       PERFORM RUN-PROGRAM
                       PERFORM PRESS-ENTER

                   WHEN 2
                       MOVE "./PRGI0002" TO WS-SYSTEM-COMMAND
                       PERFORM RUN-PROGRAM
                       PERFORM PRESS-ENTER

                   WHEN 3
                       MOVE "./PRGU0003" TO WS-SYSTEM-COMMAND
                       PERFORM RUN-PROGRAM
                       PERFORM PRESS-ENTER

                   WHEN 4
                       MOVE "./PRGD0004" TO WS-SYSTEM-COMMAND
                       PERFORM RUN-PROGRAM
                       PERFORM PRESS-ENTER

                   WHEN 5
                       MOVE "./PRGQ0005" TO WS-SYSTEM-COMMAND
                       PERFORM RUN-PROGRAM
                       PERFORM PRESS-ENTER

                   WHEN 6
                       MOVE "./PRGQ0006" TO WS-SYSTEM-COMMAND
                       PERFORM RUN-PROGRAM
                       PERFORM PRESS-ENTER

                   WHEN 7
                       MOVE "./PRGQ0007" TO WS-SYSTEM-COMMAND
                       PERFORM RUN-PROGRAM
                       PERFORM PRESS-ENTER

                   WHEN 8
                       MOVE "./PRGR0008" TO WS-SYSTEM-COMMAND
                       PERFORM RUN-PROGRAM
                       PERFORM PRESS-ENTER

                   WHEN 9
                       DISPLAY " "
                       DISPLAY "EXITING STUDENT REGISTRATION SYSTEM..."
                       DISPLAY "THANK YOU."

                   WHEN OTHER
                       DISPLAY " "
                       DISPLAY "INVALID OPTION. PLEASE ENTER 1 TO 9."
                       PERFORM PRESS-ENTER
               END-EVALUATE
           END-PERFORM

           STOP RUN.

       DISPLAY-MENU.
           DISPLAY " "
           DISPLAY "+----------------------------------------+"
           DISPLAY "|           M A I N   M E N U            |"
           DISPLAY "+----------------------------------------+"
           DISPLAY "|                OPTIONS                 |"
           DISPLAY "+----------------------------------------+"
           DISPLAY "| 1 - GENERATE INDEXED FILE              |"
           DISPLAY "| 2 - INSERT STUDENT DATA                |"
           DISPLAY "| 3 - UPDATE STUDENT DATA                |"
           DISPLAY "| 4 - DELETE STUDENT DATA                |"
           DISPLAY "| 5 - QUERY ALL STUDENTS                 |"
           DISPLAY "| 6 - QUERY STUDENT BY ID                |"
           DISPLAY "| 7 - QUERY BY DATE OF INCLUSION         |"
           DISPLAY "| 8 - GENERATE COURSE-WISE REPORT        |"
           DISPLAY "| 9 - EXIT                               |"
           DISPLAY "+----------------------------------------+"
           DISPLAY " ".

       RUN-PROGRAM.
           CALL "SYSTEM"
               USING WS-SYSTEM-COMMAND
               RETURNING WS-SYSTEM-RESULT
           END-CALL

           IF WS-SYSTEM-RESULT NOT = ZERO
               DISPLAY " "
               DISPLAY "ERROR RUNNING PROGRAM."
               DISPLAY "SYSTEM RETURN CODE: " WS-SYSTEM-RESULT
           END-IF.

       PRESS-ENTER.
           DISPLAY " "
           DISPLAY "PRESS ENTER TO RETURN TO THE MAIN MENU..."
           ACCEPT WS-CONTINUE.