package com.tecdev;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author Bhupendra
 */
public class QuizServlet extends HttpServlet {

   
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        //Step XX(a) Fetch op (operation) from request
        String op=request.getParameter("op");
        //(b) Check if it is null then redirect back to login.html
        if(op==null){
            response.sendRedirect("login.html");
            return;     //Terminate fn
        }
        //(c) Otherwise, perform switch case based on op
        switch(op){   //OCJP: String in switch is introduced in JDK7
            //Delegate/pass request, response data to UDF
            case "1": verifyUser(request,response); break;  //27-Feb-2021
            case "2": registerUser(request,response); break; //02-Mar-2021
            case "3": forgottenPassword(request, response); break; //09-Mar-2021
            case "4": startExam(request,response); break;  //Step 57, 11-Mar-2021
            case "5": saveQuestion(request,response); break;  //Step 78: 16-Mar-2021
            case "6": navigation(request,response); break;  //Step 87, 18-Mar-2021
            case "7": findQid(request, response); break;  //Step 92-20-Mar-2021
            case "8": searchQuestions(request, response); break; //Step 99-23-Mar-2021
            case "9": showQuestion(request, response); break; //Step 110-24-Mar-2021
            case "10": logout(request, response); break; //10-Apr-2021
         /*   case "7": generateCertificate(request,response); break; //14-Mar-2021
            case "8": logout(); break;  //16-Mar-2021*/
        }
            
