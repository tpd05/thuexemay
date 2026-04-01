package util;

import java.sql.Connection;

public class test {

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		Connection con = null;
		try {
			con = Connect.getInstance().getConnect();
			if(con!=null) {
				System.out.print("ok");
			}
		}catch (Exception e) {
			e.printStackTrace();
			// TODO: handle exception
		}
	}

}
