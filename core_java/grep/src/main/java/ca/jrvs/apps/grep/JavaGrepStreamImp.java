package ca.jrvs.apps.grep;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.BufferedWriter;
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.List;
import java.util.stream.Stream;

public class JavaGrepStreamImp extends JavaGrepImp {

  private static final Logger logger = LoggerFactory.getLogger(JavaGrepStreamImp.class);

  /**
   * Streaming implementation of the grep workflow
   */
  @Override
  public void process() throws IOException {

    logger.info("Starting streaming grep. rootPath='{}', regex='{}', outFile='{}'",
        getRootPath(), getRegex(), getOutFile());

    List<File> files = listFiles(getRootPath());
    logger.info("Discovered {} file(s) under rootPath='{}'", files.size(), getRootPath());

    try (BufferedWriter writer = Files.newBufferedWriter(Paths.get(getOutFile()))) {

      for (File file : files) {

        logger.debug("Scanning file: {}", file.getAbsolutePath());

        try (Stream<String> lines = Files.lines(file.toPath())) {

          lines
              .filter(this::containsPattern)
              .forEach(line -> {
                try {
                  writer.write(line);
                  writer.newLine();
                } catch (IOException e) {
                  throw new RuntimeException(e);
                }
              });

        }
      }
    }

    logger.info("Finished streaming grep. Output written to '{}'", getOutFile());
  }
}