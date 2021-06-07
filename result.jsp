<%@page contentType="text/html" pageEncoding="UTF-8"
        session="true"
        errorPage="error.jsp"
        %>
<%@taglib  prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib  prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta charset="UTF-8">
        <!--Backward compatible with Internet Explorer 8.0-->
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <!--Responsive Apps, Size adjusted as per device size-->
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <!--Add Bootstrap CSS Before any other custom css -->
        <link rel="stylesheet" type="text/css" href="css/bootstrap.css" />
        </script>
        <title>eQuiz Certificate</title>
    </head>
    <body>
        <c:set var="userid" value="${param.userid}" scope="page" />
        <c:set var="examid" value="${param.examid}" scope="page" />
        <%--Use Data Source name specified in Context.xml--%>
        <sql:setDataSource dataSource="jdbc/myora" var="db" />
        <c:set var="sql" value="Select quiz_users.userid, dated, category from quiz_users, exam where quiz_users.userid=exam.userid and examid='${examid}'" scope="page"/>
        <%-- SQL=${sql}--%>
        <%--Execute the Query and Store ResultSet into variable rs--%>
        <sql:query  dataSource="${db}" var="rs"  >
            ${sql}     
        </sql:query>  
        <%--We've single row - So loop executes once --%>
        <c:forEach var="i" items="${rs.rows}">
            <%--Store row data into variables for future use--%>
            <c:set var="name" value="${i.userid}" scope="page"/>
            <c:set var="dated" value="${i.dated}" scope="page"/>
            <c:set var="category" value="${i.category}" scope="page"/>
        </c:forEach>
        <%--Now using Basic HTML Tags to display above data
        as per the requirement mentioned by the Boss--%>
        <div class="container">
            <div class="panel panel-primary">
                <div class="panel-heading">
                    <%--Placing media tag to display image--%>
                    <div class="media">
                        <a class="pull-right" target="tab" href="">
                            <img class="media-object" src="images/logo.png" alt="text" />    
                        </a>
                        <div class="media-body">
                            <h1 class="media-heading text-center">Technology Developer's</h1>
                            <p class="text-center">Making Way Towards Technology</p>
                        </div>    
                    </div>

                </div>
                    <div class="panel-body text-left">
                        <h2>Name: <u>${name}</u></h2> <br/>
                        <h3>On Successful Completion of Exam on <mark>${category}</mark> technology </h3>                      
                        <h3>Dated: <u>
                                <%--${dated}--%>
                          <fmt:formatDate  pattern = "dd-MMM-yyyy" value = "${dated}" />
                            </u></h3> 
                        
                    </div>
            </div><div class="panel-footer text-right">
                <h3><b>Signature</b></h3>
                
            </div>
                        <input class="col-xs-3 col-xs-offset-3 btn btn-primary" type="button" value="Print" onclick="window.print();"/>
                        <a href="QuizServlet?op=10" class="col-xs-3 btn btn-default">Logout Now</a>
        </div>
        <script src="script/jquery-3.5.1.min.js"></script>
        <script src="script/bootstrap.min.js"></script>
    </body>
</html>