        //PrintWriter out=response.getWriter();
        //out.println("Welcome by QuizServlet");
    }
    //10-Apr-2021 Coding of UDF-logout
       private void logout(HttpServletRequest request, HttpServletResponse response)    throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        session.removeAttribute("qb"); //sb contains userid,password, usertype
        session.invalidate();  //Make this session invalid
        response.sendRedirect("login.html");
       }
    //Step 111: 24-Mar-2021 Coding of showQuestion
     private void showQuestion(HttpServletRequest request, HttpServletResponse response)    throws ServletException, IOException {
         //(b) Obtain Current session of User [false - don't create new session]
        HttpSession session=request.getSession(false);
        ArrayList<QuestionBean>al=(ArrayList<QuestionBean>)session.getAttribute("al");
        String idx=session.getAttribute("index").toString();
        int index=Integer.parseInt(idx);  //Convert to int
        PrintWriter out=response.getWriter(); 
         String button=request.getParameter("button");
         //out.print("button is " + button);
          if(button==null){
            //  System.out.println("null index=" + index );
              out.print(al.get(index).toString() + "," +index);
              return ;
          }
          //Otherwise
          int maxQuestions=Integer.valueOf(session.getAttribute("maxQuestions").toString());
          String opted=request.getParameter("opted");
          al.get(index).setOpted(opted);
         //(e) Now, we have to decide value for next index
         if(button.equals("Next")){
             if(index<maxQuestions-1)
                index++;
             //else 
            //    index=maxQuestions-1;  //Last Question
         }
         else if(button.equals("Previous")){
             if(index>0)  //Not on First Question
                index--;     //Decrement by 1
             //else 
             //    index=0;  //First Question
         }
         else if(button.equals("Finish")){
             //Means client like to end the exam
             index=-1;  //Invalid Index to disable all other buttons
             session.setAttribute("index", index);
             endExam(request,response); //28-Mar-2021 -UDF   
         }
         else{  //Clicked on Button [Q1] [Q2]....[QN]
             int n=Integer.parseInt(button.substring(1)); //Leave index 0 means
             index=n-1;
         }
         //finally put values back into session
         if(!button.equals("Finish")){
         session.setAttribute("index", index);
         out.print(al.get(index).toString() + "," +index + "," +al.get(index).getOpted());
         System.out.println("Latest Index-" +index); 
         }
     }
     //05-Apr-2021 Step 133
     private void endExam(HttpServletRequest request, HttpServletResponse response)    throws ServletException, IOException {
         //(a) Obtain existing session (statefult state)
        HttpSession session = request.getSession(false);
        //(b) means someone is bypassing
        if (session == null) {  //Means Session Not Found
            response.sendRedirect("login.html");
            return;  //Terminate Code
        }
        //(c) Otherwise fetch Userid, Category and ArrayList from Session
        QuizUserBean qb = (QuizUserBean) session.getAttribute("qb");
        String userid = qb.getUserid(); //means who gives the exam
        //Converting Object to String and then obtaining its int Value using valueOf
        int maxQuestions=Integer.valueOf(session.getAttribute("maxQuestions").toString());
        //Of what category
        String category = (String) session.getAttribute("category");
        //and what questions are given to candidate
        ArrayList<QuestionBean> al = (ArrayList<QuestionBean>) session.getAttribute("al");
        //Now use M:Model -QuestionBean to compute Result [Business Logic]
        //By passing who:userid what:category  quesions list: al 
        //it return examid on completion
        int examid = QuestionBean.calculate(userid, category, al,maxQuestions); //Fn Call [Abstraction] 
        PrintWriter out = response.getWriter();
        //Step III: 
        //Special Value -1 for Database Failure
        if (examid == -1) {
            out.println("Some, error occured at Database End. Contact With DB Administrator");
        } else if (examid < -1) { //Means failed
            out.println("Sorry!! You are failed in Exam");
            out.println("<br/>You Exam Id is<b> " + Math.abs(examid) + "</b>");
            out.println("<br/>Better Luck Next Time");
            out.println("<a href='login.html'>Login Again and Retry</a>");
        } else {    //Means Passed the exam
            String msg = String.format("Congrates!! You've passed the Exam. Your Exam Id is %d ", examid);
            out.println(msg);
            msg = String.format("<a href='result.jsp?userid=%s&examid=%d'>Show Result</a>", userid, examid);
            out.println(msg);
            out.flush();
        }
    }
        // response.sendRedirect("result.jsp");
        //PrintWriter out=response.getWriter();
        //response.setContentType("text/html");
        //out.println("<a href='result.jsp'>Show Result</a>");
     
    //Step 100: 23-Mar-2021 Definition of searchQuestions
     private void searchQuestions(HttpServletRequest request, HttpServletResponse response)    throws ServletException, IOException {
         //(a) Collect data from query Strng
         String field=request.getParameter("field");
         String operator=request.getParameter("operator");
         String value=request.getParameter("value");
         
         PrintWriter out=response.getWriter();
        //(b) Debugging purpose, display them back        
        //out.println(field + "," + operator + "," + value);
        //(c) Generate SQL select Query
        String sql=String.format("Select * from question where %s %s '%s'", field, operator, value);
        //out.print("Query=" + sql);
        //(d) Using DatabaseBean execute Query and store result in ResultSet
         ResultSet rs = null;
        try {
            rs = DatabaseBean.executeQuery(sql);
            //(e) If data found convert it into html <table>
            if (rs.next()) { //true when Data Found
                rs.previous(); //Move Back to First Row 
                String table = rsToTable(rs);  //Step 101 UDF to convert ResultSet to <table>
                out.print(table); //return back to success: fn of jQuery
                out.flush();
            } else { //No data found
                out.print("Sorry!! No Row Found");
                out.flush();
            }
        } catch (Exception e) {
            out.print("[searchQuestion] " + e.toString());
            e.printStackTrace();
        }
    }
    //Step 101-23-Mar-2021 Definition of UDF- rsToTable
       private String rsToTable(ResultSet rs) throws SQLException {
       //(a) StringBuilder - Mutable (Fast)
       StringBuilder sb = new StringBuilder(2 * 1024); //approx 2KB
        //(b) append (add to the end of buffer)
        //<table> tag of html
        sb.append("<table border='1' width='100%'>");
        //1st row is heading row
        sb.append("<thead>");
        sb.append("<td>Qid</td>");
        sb.append("<td>Question</td>");
        sb.append("<td>Category</td>");
        sb.append("<td>Option1</td>");
        sb.append("<td>Option2</td>");
        sb.append("<td>Option3</td>");
        sb.append("<td>Option4</td>");
        sb.append("<td>Answer</td>");
        sb.append("</thead>");
        //(c) For remaining rows perform loop till rs.next() true
        while (rs.next()) {
            //(d) Add new row to the <table>
            sb.append("<tr>");
            //(e)Now create Columns
            sb.append(String.format("<td>%d</td>", rs.getInt("qid")));
            sb.append(String.format("<td>%s</td>", rs.getString("question")));
            sb.append(String.format("<td>%s</td>", rs.getString("category")));
            sb.append(String.format("<td>%s</td>", rs.getString("option1")));
            sb.append(String.format("<td>%s</td>", rs.getString("option2")));
            sb.append(String.format("<td>%s</td>", rs.getString("option3")));
            sb.append(String.format("<td>%s</td>", rs.getString("option4")));
            sb.append(String.format("<td>%s</td>", rs.getString("answer")));         
            //(f) End of current row
            sb.append("</tr>");
        }
        //(g) When loop ends close table tag
        sb.append("</table>");
        //(h) return back StringBuilder as String to success: fn of JQuery
        return sb.toString(); //Return back table as a String
    }
    //Step 93: Defining UDF findQid
    private void findQid(HttpServletRequest request, HttpServletResponse response)    throws ServletException, IOException {
        String qid = request.getParameter("qid");
        PrintWriter out = response.getWriter();
        response.setContentType("text/plain");
        //out.println("Qid Inside findQuestion" + qid);
        QuestionBean qb = new QuestionBean();
        if (qb.select(qid) == null) {
            out.println("-1");
            out.flush();
            return;
        }
        out.println(qb.toString());
        out.flush(); 
    }
    
  

    //Step 88: Defining UDF navigation -18-Mar-2021
     private void navigation(HttpServletRequest request, HttpServletResponse response)    throws ServletException, IOException {
         //Step (a) Obtain index 
         String choice=request.getParameter("choice");
         //Obtain session details of current user
         HttpSession session=request.getSession(false);
         int index=Integer.parseInt(session.getAttribute("index").toString());
         ArrayList<QuestionBean>al=(ArrayList)session.getAttribute("al");
         switch(choice){
             case "1": index=0; break;//First
             case "2":  //Previous
                 --index;
                 if(index<0) index=al.size()-1; //Cycle back to last
                 break;
             case "3": //Next 
                 ++index;
                 if(index==al.size()) index=0; //Cycle back to first
                 break;
             case "4": index=al.size()-1;break;//Last
         }
         session.setAttribute("index" , index); //Update index in session
         QuestionBean q=al.get(index); //Obtain question of current index
         PrintWriter out=response.getWriter();
         out.print(q.toString());
     }
