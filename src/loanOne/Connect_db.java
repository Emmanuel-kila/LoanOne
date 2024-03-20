package loanOne;

import java.sql.Connection;
import java.sql.DriverManager;

public class Connect_db {

    static Connection con=null;
    public static Connection getConnection() 
    {
        if (con != null) return con;
        // get db, user, pass from settings file
		String user = "postgres"; //"root";
		String pass = "postgres"; // "";
		String db ="loans";
		
        return getConnection(db, user, pass);
    }

    private static Connection getConnection(String db_name,String user_name,String password)
    {
        try
        {
        	String url = "jdbc:postgresql://localhost:5433/"+db_name+"?user="+user_name+"&password="+password;
        	//String url ="jdbc:mysql://localhost/"+db_name+"?user="+user_name+"&password="+password;
        	//String url = "jdbc:mysql://localhost:3306/"+db_name+"?useSSL=false";

    		//load mysql/postgres driver
    		Class.forName("org.postgresql.Driver"); // postgres
    		//Class.forName("com.mysql.cj.jdbc.Driver"); //mysql
    		
            con=DriverManager.getConnection(url);
            //Connection con = DriverManager.getConnection(url, user_name, password);
        }
        catch(Exception e)
        {
            e.printStackTrace();
        }

        return con;        
    }
}
