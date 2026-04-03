package util;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

import javax.management.RuntimeErrorException;
import javax.xml.parsers.DocumentBuilderFactory;

import org.w3c.dom.Document;

import service.PasswordService;

public class Connect {
	public static void main(String[] args) {
		String matKhau = "Duy2005@";        // ← Bạn có thể đổi thành password bạn thích
        String hashed = PasswordService.bamPassword(matKhau);
        
        System.out.println("Mật khẩu bạn sẽ dùng: " + matKhau);
        System.out.println("Hash cần insert vào SQL:");
        System.out.println(hashed);
	}
	private static Connect instance;
	private String url;
	private String user;
	private String password;
	private String driver;
	
	private Connect(){
		try {
			InputStream is = getClass()
					.getClassLoader()
					.getResourceAsStream("db.xml");
			if(is == null) {
				throw new RuntimeException("Khong tim thay file xml");
			}
			
			Document doc = DocumentBuilderFactory
					.newInstance()
					.newDocumentBuilder()
					.parse(is);
			doc.getDocumentElement().normalize();
			driver = doc.getElementsByTagName("driver").item(0).getTextContent();
			url = doc.getElementsByTagName("url").item(0).getTextContent();
			user = doc.getElementsByTagName("user").item(0).getTextContent();
			password = doc.getElementsByTagName("password").item(0).getTextContent();
			
			Class.forName(driver);
			
		}catch (Exception e) {
			throw new RuntimeException("loi load db config" + e.getMessage());
			// TODO: handle exception
		}
		
	}
	public static Connect getInstance() {
		if (instance == null) {
			instance = new Connect();
		}
		return instance;
	}
	
	public Connection getConnect() throws SQLException{
		return DriverManager.getConnection(url,user,password);
	}
}
