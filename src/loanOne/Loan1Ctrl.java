package loanOne;

import jakarta.servlet.ServletException;
//import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

/**
 * Servlet implementation class Loan1
 */
public class Loan1Ctrl extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.getWriter().append("Served at: ").append(request.getContextPath());
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		//doGet(request, response);
		Integer uid;
		HttpSession hs = request.getSession();
		Integer moduleid=Integer.parseInt(request.getParameter("moduleid"));
		if(hs.getAttribute("uid")==null) {
			uid=0;
		}
		else {
		 uid=Integer.parseInt((String) hs.getAttribute("uid"));
		}
		
		switch(moduleid){   
			case 1:    //Login
				login_User(request,response);   
			 break;

			case 2:    //Main form
				 getModules(response, uid);   
				 break;

			case 3:    //Log Off
				 //code to be executed;    
				 break;
				 
			case 100:    //Persons
			 //code to be executed;    
			 break;
			 
			case 200:    //Users
			 //code to be executed;    
			 break; 
	
			case 210:    //User Roles
				 //code to be executed;    
				 break; 

			case 250:    //Roles
				 //code to be executed;    
				 break; 

			case 260:    //Role Rights
				 //code to be executed;    
				 break; 

			case 300:    //Loan Application
				 //code to be executed;    
				 break; 

			case 310:    //Loan Approval
				 //code to be executed;    
				 break; 

			case 320:    //Loan Disbursement
				 //code to be executed;    
				 break; 

			case 330:    //Loan Repayment
				 //code to be executed;    
				 break; 

			case 340:    //Loan Schedule
				 //code to be executed;    
				 break; 

			case 400:    //Audit Log
				 //code to be executed;    
				 break; 

			case 900:    //Reports
				 //code to be executed;    
				 break; 
				 
			default:    // Wrong module 

			  //Wrong module ;  
		}  
	}
	
	private void login_User(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		PrintWriter out = response.getWriter();
		JSONArray list ;// = new JSONArray();
		JSONObject obj;// = new JSONObject();
		
		String usr = request.getParameter("username");
		String upwd = request.getParameter("passkey");
		
		try{
			list = Loan1DBUtil.login_User(usr, upwd);
			
			obj = (JSONObject) list.get(0);
			
			HttpSession hs = request.getSession();
			hs.setAttribute("uname", (String) obj.get("uname"));
			hs.setAttribute("uid", (String) obj.get("uid"));
			
			out.println(list.toJSONString());
			out.flush();
		}
		catch(Exception e)
		{
			out.println(e.getMessage());	
		}		
	}

	private void getModules(HttpServletResponse response,Integer uid) throws ServletException, IOException {
		PrintWriter out = response.getWriter();
		JSONArray list ;// = new JSONArray();
		
		try{
			list = Loan1DBUtil.getModules(uid);

			
			out.println(list.toJSONString());
			out.flush();
		}
		catch(Exception e)
		{
			out.println(e.getMessage());	
		}		
	}
}
