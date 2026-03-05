# Java Grep Application

A simplified implementation of the Unix `grep` command built with Core Java. The application recursively scans files from a root directory, matches lines against a regular expression, and writes results to an output file.

---

## Table of Contents

- [Quick Start](#quick-start)
- [Usage](#usage)
- [How It Works](#how-it-works)
- [Project Structure](#project-structure)
- [Performance Notes](#performance-notes)
- [Technologies](#technologies)
- [Future Improvements](#future-improvements)

---

## Quick Start

### 1. Build

```bash
cd core_java/grep
mvn clean package
```

This generates an executable fat JAR at `target/grep-1.0-SNAPSHOT.jar`.

### 2. Run

```bash
java -jar target/grep-1.0-SNAPSHOT.jar <regex> <rootPath> <outFile>
```

**Example:**

```bash
java -jar target/grep-1.0-SNAPSHOT.jar ".*Romeo.*Juliet.*" data output.txt
```

Scans all files under `data/` and writes matching lines to `output.txt`.

<img width="2258" height="200" alt="image" src="https://github.com/user-attachments/assets/992cc804-a27d-4fc8-864b-51bb186f64d3" />


---

## Usage

| Argument   | Description                                      |
|------------|--------------------------------------------------|
| `regex`    | Regular expression used to match lines           |
| `rootPath` | Root directory to recursively scan               |
| `outFile`  | Output file where matched lines will be written  |

### Example Patterns

| Pattern             | Matches                                    |
|---------------------|--------------------------------------------|
| `.*Romeo.*Juliet.*` | Lines containing both "Romeo" and "Juliet" |
| `^Enter.*`          | Lines beginning with "Enter"               |
| `^$`                | Empty lines                                |
| `William Shakespeare` | Lines containing the literal string      |

---

## How It Works

The `process()` method coordinates the main workflow:

```
matchedLines = []

for each file in listFiles(rootPath):
    for each line in readLines(file):
        if containsPattern(line):
            matchedLines.add(line)

writeToFile(matchedLines)
```

### Key Components

| Method             | Responsibility                                      |
|--------------------|-----------------------------------------------------|
| `process()`        | Orchestrates the overall workflow                   |
| `listFiles()`      | Recursively traverses directories to collect files  |
| `readLines()`      | Reads all lines from a given file                   |
| `containsPattern()`| Tests whether a line matches the regex              |
| `writeToFile()`    | Writes all matched lines to the output file         |

### Logging

The application uses SLF4J with Log4j. Sample output:

```
INFO  Starting grep. rootPath='data', regex='William Shakespeare'
INFO  Discovered 5 file(s) under rootPath='data'
INFO  Total matched line(s): 23
INFO  Finished. Output written to 'output.txt'
```

---

## Project Structure

```
core_java/grep/
├── src/
│   └── main/
│       └── java/
│           └── ca/jrvs/apps/grep/
│               ├── GrepApp.java
│               ├── JavaGrep.java
│               └── JavaGrepImp.java
├── data/
├── target/
├── pom.xml
└── README.md
```

---

## Performance Notes

The current implementation loads entire files into memory:

```java
List<String> lines = Files.readAllLines(path);
```

For large files, a streaming approach is more memory efficient:

```java
Files.lines(file.toPath())
     .filter(line -> containsPattern(line))
     .forEach(writer::write);
```

This processes files lazily, one line at a time, without holding everything in the heap.

---

## Technologies

- **Java 8**
- **Maven** with Maven Shade Plugin (fat JAR packaging)
- **SLF4J + Log4j** for logging
- **Java Regex Pattern API**
- **Java NIO File API**

---

## Future Improvements

- Stream-based file processing to reduce memory usage
- Automated unit tests with JUnit
- Parallel file scanning for better performance
- Command-line argument validation
- Configurable logging levels
- Binary/unsupported file type filtering
