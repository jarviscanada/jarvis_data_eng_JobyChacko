# Student Registration System

A menu-driven COBOL application for managing student records using indexed file-handling concepts, designed to simulate mainframe-style VSAM processing on a local development environment.

---

## Overview

The system allows users to generate a student data file, insert new records, update and delete existing records, query student information, and generate reports. Each major operation is handled by a dedicated COBOL program, connected through a central main menu.

The project was developed locally on macOS using **Visual Studio Code** and **GnuCOBOL**. A COBOL indexed file is used to simulate VSAM Key-Sequenced Data Set behaviour, with the student ID as the primary key.

---

## Project Structure

```
StudentRegistrationSystem/
├── PRGMENU.cbl          # Main menu
├── PRGV0001.cbl         # Generate student indexed file
├── PRGI0002.cbl         # Insert student record
├── PRGU0003.cbl         # Update student record
├── PRGD0004.cbl         # Delete student record
├── PRGQ0005.cbl         # Query all students
├── PRGQ0006.cbl         # Query student by ID
├── PRGQ0007.cbl         # Query students by date of inclusion
├── PRGR0008.cbl         # Course-wise report
├── STUDENT.cpy          # Common copybook (record layout)
├── STUDENTS.txt         # Initial sequential data file
├── STUDENTS.dat         # Generated indexed data file
├── COURSE_REPORT.txt    # Generated course-wise report
└── README.md
```

---

## Menu Options

| Option | Description |
|--------|-------------|
| 1 | Generate the student indexed file |
| 2 | Insert student data |
| 3 | Update student data |
| 4 | Delete student data |
| 5 | Query all students |
| 6 | Query a student by ID |
| 7 | Query students by date of inclusion |
| 8 | Generate a course-wise report |
| 9 | Exit the system |

---

## Compilation

Compile each COBOL program using GnuCOBOL. The `-x` flag creates an executable and `-free` enables free-format COBOL.

```bash
cobc -x -free PRGV0001.cbl -o PRGV0001
cobc -x -free PRGI0002.cbl -o PRGI0002
cobc -x -free PRGU0003.cbl -o PRGU0003
cobc -x -free PRGD0004.cbl -o PRGD0004
cobc -x -free PRGQ0005.cbl -o PRGQ0005
cobc -x -free PRGQ0006.cbl -o PRGQ0006
cobc -x -free PRGQ0007.cbl -o PRGQ0007
cobc -x -free PRGR0008.cbl -o PRGR0008
cobc -x -free PRGMENU.cbl  -o PRGMENU
```

---

## Running the Application

```bash
./PRGMENU
```

> **First run:** Select option **1** to create `STUDENTS.dat` from `STUDENTS.txt` before using any other option.

---

## Program Details

### PRGMENU — Main Menu
Displays the menu and launches the appropriate program based on the selected option, using `SYSTEM` calls (e.g., `./PRGV0001`, `./PRGI0002`).

### PRGV0001 — Generate Student File
Reads `STUDENTS.txt` (comma-delimited) and creates the indexed file `STUDENTS.dat`. Uses `UNSTRING` to parse each line and sets the insert date to the current system date. Running this program again recreates the file, removing any records inserted since the last run.

### PRGI0002 — Insert Student Record
Prompts the user for name, birthday, and course. Automatically assigns the next available student ID by finding the current highest ID and incrementing it.

```
Highest existing ID: 0009
New student ID:      0010
```

### PRGU0003 — Update Student Record
Looks up a student by ID and displays their current details. The user may update name, birthday, and/or course — pressing Enter on a field keeps the existing value. Saves changes using `REWRITE` and records the current date as the update date.

### PRGD0004 — Delete Student Record
Looks up a student by ID, displays their details, and asks for confirmation (`Y`/`y`) before removing the record with the `DELETE` operation.

### PRGQ0005 — Query All Students
Reads all records sequentially using `READ NEXT` and displays them in a class report format, including student ID, name, birthday, course, insert date, and update date. Displays a total student count.

### PRGQ0006 — Query Student by ID
Performs a direct key-based `READ` to locate a specific student record. Displays the student details if found, or reports a not-found message (file status `23`) if the record does not exist.

### PRGQ0007 — Query by Date of Inclusion
Accepts a date in `YYYYMMDD` format and reads all records sequentially, displaying only those whose insert date matches. Reports the count of matching students or a no-results message.

### PRGR0008 — Course-Wise Report
Reads all records, sorts them by course and then student ID using `SORT`/`RELEASE`/`RETURN`, and writes the output to `COURSE_REPORT.txt`. Applies control-break processing to print a new course heading whenever the course changes. Displays total students processed.

---

## Common Copybook — STUDENT.cpy

Defines the shared student record layout included in all programs via `COPY "STUDENT.cpy"`.

```cobol
01 STUDENT-REC.
   05 STU-ID           PIC 9(4).
   05 STU-NAME         PIC X(25).
   05 STU-BIRTHDAY     PIC 9(8).
   05 STU-COURSE       PIC X(15).
   05 STU-INSERT-DATE  PIC 9(8).
   05 STU-UPDATE-DATE  PIC 9(8).
```

---

## Input File Format — STUDENTS.txt

Each line contains four comma-separated fields:

```
StudentID,Student Name,Birthday,Course
```

Example:

```
0001,MATT THOMAS,19821209,ISPF-JCL
0002,ERIC HENDERSON,20070502,HTML
0003,MEGAN KLINE,19980412,JAVA
```

---

## File Operations Reference

| Operation | Purpose |
|-----------|---------|
| `WRITE` | Insert a new record |
| `READ` | Direct key-based lookup |
| `REWRITE` | Update an existing record |
| `DELETE` | Remove a record |
| `READ NEXT` | Sequential processing |
| `START` | Position file before sequential read |
| `SORT` / `RELEASE` / `RETURN` | Course-wise report generation |
| `UNSTRING` | Parse comma-delimited input |
| `STRING` | Build formatted report lines |

## File Status Codes

| Code | Meaning |
|------|---------|
| `00` | Operation completed successfully |
| `10` | End of file |
| `22` | Duplicate record key |
| `23` | Record not found |
| `35` | File not found |

---

## Concepts Demonstrated

- Menu-driven programming
- Copybooks and shared record layouts
- Sequential and indexed file handling
- CRUD operations (Create, Read, Update, Delete)
- Key-based and sequential record access
- File status handling
- Sorting with `SORT`/`RELEASE`/`RETURN`
- Control-break (course-break) processing
- Report generation

---

## Future Improvements

- Validate birthday format (`YYYYMMDD`) and calendar correctness
- Prevent empty or duplicate student records from being inserted
- Add course totals to the course-wise report
- Add search by course name and student name
- Create a backup before delete or update operations
- Prompt for confirmation before recreating the indexed file
- Add screen-clearing between menu options
- Add a date-break report
- Add a `Makefile` or build script for one-command compilation
- Port to a real IBM mainframe environment using VSAM and JCL
- Add automated tests for all CRUD operations

---

## Author

| Field | Detail |
|-------|--------|
| Author | Joby Chacko |
| Date | 08-06-2026 |
| Editor | Visual Studio Code |
| Compiler | GnuCOBOL |
| OS | macOS |