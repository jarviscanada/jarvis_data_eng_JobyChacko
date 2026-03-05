# Java Grep Application

A simplified implementation of the Unix `grep` command built with Core Java. The application recursively scans files from a root directory, matches lines against a regular expression, and writes results to an output file.

The project contains two implementations of the grep workflow:

**JavaGrepImp** — A straightforward implementation that collects matching lines in memory and writes them to the output file after scanning all files.

**JavaGrepStreamImp** — A streaming implementation that processes files line-by-line using the Java Stream API and writes matching lines directly to the output file.

---

## Table of Contents

- [Quick Start](#quick-start)
- [Usage](#usage)
- [How It Works](#how-it-works)
- [Logging](#logging)
- [Project Structure](#project-structure)
- [Performance Notes](#performance-notes)
- [Technologies](#technologies)
- [Future Improvements](#future-improvements)

---

## Quick Start

**Build the project:**

```bash
cd core_java/grep
mvn clean package
```

This generates the executable jar:

```
target/grep-1.0-SNAPSHOT.jar
```

**Run the application:**

```bash
java -jar target/grep-1.0-SNAPSHOT.jar <regex> <rootPath> <outFile>
```

**Example:**

```bash
java -jar target/grep-1.0-SNAPSHOT.jar ".*Romeo.*Juliet.*" data output.txt
```

This scans all files inside the `data` directory and writes matching lines to `output.txt`.

---

## Usage

| Argument   | Description                                        |
|------------|----------------------------------------------------|
| `regex`    | Regular expression used to match lines             |
| `rootPath` | Root directory to recursively scan                 |
| `outFile`  | Output file where matched lines will be written    |

**Example Patterns**

| Pattern                  | Description                                        |
|--------------------------|----------------------------------------------------|
| `.*Romeo.*Juliet.*`      | Lines containing both "Romeo" and "Juliet"         |
| `^Enter.*`               | Lines beginning with "Enter"                       |
| `^$`                     | Empty lines                                        |
| `William Shakespeare`    | Lines containing the literal string                |

---

## How It Works

The main workflow is coordinated by the `process()` method:

```
matchedLines = empty list
for each file in listFiles(rootPath):
    for each line in readLines(file):
        if containsPattern(line):
            matchedLines.add(line)
writeToFile(matchedLines)
```

This logic is implemented in `JavaGrepImp`.

The streaming implementation (`JavaGrepStreamImp`) follows the same concept but processes lines lazily using Java Streams and writes matching lines immediately to the output file instead of storing them in memory.

---

## Logging

The application uses SLF4J with Log4j for logging.

**Example log output:**

```
INFO  Starting grep. rootPath='data', regex='William Shakespeare'
INFO  Discovered 5 file(s) under rootPath='data'
INFO  Total matched line(s): 23
INFO  Finished. Output written to 'output.txt'
```
<img width="1280" height="107" alt="image" src="https://github.com/user-attachments/assets/22be8e90-579f-4668-98be-45d935802301" />
<img width="1280" height="42" alt="image" src="https://github.com/user-attachments/assets/0537422b-a843-4064-b95d-07dcf527688e" />

---

## Project Structure

```
core_java/grep/
├── src
│   └── main
│       └── java
│           └── ca/jrvs/apps/grep
│               ├── GrepApp.java
│               ├── JavaGrep.java
│               ├── JavaGrepImp.java
│               └── JavaGrepStreamImp.java
├── data/
├── target/
├── pom.xml
└── README.md
```

---

## Performance Notes

The primary implementation reads file contents and stores matching lines in memory before writing them to the output file.

Files are read using:

```java
Files.lines(inputFile.toPath()).forEach(lines::add);
```

This approach is simple but may increase memory usage when processing very large files.

To address this, the project also includes a streaming implementation. The streaming version processes files lazily using the Java Stream API:

```java
Files.lines(file.toPath())
     .filter(this::containsPattern)
     .forEach(line -> writeLine(writer, line));
```

This allows lines to be processed one at a time and written directly to the output file without storing them all in memory.

---

## Technologies

- Java 8
- Maven
- SLF4J
- Log4j
- Java Regex Pattern API
- Java NIO File API

---

## Future Improvements

- Unit tests with JUnit
- Parallel file scanning
- Command-line argument validation
- Configurable logging levels
- Filtering unsupported or binary file types
