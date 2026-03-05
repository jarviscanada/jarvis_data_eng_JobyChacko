package ca.jrvs.apps.grep;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.BufferedWriter;
import java.io.File;
import java.io.IOException;
import java.io.UncheckedIOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.List;
import java.util.regex.Pattern;
import java.util.stream.Stream;

public class JavaGrepStreamImp implements JavaGrep {

  private static final Logger logger = LoggerFactory.getLogger(JavaGrepStreamImp.class);

  private String rootPath;
  private String regex;
  private String outFile;
  private Pattern pattern;

  /**
   * Streaming implementation of the grep workflow
   */
  @Override
  public void process() throws IOException {

    logger.info("Starting streaming grep. rootPath='{}', regex='{}', outFile='{}'", rootPath, regex, outFile);

    List<File> files = listFiles(rootPath);

    try (BufferedWriter writer = Files.newBufferedWriter(Paths.get(outFile))) {

      for (File file : files) {

        logger.debug("Scanning file: {}", file.getAbsolutePath());

        try (Stream<String> lines = Files.lines(file.toPath())) {
          lines
              .filter(this::containsPattern)
              .forEach(line -> writeLine(writer, line));

        } catch (UncheckedIOException e) {
          throw e.getCause();
        } catch (IOException e) {
          logger.error("Failed reading file {}", file.getAbsolutePath(), e);
        }
      }
    }

    logger.info("Finished streaming grep. Output written to '{}'", outFile);
  }

  @Override
  public List<File> listFiles(String rootDir) {
    return new JavaGrepImp().listFiles(rootDir);
  }

  @Override
  public List<String> readLines(File inputFile) {
    throw new UnsupportedOperationException("Streaming implementation does not support readLines()");
  }

  @Override
  public boolean containsPattern(String line) {
    return pattern != null && line != null && pattern.matcher(line).find();
  }

  @Override
  public void writeToFile(List<String> lines) {
    throw new UnsupportedOperationException("Streaming implementation writes directly to file");
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
  }

  private void writeLine(BufferedWriter writer, String line) {
    try {
      writer.write(line);
      writer.newLine();
    } catch (IOException e) {
      throw new UncheckedIOException(e);
    }
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