//Step 79-16-Mar-2021   [Step 81 - 18-Mar-2021 Improved Code] 
    private void saveQuestion(HttpServletRequest request, HttpServletResponse response)    throws ServletException, IOException {
        //Obtain sql query sent by ajax
        String sql=request.getParameter("sql");
        //String sql="All is Well";
        //Debugging Purpose -16-Mar-2021
        PrintWriter out=response.getWriter();
       // out.println("Query received by Servlet=" + sql);
        //New Logic on 18-Mar-2021  -Step 81
        int rowsAffected=0;
        try{
        rowsAffected=DatabaseBean.executeUpdate(sql); 
        if(rowsAffected>0) //means row inserted or update successfully
            DatabaseBean.commit(); //Save Rows Permanently
            //Step 103 - 24-Mar-2021 Refreshing ArrayList of Questions
            //(a) load Questions of all categories without shuffle
            ArrayList<QuestionBean>al=QuestionBean.loadQuestions(null, false);
            //(b) Obtain session of current session
            HttpSession session=request.getSession(false);
            //(c) Store ArrayList into session variable
            session.setAttribute("al", al);
            out.print("Row Saved Successfully"); //return back to success fn of jQuery
        }
        catch(Exception se){
            out.print("Sorry. Failed to Save Record");
            System.out.println("Exception in saveQuestion: " + se.toString());
            se.printStackTrace();
        }
    }
