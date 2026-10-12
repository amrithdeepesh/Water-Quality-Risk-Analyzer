package com.waterquality.security;

import java.security.GeneralSecurityException;
import java.security.MessageDigest;
import java.security.SecureRandom;
import java.util.Arrays;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;

/** PBKDF2 password storage helper using only the Java 8 standard library. */
public final class PasswordHasher {
    private static final int ITERATIONS = 120000;
    private static final int SALT_BYTES = 16;
    private static final int HASH_BYTES = 32;
    private static final SecureRandom RANDOM = new SecureRandom();

    private PasswordHasher() { }

    public static String newSalt() {
        byte[] salt = new byte[SALT_BYTES];
        RANDOM.nextBytes(salt);
        return toHex(salt);
    }

    public static String hash(String password, String saltHex) {
        byte[] salt = fromHex(saltHex);
        PBEKeySpec spec = new PBEKeySpec(password.toCharArray(), salt,
                ITERATIONS, HASH_BYTES * 8);
        try {
            byte[] derived = SecretKeyFactory.getInstance(
                    "PBKDF2WithHmacSHA256").generateSecret(spec).getEncoded();
            return toHex(derived);
        } catch (GeneralSecurityException exception) {
            throw new IllegalStateException("Password hashing is unavailable.",
                    exception);
        } finally {
            spec.clearPassword();
            Arrays.fill(salt, (byte) 0);
        }
    }

    public static boolean matches(String password, String salt, String expectedHash) {
        if (password == null || salt == null || expectedHash == null) {
            return false;
        }
        byte[] actual = fromHex(hash(password, salt));
        byte[] expected = fromHex(expectedHash);
        try {
            return MessageDigest.isEqual(actual, expected);
        } finally {
            Arrays.fill(actual, (byte) 0);
            Arrays.fill(expected, (byte) 0);
        }
    }

    private static String toHex(byte[] value) {
        StringBuilder result = new StringBuilder(value.length * 2);
        for (byte item : value) {
            result.append(String.format("%02x", item & 0xff));
        }
        return result.toString();
    }

    private static byte[] fromHex(String value) {
        byte[] result = new byte[value.length() / 2];
        for (int index = 0; index < result.length; index++) {
            int high = Character.digit(value.charAt(index * 2), 16);
            int low = Character.digit(value.charAt(index * 2 + 1), 16);
            if (high < 0 || low < 0) {
                throw new IllegalArgumentException("Invalid hexadecimal input.");
            }
            result[index] = (byte) ((high << 4) | low);
        }
        return result;
    }
}
