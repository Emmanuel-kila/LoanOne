package loanOne;

import jakarta.servlet.ServletException;
//import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Date;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

import entity.Person;
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
				logout_User(request, response);   
				 break;
				 
			case 100:    //Persons
			 //code to be executed;    
				addEditPerson(request, response, uid) ; 
			 break;
			 
			case 105:    //Persons
				 //code to be executed;    
				getClients(response, uid);
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

	private void logout_User(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		PrintWriter out = response.getWriter();
		HttpSession session = request.getSession(false);
		try{
	        if (session != null) {
	            session.invalidate(); // Invalidate the session
	        }
	        response.sendRedirect("login.jsp"); // Redirect to the login page
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

	private void getClients(HttpServletResponse response,Integer uid) throws ServletException, IOException {
		PrintWriter out = response.getWriter();
		JSONArray list ;// = new JSONArray();
		
		try{
			list = Loan1DBUtil.getClients(uid);

			
			out.println(list.toJSONString());
			out.flush();
		}
		catch(Exception e)
		{
			out.println(e.getMessage());	
		}		
	}
	
	protected void addEditPerson(HttpServletRequest request, HttpServletResponse response,Integer uid) throws ServletException, IOException {
		PrintWriter out = response.getWriter();
		JSONArray list ;
		try{
	        // Extract form data from request
			String pidParam = request.getParameter("pid");
			int pid;
			if (pidParam != null && !pidParam.isEmpty()) {
			    pid = Integer.parseInt(pidParam);
			} else {
			    // Handle the case where pid is null or empty
			    pid = 0; // Or any other default value that makes sense in your context
			}
	        short type_id = (short) Integer.parseInt(request.getParameter("type_id"));
	        String firstname = request.getParameter("firstname");
	        String middlename = request.getParameter("middlename");
	        String othername = request.getParameter("othername");
	        String email = request.getParameter("email");
	        //Date dob = Date.valueOf(request.getParameter("dob")); // Assuming dob is in format yyyy-MM-dd
	        java.sql.Date dob = java.sql.Date.valueOf(request.getParameter("dob"));
	        String phone = request.getParameter("phone");
	        String address = request.getParameter("address");
	        String idnumber = request.getParameter("idnumber");
	        String nextofkin = request.getParameter("nextofkin");
	        double income = Double.parseDouble(request.getParameter("income"));
	        String mode = request.getParameter("mode");
	
	        // Create a Person object and populate its fields
	        Person person = new Person(); // Fully qualify the class name
	        person.setPid(pid);
	        person.setType_id(type_id);
	        person.setFirstname(firstname);
	        person.setMiddlename(middlename);
	        person.setOthername(othername);
	        person.setEmail(email);
	        person.setDob(dob);
	        person.setPhone(phone);
	        person.setAddress(address);
	        person.setIdnumber(idnumber);
	        person.setNextofkin(nextofkin);
	        person.setIncome(income);
	
			list = Loan1DBUtil.addeditPerson(person,mode,uid);

			
			out.println(list.toJSONString());
			out.flush();
	        // You can perform further operations with the person object as needed
	
	        // For example, you can forward the person object to a JSP page for display
	        //request.setAttribute("person", person);
	        //request.getRequestDispatcher("displayPerson.jsp").forward(request, response);
		}
		catch(Exception e)
		{
			e.printStackTrace(); 
			out.println(e.getMessage());
			out.flush();
		}	
    }
}
