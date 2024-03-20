package loanOne;

import java.sql.Connection;
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
	public static JSONArray addeditPerson(String usr, String upwd) throws ClassNotFoundException, SQLException
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
}
