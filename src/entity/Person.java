package entity;


public class Person {
	
	private int pid;
    private short type_id; 
    private String firstname;
    private String middlename;
    private String othername;
    private String email;
    private java.sql.Date dob;
    private String phone;
    private String address;
    private String idnumber;
    private String nextofkin;
    private Double income;
    private int created_by;
    private java.util.Date createdon;
    private int modified_by;
    private java.util.Date modifiedon;
    
    
    public int getPid() {
		return pid;
	}
	public void setPid(int pid) {
		this.pid = pid;
	}
	public int getType_id() {
		return type_id;
	}
	public void setType_id(short type_id) {
		this.type_id = type_id;
	}
	public String getFirstname() {
		return firstname;
	}
	public void setFirstname(String firstname) {
		this.firstname = firstname;
	}
	public String getMiddlename() {
		return middlename;
	}
	public void setMiddlename(String middlename) {
		this.middlename = middlename;
	}
	public String getOthername() {
		return othername;
	}
	public void setOthername(String othername) {
		this.othername = othername;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public java.util.Date getDob() {
		return dob;
	}
	public void setDob(java.sql.Date dob) {
		this.dob = dob;
	}
	public String getPhone() {
		return phone;
	}
	public void setPhone(String phone) {
		this.phone = phone;
	}
	public String getAddress() {
		return address;
	}
	public void setAddress(String address) {
		this.address = address;
	}
	public String getIdnumber() {
		return idnumber;
	}
	public void setIdnumber(String idnumber) {
		this.idnumber = idnumber;
	}
	public String getNextofkin() {
		return nextofkin;
	}
	public void setNextofkin(String nextofkin) {
		this.nextofkin = nextofkin;
	}
	public Double getIncome() {
		return income;
	}
	public void setIncome(Double income) {
		this.income = income;
	}
	public int getCreated_by() {
		return created_by;
	}
	public void setCreated_by(int created_by) {
		this.created_by = created_by;
	}
	public java.util.Date getCreatedon() {
		return createdon;
	}
	public void setCreatedon(java.util.Date createdon) {
		this.createdon = createdon;
	}
	public int getModified_by() {
		return modified_by;
	}
	public void setModified_by(int modified_by) {
		this.modified_by = modified_by;
	}
	public java.util.Date getModifiedon() {
		return modifiedon;
	}
	public void setModifiedon(java.util.Date modifiedon) {
		this.modifiedon = modifiedon;
	}

}
