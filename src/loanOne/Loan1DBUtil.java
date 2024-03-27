package loanOne;

import entity.Person;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

public class Loan1DBUtil {
	@SuppressWarnings("unchecked")
	public static JSONArray getModules(int uid) throws ClassNotFoundException, SQLException
	{

		JSONArray list = new JSONArray();
		Connection con;
		PreparedStatement pst;
		ResultSet rs;

		//try{
			con = Connect_db.getConnection();
			
			String query = "Select * from get_modules(?);";

			pst = con.prepareStatement(query);
			pst.setInt(1, uid);
			
			rs = pst.executeQuery();
			
			while(rs.next())
			{
				JSONObject obj = new JSONObject();
				
				obj.put("id", rs.getString("mid"));	
				obj.put("name", rs.getString("mname"));	
				obj.put("type", rs.getString("mtype"));	
				obj.put("can_add", rs.getString("madd"));	
				obj.put("can_edit", rs.getString("medit"));	
				obj.put("can_view", rs.getString("mview"));	
				obj.put("can_delete", rs.getString("mdelete"));	
				obj.put("url", rs.getString("murl"));	
				obj.put("main_menuid", rs.getString("mmain_menuid"));	
				obj.put("menu_name", rs.getString("mmenu_name"));	
				
				list.add(obj);	
			}
			
		//}
		//catch(Exception e)
		//{
			//out.println(e.getMessage());	
		//}	
		return list;
	}

	@SuppressWarnings("unchecked")
	public static JSONArray getClients(int uid) throws ClassNotFoundException, SQLException
	{

		JSONArray list = new JSONArray();
		Connection con;
		PreparedStatement pst;
		ResultSet rs;

		//try{
			con = Connect_db.getConnection();
			
			String query = "Select * from get_clients(?);";

			pst = con.prepareStatement(query);
			pst.setInt(1, uid);
			
			rs = pst.executeQuery();
			
			while(rs.next())
			{
				JSONObject obj = new JSONObject();
				
				obj.put("pid", rs.getString("pid"));	
				obj.put("type_id", rs.getString("type_id"));	
				obj.put("firstname", rs.getString("firstname"));	
				obj.put("middlename", rs.getString("middlename"));	
				obj.put("othername", rs.getString("othername"));	
				obj.put("email", rs.getString("email"));	
				obj.put("dob", rs.getString("dob"));	
				obj.put("phone", rs.getString("phone"));	
				obj.put("address", rs.getString("address"));	
				obj.put("idnumber", rs.getString("idnumber"));	
				obj.put("nextofkin", rs.getString("nextofkin"));	
				obj.put("income", rs.getString("income"));	
				obj.put("created_by", rs.getString("created_by"));	
				obj.put("createdon", rs.getString("createdon"));	
				obj.put("modified_by", rs.getString("modified_by"));	
				obj.put("modifiedon", rs.getString("modifiedon"));
			    
				list.add(obj);	
			}
			
		//}
		//catch(Exception e)
		//{
			//out.println(e.getMessage());	
		//}	
		return list;
	}
	
	@SuppressWarnings("unchecked")
	public static JSONArray login_User(String usr, String upwd) throws ClassNotFoundException, SQLException
	{
		JSONArray list = new JSONArray();
		Connection con;
		PreparedStatement pst;
		ResultSet rs;

		//try{
			con = Connect_db.getConnection();
			
			String query = "Select * from login_user(?);";

			pst = con.prepareStatement(query);
			pst.setString(1, usr);
			
			rs = pst.executeQuery();
			
			if(rs.next())
			{
				JSONObject obj = new JSONObject();
				String pwd = rs.getString("upwd");
				
				if(upwd.equals(pwd)) 
				{
					//correct pwd
					obj.put("uid", rs.getString("uid"));
					obj.put("uname", rs.getString("uname"));
					obj.put("success", "OK");
				}
				else
				{
					//invalid pwd
					obj.put("success", "NO1");
				}
				list.add(obj);	
			}
			else
			{
				//invalid user
				JSONObject obj = new JSONObject();
				obj.put("success", "NO2");
				list.add(obj);
			}

		/*}
		catch(Exception e)
		{
			//out.println(e.getMessage());	
		}*/
		return list;
	}

