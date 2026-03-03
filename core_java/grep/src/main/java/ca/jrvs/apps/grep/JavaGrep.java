package ca.jrvs.apps.grep;

import java.io.File;
import java.io.IOException;
import java.util.List;

public interface JavaGrep {

  /**
   * Top level search workflow
   * @throws Exception
   */
  void process() throws Exception;

  /**
   * Traverse a given directory and return all files
   * @param rootDir
   * @return
   */
  List<File> listFiles(String rootDir);

  /**
   * Read a file and return all the lines
   * @param inputFile
   * @return
   */
  List<String> readlines(File inputFile);

  /**
   * Check if a line contains the given regex pattern (passed by the user)
   * @param line
   * @return
   */
  boolean containsPatters(String line);

  /**
   * write lines to a file
   * @param lines
   * @throws IOException
   */
  void writeToFile(List<String> lines) throws IOException;
  String getRootPath();
  void setRootPath(String rootPath);
  String getRegex();
  void setRegex(String regex);
  String getOutFile();
  void setOutFile(String outFile);


}
