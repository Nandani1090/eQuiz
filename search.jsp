<%@page contentType="text/html"
        pageEncoding="UTF-8"
        errorPage="error.jsp"  
        %>
<%@taglib  prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <title>eExam App-Search Page</title>
        <meta charset="UTF-8">
        <!--Backward compatible with Internet Explorer 8.0-->
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <!--Responsive Apps, Size adjusted as per device size-->
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <!--Add Bootstrap CSS Before any other custom css -->
        <link rel="stylesheet" type="text/css" href="css/bootstrap.css" />
        <!-- Linking css File with html -->
        <link rel="stylesheet" type="text/css" href="css/style1.css"/>
    </head>
    <body>
        <div class="container">
            <c:set var="msg" scope="session" value="${sessionScope.msg}" />
            <div class="well well-sm text-center" id="msg">${empty msg?"Welcome in eExam":msg}</div>
            <div class="row">
                

                <div class="form-group">
                    <%--1st row only contains Label--%>
                    <div class="col-xs-3 text-center"> <label for="field">Select Field</label></div>
                    <div class="col-xs-3 text-center"> <label for="operator">Operator</label></div>
                    <div class="col-xs-3 text-center"> <label for="value">Value</label></div>
                    <div class="col-xs-3 text-center"> <label>&nbsp;</label></div>
                </div>
                <div class="form-group">
                    <div class="col-xs-3">
                        <select name="field" id="field" class="form-control">
                            <option value="category" selected>Category</option>
                            <option value="qid">Qid</option>
                            <option value="question">Question</option>
                            <option value="option1">Option1</option>
                            <option value="option2">Option2</option>
                            <option value="option3">Option3</option>
                            <option value="option4">Option4</option>
                            <option value="answer">Answer</option>
                           
                        </select>
                    </div>
                    <div class="col-xs-3">
                        <select name="operator" id="operator" class="form-control">
                            <option value="=" selected>=</option>
                            <option value="!=">!=</option>
                            <option value="<">&lt;</option>
                            <option value="<=">&lt;=</option>
                            <option value=">">&gt;</option>
                            <option value=">=">&gt;=</option>          
                        </select>
                    </div>                          
                    <div class="col-xs-3">
                        <input type="text" class="form-control" id="value" name="value"/>
                    </div>
                    <div class="col-xs-3">
                        <input class="form-control btn btn-primary" name="search" id="search" type="button" value="Search Now" />
                    </div>                                        
                </div>
                    <div class="col-xs-12 text-center" id="result">
                        <h1>Result Appears Here</h1>
                </div>
                <div class="col-xs-3 col-xs-offset-9">
                    <input class="form-control btn btn-primary" name="print" id="print" type="button" value="Print" onclick="window.print();" />
                </div>
            </div>   
</div>
<script src="script/jquery-3.5.1.min.js"></script>
<script src="script/bootstrap.min.js"></script>
<script>
    //Below Fn called only when DOM is Ready
    jQuery(document).ready(
            function () {
                //Register Click Event on [Add] 
                $("#search").on('click', searchClick);  
                //function searchClick(){ alert("all is well");}
            }); //End of ready fn 
            
            //Step 98 - 23-Mar-2021
    function searchClick(n) {
        //(a)Collect data from GUI
        var f=$("#field").val();
        var op=$("#operator").val();
        var v=$("#value").val();
        //Syntax of QueryString ?var1=val1&var2=val2&varN=valN
        //(b) Generate QueryString
        var queryString="field=" + f + "&operator=" + op + "&value=" + v;
        //alert(queryString);
        //(c) Concate QueryString with URL
        var myurl = "QuizServlet?op=8&" + queryString;
        //alert(myurl);
        //(d) Using ajax communicate with servlet
        $.ajax({
            url: myurl,
            async: true,
            type: 'POST',
            //(e) Display data at the end of call [Callback] - Interview
            success: function (data) {  //Get data from Servlet
                $("#result").html(data); //Means show Table inside Div
            },
            error: function (jqXHR, exception) {
                console.log('arrayToText Exception ' + excepttion);
            }
        });
    }
    
</script>
</body>
</html>