	@SuppressWarnings("unchecked")
	public static JSONArray addeditPerson(Person person,String mode, int uid) throws ClassNotFoundException, SQLException
	{
		JSONArray list = new JSONArray();
        // Establish connection
        Connection connection = null;
        int newPid = -1; // Initialize newPid to a default value
        //CallableStatement callableStatement = null;
        
       // try {
            connection = Connect_db.getConnection(); // Replace with your database connection method

            String sql;
            if ("1".equals(mode)) {
                sql = "INSERT INTO person (type_id, firstname, middlename, othername, email, dob, phone, address, idnumber, nextofkin, income, created_by) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            } else if ("2".equals(mode)) {
                sql = "UPDATE person SET type_id = ?, firstname = ?, middlename = ?, othername = ?, email = ?, dob = ?, phone = ?, address = ?, idnumber = ?, nextofkin = ?, income = ?, modified_by = ?, modifiedon = CURRENT_TIMESTAMP WHERE pid = ?";
            } else {
                // Handle invalid mode
    			JSONObject obj = new JSONObject();
				obj.put("message", "Invalid mode");		
				list.add(obj);	
                return list;
            }

            //callableStatement = connection.prepareCall(storedProcedureCall);
            PreparedStatement preparedStatement = connection.prepareStatement(sql);
            
            if ("1".equals(mode)) {
                // Skip setting pid for INSERT statement
            	preparedStatement.setInt(1, person.getType_id());
            	preparedStatement.setString(2, person.getFirstname());
            	preparedStatement.setString(3, person.getMiddlename());
            	preparedStatement.setString(4, person.getOthername());
            	preparedStatement.setString(5, person.getEmail());
            	preparedStatement.setDate(6, (Date) person.getDob());
            	preparedStatement.setString(7, person.getPhone());
            	preparedStatement.setString(8, person.getAddress());
            	preparedStatement.setString(9, person.getIdnumber());
            	preparedStatement.setString(10, person.getNextofkin());
            	preparedStatement.setDouble(11, person.getIncome());
            	preparedStatement.setInt(12, uid);
            } else if ("2".equals(mode)) {
                // Set parameters including pid for UPDATE statement
            	preparedStatement.setInt(1, person.getType_id());
            	preparedStatement.setString(2, person.getFirstname());
            	preparedStatement.setString(3, person.getMiddlename());
            	preparedStatement.setString(4, person.getOthername());
            	preparedStatement.setString(5, person.getEmail());
            	preparedStatement.setDate(6, (Date) person.getDob());
            	preparedStatement.setString(7, person.getPhone());
            	preparedStatement.setString(8, person.getAddress());
            	preparedStatement.setString(9, person.getIdnumber());
            	preparedStatement.setString(10, person.getNextofkin());
            	preparedStatement.setDouble(11, person.getIncome());
            	preparedStatement.setInt(12, uid);
            	preparedStatement.setInt(13, person.getPid()); // Set pid for UPDATE
            }

            int rowsAffected = preparedStatement.executeUpdate();
            JSONObject obj = new JSONObject();
            if (rowsAffected > 0) {
                // Get the generated keys (including new pid)
            	
                ResultSet rs = preparedStatement.getGeneratedKeys();
                if (rs.next()) {
                    newPid = rs.getInt(1); // Get the new pid
                    //System.out.println("New PID: " + newPid);
    				obj.put("newid", newPid);
    				list.add(obj);
                }
            } else {
                //System.out.println("No rows affected.");
                obj.put("newid", "No rows affected.");
				list.add(obj);
            }
			

        return list;
	}
	
}