//Step 58 11-Mar-2021  (Step 106-24-Mar-2021)
     private void startExam(HttpServletRequest request, HttpServletResponse response)    throws ServletException, IOException {
         PrintWriter out=response.getWriter();
         response.setContentType("text/html");
         //out.println("Welcome, Your exam started now " + request.getParameter("category"));
         //(a) Obtain category choosen from combobox in welcome.jsp
         String category=request.getParameter("category");
         //(b) Now create ArrayList<QuestionBean> of given category, true=>shuffled
         ArrayList<QuestionBean>al=QuestionBean.loadQuestions(category, true);
         //(c) Check if no questions found (size 0)
         if(al.size()==0){
             out.println("Sorry!!! No Question Found for Category "+ category);
             out.println("<input type=button value=Back onClick='history.back()'/>");
             return;  //Terminate Fn
         }
         //Otherwise
         //(d) Obtain current session of user, false=>do not create new session
         HttpSession session=request.getSession(false);
         //(e) Store arraylist into session
         session.setAttribute("al", al);
         session.setAttribute("maxQuestions", 5);
         //(f) Set current question index to 0
         session.setAttribute("index" , 0);
         session.setAttribute("category", category); //05-Apr-2021
         //(g) Redirect user to startexam.jsp page
         response.sendRedirect("startexam.jsp");
     }
    //4-Mar-2021 Step 36
    private void registerUser(HttpServletRequest request, HttpServletResponse response)    throws ServletException, IOException {
	//PrintWriter out=response.getWriter();   //(*1)
 	//out.println("Inside registerUser");  //Debugging
        //(a) Collect form data
        String u=request.getParameter("userid"); //name property of <input>
        String p=request.getParameter("password");
        String q=request.getParameter("question"); //Case-Sensitive
        String a=request.getParameter("answer");
        PrintWriter out=response.getWriter();  //Debugging first
        //out.printf("%s  %s  %s %s " , u,p,q,a);
        //(b) Create instance of QuizUserBean
        QuizUserBean qb=new QuizUserBean(u,p,q,a);  //Step 37
        //New logic added on 09-Mar-2021 (Step 42)
         if(qb.exists(false))  //means only check userid and do not check password
        {
            response.sendRedirect("register_forgotten.jsp?op=2&msg='Sorry, Userid already in Use' ");
          return ;
         }
        //(c) Call insert fn of QuizUserBean class
        boolean success=qb.insert();  //Step 38
        if(success){  //if(success==true)
            //(d) Maintain state of current user using Cookie and Session
            Cookie c=new Cookie("qb" , qb.toString()); //key,string
            c.setMaxAge(24*60*60); //1 day          
            HttpSession session=request.getSession(true); //Interview 
            session.setAttribute("qb", qb); //key, object
            response.sendRedirect("welcome.jsp");
        }
        else{  //(e) 
            out.println("<b>Sorry. Unable to register User. Try Again");
            out.println("<input type='button' value='back' onclick='history.back()'/>");
        }
}
//Step 44: Dated 09-Mar-2021
private void forgottenPassword(HttpServletRequest request, HttpServletResponse response)    throws ServletException, IOException {
	//PrintWriter out=response.getWriter();
 	//out.println("Inside forgottenPassword");  //Debugging
         //(a) Collect form data
        String u=request.getParameter("userid"); //name property of <input>
        String p=request.getParameter("password"); //means new password required
        String q=request.getParameter("question"); //Case-Sensitive
        String a=request.getParameter("answer");
        //(b) Create instance of QuizUserBean [M:Model]
        QuizUserBean qb=new QuizUserBean(u,p,q,a);  //Step 37
        //Check if userid exists, if not return back to register_forgotten
        if(!qb.exists(false))  //Means userid NOT exists
        {                       //Send back
          response.sendRedirect("register_forgotten.jsp?op=3&msg=Sorry, Userid Not Found ");
          return ;
        }
        //Otherwise, use setter fn to pass question and answer provided by user via the form
         qb.setQuestion(q); qb.setAnswer(a); //Bug Removed Using this Line
         boolean success=qb.update();  //M:Model -
         if(success){  //means password updated 
            //(d) Maintain state of current user using Cookie and Session
            Cookie c=new Cookie("qb" , qb.toString()); //key,string
            c.setMaxAge(24*60*60); //1 day          
            HttpSession session=request.getSession(true); //Interview 
            session.setAttribute("qb", qb); //key, object
            response.sendRedirect("welcome.jsp");
        }
        else{  //(e) 
            response.sendRedirect("register_forgotten.jsp?op=3&msg=sorry!!! atleast userid/question/answer mismatched");
        }
}
    //Step XXI : Coding of UDF  - verifyUser -27-Feb-2021
    //private - So that it can be called internally from within
    //another fn of the class but not from outside the class
    private void verifyUser(HttpServletRequest request, HttpServletResponse response )throws ServletException, IOException{
        //XXI (a) fetch name="userid" and name="password" from form
        String userid=request.getParameter("userid");
        String password=request.getParameter("password");
        //XXI (b) Check if it is null, redirect back to login.html
        if(userid==null || password==null){
            response.sendRedirect("login.html");
            return;
        }
        //(c) Otherwise display userid/password (Debugging only)
        //PrintWriter out=response.getWriter();
       // out.printf("Userid=%s and Password=%s" , userid, password);
        //(d) Now use M:Model to verify userid exists or not
        //Wrong way - writing that logic directly inside Servlet
        QuizUserBean qb=new QuizUserBean(userid,password); //Calls PC
        //(e) Call exists() fn of QuizUserBean
        if(qb.exists()){ //Abstraction Principle
            //Stateful state - Save data between pages
            Cookie c=new Cookie("qb" , qb.toString()); //key,string
            c.setMaxAge(24*60*60); //1 day
            //true in session means: create new session if not exist
            //if we pass false, it means - do not create a new session if not found
            HttpSession session=request.getSession(true); //Interview 
            session.setAttribute("qb", qb); //key, object
            
            //Step 84-18-Mar-2021 Additional logic for admin user
            if(qb.getUsertype().equals("A")){
                //null=>all category   false=>no shuffling
                ArrayList<QuestionBean>al=QuestionBean.loadQuestions(null, false);
                session.setAttribute("al", al); //key, value
                session.setAttribute("index", 0); //index for ArrayList
            }
            response.sendRedirect("welcome.jsp");
        }
        else{
            response.sendRedirect("login.html");
        }
    }
    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
