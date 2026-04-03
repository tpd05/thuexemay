package model;

import java.sql.Connection;

public class TaiKhoan {
	private int userID;
	private String username;
	private String password;
	private Role role;

    public TaiKhoan() {}

	public TaiKhoan(int userID, String username, String password, Role role) {
		this.userID = userID;
		this.username = username;
		this.password = password;
		this.role = role;
	}

	public TaiKhoan(String username, String password, Role role) {
		super();
		this.username = username;
		this.password = password;
		this.role = role;
	}
	

	public TaiKhoan(String username, String password) {
		super();
		this.username = username;
		this.password = password;
	}

	public int getUserID() {
		return userID;
	}

	public void setUserID(int userID) {
		this.userID = userID;
	}

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public Role getRole() {
		return role;
	}

	public void setRole(Role role) {
		this.role = role;
	}


    // Getter & Setter
}
