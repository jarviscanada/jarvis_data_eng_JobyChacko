package ca.jrvs.apps.grep;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.BufferedWriter;
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Pattern;

public class JavaGrepImp implements JavaGrep {

  private static final Logger logger = LoggerFactory.getLogger(JavaGrepImp.class);

  private String rootPath;
  private String regex;
  private String outFile;
  private Pattern pattern;

  /**
   * Top level search workflow
   */
  @Override
  public void process() throws IOException {

    logger.info("Starting grep. rootPath='{}', regex='{}', outFile='{}'", rootPath, regex, outFile);

    List<String> matchedLines = new ArrayList<>();

    List<File> files = listFiles(rootPath);
    logger.info("Discovered {} file(s) under rootPath='{}'", files.size(), rootPath);

    for (File file : files) {

      logger.debug("Scanning file: {}", file.getAbsolutePath());

      List<String> lines = readLines(file);

      for (String line : lines) {
        if (containsPattern(line)) {
          matchedLines.add(line);
        }
      }
    }

    logger.info("Total matched line(s): {}", matchedLines.size());

    writeToFile(matchedLines);

    logger.info("Finished. Output written to '{}'", outFile);
  }

  /**
   * Traverse a given directory and return all files
   * @param rootDir
   * @return
   */
  @Override
  public List<File> listFiles(String rootDir) {

    List<File> result = new ArrayList<>();

    if (rootDir == null || rootDir.isBlank()) {
      logger.warn("rootDir is null/blank. Returning empty file list.");
      return result;
    }

    File dir = new File(rootDir);

    if (!dir.exists()) {
      logger.warn("rootDir does not exist: {}", rootDir);
      return result;
    }

    if (dir.isFile()) {
      result.add(dir);
      return result;
    }

    File[] files = dir.listFiles();

    if (files == null) {
      logger.warn("Unable to list files under directory: {}", rootDir);
      return result;
    }

    for (File file : files) {
      if (file.isDirectory()) {
        result.addAll(listFiles(file.getAbsolutePath()));
      } else {
        result.add(file);
      }
    }

    return result;
  }

  /**
   * Read a file and return all the lines
   * @param inputFile
   * @return
   */
  @Override
  public List<String> readLines(File inputFile) {

    List<String> lines = new ArrayList<>();

    if (inputFile == null) {
      logger.warn("inputFile is null. Returning empty list.");
      return lines;
    }

    try {
      Files.lines(inputFile.toPath())
          .forEach(lines::add);

    } catch (IOException e) {
      logger.error("Failed to read file {}", inputFile.getAbsolutePath(), e);
    }

    return lines;
  }

  /**
   * Check if a line contains the given regex pattern
   * @param line
   * @return
   */
  @Override
  public boolean containsPattern(String line) {

    if (pattern == null) {
      logger.error("Regex pattern is not initialized.");
      return false;
    }

    if (line == null) {
      return false;
    }

    return pattern.matcher(line).find();
  }

  /**
   * write lines to a file
   * @param lines
   * @throws IOException
   */
  @Override
  public void writeToFile(List<String> lines) throws IOException {

    if (outFile == null || outFile.isBlank()) {
      logger.error("outFile is null/blank. Cannot write output.");
      throw new IOException("Invalid outFile path");
    }

    try (BufferedWriter writer = Files.newBufferedWriter(Paths.get(outFile))) {

      for (String line : lines) {
        writer.write(line);
        writer.newLine();
      }

    } catch (IOException e) {
      logger.error("Failed to write output to file: {}", outFile, e);
      throw e;
    }
  }

  @Override
  public String getRootPath() {
    return rootPath;
  }

  @Override
  public void setRootPath(String rootPath) {
    this.rootPath = rootPath;
  }

  @Override
  public String getRegex() {
    return regex;
  }

  @Override
  public void setRegex(String regex) {

    if (regex == null) {
      throw new IllegalArgumentException("regex cannot be null");
    }

    this.regex = regex;
    this.pattern = Pattern.compile(regex);

    logger.info("Regex updated and compiled: '{}'", regex);
  }

  @Override
  public String getOutFile() {
    return outFile;
  }

  @Override
  public void setOutFile(String outFile) {
    this.outFile = outFile;
  }
}