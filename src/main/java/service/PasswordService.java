package service;

import org.mindrot.jbcrypt.BCrypt;

public class PasswordService {
	// Băm mật khẩu
	public static String bamPassword(String PasswordGoc) {
		if (PasswordGoc != null && !PasswordGoc.isEmpty()) {
			return BCrypt.hashpw(PasswordGoc, BCrypt.gensalt());
		}
		return null;
	}

	// Kiem tra mật khẩu
	public static boolean kiemTraPassword(String PasswordGoc, String PasswordHashed) {
		if (PasswordGoc != null && PasswordHashed != null) {
			return BCrypt.checkpw(PasswordGoc, PasswordHashed);
		}
		return false;
	}

}
