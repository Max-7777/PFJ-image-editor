import java.io.*;
import java.util.*;

List<String> readFile(String dir) {
  List<String> o = new ArrayList<>();
  BufferedReader reader = createReader(dir);
  String line = null;
  try {
    while ((line = reader.readLine()) != null) {
      if (line.startsWith("//")) continue;
      o.add(line);
    }
    reader.close();
  } catch (IOException e) {
    e.printStackTrace();
  }
  
  return o;
}
