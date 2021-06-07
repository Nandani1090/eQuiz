<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!--Specifying Favorite Icon 16x16px for our page that appears in title bar of browser-->
    <link rel="icon" href="images/favicon1.ico">
    <title>eQuiz Login</title>
    <!-- Bootstrap core CSS -->
    <link rel="stylesheet" href="css/bootstrap.min.css" >
  
    <!-- Custom styles for login page -->
    <link rel="stylesheet"  href="css/login.css" >
  </head>
  <body>
    <div class="container">
        <%--Step 41, 09-Mar-2021--%>
         <div class="well well-lg text-danger">
             <label id="msg" class="col-xs-offset-3 col-xs-6 text-center">
                 ${not empty param.msg?param.msg:""}
             </label>                        
         </div>       
      <form class="form-signin" action="QuizServlet" method="post">
        <h2 class="form-signin-heading">Register/Forgotten Password</h2>
        <label for="userid" class="sr-only">User Id</label>
        <input type="text" name="userid" id="userid" class="form-control" placeholder="Type Userid" required autofocus>
        <label for="password" class="sr-only">New Password</label>
        <input type="password" name="password" id="password" class="form-control" placeholder="New Password" required>
          <select id="question" name="question" class="form-control">
              <option value="Your favourite dish">Your favourite dish?</option>
              <option value="your favourite color">your favourite color?</option> 
              <option value="your first school">your first school?</option>
                                    
          </select>
        <input type="text" name="answer" id="answer" class="form-control" placeholder="Type answer here" required>
        <button class="btn btn-lg btn-primary btn-block" type="submit">Submit</button>
        <input type="hidden" name="op" value="${param.op}"/>
      </form>
    </div> <!-- /container -->
</body></html>