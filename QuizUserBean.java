package com.tecdev;

import java.sql.ResultSet;

public class QuizUserBean { //Bean Rule 1: class should be public
    //Rule 2: members/properties - should be private
    //Same as column names in quiz_users table
    private String userid, password, usertype, question, answer;
    //Rule 3: Should have atleast 'Default Constructor'
    public QuizUserBean(){  //Default Constructor
        userid=password=usertype=question=answer=null; //OCJP2
        //OCJP2: If object is not initialized it is null by default
    }
    //Step 38 Defining four parameter constructor - 4-Mar-2021

    public QuizUserBean(String userid, String password, String question, String answer) {
        this.userid = userid;
        this.password = password;
        this.question = question;
        this.answer = answer;
        this.usertype="C"; //Means every new user is Candidate by default                
    }
    //Step 39: To create new user - 4-Mar-2021
public boolean insert(){
    //(a) Generate SQL Query to insert row (Syntax covered during core java)
    String sql=String.format("Insert Into Quiz_Users Values('%s' , '%s' ,'%s' , '%s' , '%s') ",userid,password,usertype,question,answer);
    //For Debugging Only
    System.out.println("SQL Query inside insert=" + sql);
    try {
        //(b) Use DatabaseBean class to execute this query
        int result=DatabaseBean.executeUpdate(sql); //Insert/Update/Delete
        //(c) If row inserted successfully then return true to Servlet
        if(result>0){
            DatabaseBean.commit();
            return true; //Means Successfully registered
        }
        else        //(d) Otherwise return false
            return false;
    } catch (Exception e) {
        System.out.println("Exception in insert fn of QB " + e.toString());
        return false;
    }
   //return true;
}
    //Rule 4: Optionally we can have other constructors
    public QuizUserBean(String userid, String password){
        this.userid=userid;
        this.password=password;
    }
    //Rule 5: We can have getter/setter Fn: RC=>Insert Code=>Setter/Getter
    public String getUserid() {return userid;  }
    public void setUserid(String userid) { this.userid = userid; }
    public String getPassword() {        return password;    }
    public void setPassword(String password) { this.password = password;   }
    public String getUsertype() {       return usertype;   }
    public void setUsertype(String usertype) {  this.usertype = usertype;}
    public String getQuestion() {      return question;   }
    public void setQuestion(String question) {    this.question = question;  }
    public String getAnswer() {        return answer;    }
    public void setAnswer(String answer) {    this.answer = answer; }    
    //Rule 6: Define some custom/UDFn to perform various business logics
    public boolean exists(){ //Earlier Code
      return exists(true);  //Delegates to another fn
    }
    //Step 40 Overloaded exists fn
    public boolean exists(boolean checkPassword){
         //Step 40 (a) Generate SQL Query [Same logic also covered during core java]
       String sql=String.format(
               "Select * from quiz_users where userid='%s' ", userid);
      if(checkPassword)   // if(checkPassword==true) //Not Recommonded
           sql+=String.format(" and password='%s'", password);
       System.out.println("SQL Query in exists fn " + sql);//For Debugging
        try {
            //(b) Execute the Query using DatabaseBean [M:Model]
            ResultSet rs=DatabaseBean.executeQuery(sql);
            //(c) If row found fetch its usertype for future use
            if(rs.next()){  //true when found
                usertype=rs.getString("usertype");
                question=rs.getString("question"); //fetch actual question
                answer=rs.getString("answer"); //fetch actual answer
                return true;  //Return back to QuizServlet
            }
            else 
                return false;  //Means userid not exists
        } catch (Exception e) 
        {
            System.out.println("Exception in exists Fn " + e.toString());
            return false;  //Means not found
        }
    }
    //Step 45: 09-Mar-2021 Update password of user
    public boolean update(){
     //(a) Generate SQL Query to insert row (Syntax covered during core java)
    String sql=String.format("Update Quiz_Users Set password='%s' where userid='%s' and question='%s' and answer='%s'", password, userid, question, answer);
    //For Debugging Only
    System.out.println("SQL Query inside update=" + sql);
    try {
        //(b) Use DatabaseBean class to execute this query
        int result=DatabaseBean.executeUpdate(sql); //Insert/Update/Delete
        //(c) If row inserted successfully then return true to Servlet
        if(result>0){
            DatabaseBean.commit();
            return true; //Means Successfully registered
        }
        else        //(d) Otherwise return false
            return false;
    } catch (Exception e) {
        System.out.println("Exception in Update fn of QB " + e.toString());
        return false;
    }
}
}
