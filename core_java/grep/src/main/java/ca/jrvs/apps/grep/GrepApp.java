package ca.jrvs.apps.grep;

public class GrepApp {

  public static void main(String[] args) throws Exception {

    if (args.length != 3) {
      System.out.println("Usage: java GrepApp <regex> <rootPath> <outFile>");
      System.exit(1);
    }

    JavaGrep app = new JavaGrepImp();

    app.setRegex(args[0]);
    app.setRootPath(args[1]);
    app.setOutFile(args[2]);

    app.process();
  }
}