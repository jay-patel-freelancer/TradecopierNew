package util;

import java.security.SecureRandom;
import java.math.BigInteger;

public final class TokenGenerator {
  static private SecureRandom random = new SecureRandom();

  public static String nextToken() {
    return new BigInteger(130, random).toString(32);
  }
}
