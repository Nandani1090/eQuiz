<%-- 
    Document   : welcome
    Created on : 27 Feb, 2021, 9:10:18 PM
    Author     : Bhupendra
--%>
<%--Step (a) make session true and import required class--%>
<%@page contentType="text/html" session="true" 
        import="com.tecdev.QuizUserBean" pageEncoding="UTF-8"%>
<%--Step 56: Adding JSTL Libraries to use - 11-Mar-2021--%>
<%@taglib  prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib  prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!--Specifying Favorite Icon 16x16px for our page that appears in title bar of browser-->
    <link rel="icon" href="images/favicon1.ico">
    <title>Welcome in eQuiz</title>
    <!-- Bootstrap core CSS -->
    <link rel="stylesheet" href="css/bootstrap.min.css" >
  
    <!-- Custom styles for login page -->
    <%--<link rel="stylesheet"  href="css/login.css" >--%>
  </head>
    <body>
        <%--(b) Obtain bean with id qb from current Session object --%>
        <jsp:useBean id="qb" scope="session" class="com.tecdev.QuizUserBean" />
        <div class="container">
        <div class="well text-center text-danger">
            <h2>Hello <b><u>${qb.userid}</u></b> <br/> Welcome in eQuiz.   </h2>   
            <a href="QuizServlet?op=10">Logout</a>
        </div>
        <%--Step 57: Decision making without JSTL, using JSP Scriplet Tag
        <%
            if(qb.getUsertype().equals("A"))
            {
                out.println("<a href=questions.jsp>Manage Questions Database</a>");
            }
        %>--%>
        <%--OR Better Way is to use JSTL Core Tag--%>
        <c:if test="${qb.usertype eq 'A' }">
            <a href="questions.jsp">Manage Questions Database</a>
        </c:if>
        <%--Logic for Candidate User - Display category for Exam--%>
        
        <c:if test="${qb.usertype eq 'C' }">
            <%--Obtain database connection using Context.xml--%>
            <sql:setDataSource dataSource="jdbc/myora"  var="db"/>
            <%--Select query to fetch rows from categories table--%>
            <c:set var="sql"  scope="page"
            value="select * from categories order by category"/>
            <%--Execute the Query using sql:query tag, store result in rs variable--%>
            <%--Without JSTL Logic
            <%
                ResultSet rs=DatabaseBean.executeQuery(sql);
                while(rs.next()){
                    out.println("<option value=" + rs.getString("category") +">" + rs.getString("category_details"));
                }
            %>
            --%>
            <%--Same using Using JSTL Logic--%>
            <sql:query  dataSource="${db}" var="rs"  >
                              ${sql}     
            </sql:query> 
            <%--Display category select from table in form of combobox--%>
             <form method="post" action="QuizServlet?op=4">
            <div class="col-xs-3 col-xs-offset-3">
               <%--Select tag can be used to create drop-down list--%>
             <select id="category" name="category" class="form-control" >
                 <c:forEach  items="${rs.rows}"  var="i">
                     <option value="${i.category}">${i.category_details}</option>
                  </c:forEach>
             </select>
             </div>
              <div class="col-xs-3 text-left">
                <div class="form-group">
                <input type="submit" value="Start" class="btn btn-primary"/>
                </div>  
              </div>
            </form>
        </c:if>    
        </div>
         <script src="script/jquery-3.5.1.min.js"></script>
         <script src="script/bootstrap.js"></script>
    </body>
</html>
