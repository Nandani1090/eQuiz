<%@page contentType="text/html" pageEncoding="UTF-8"
        import="com.tecdev.QuestionBean, com.tecdev.QuizUserBean, 
        java.util.*"
        session="true"
        errorPage="error.jsp"
        %>
<%--To work with JSTL Step I is to import them using taglib direction--%>
<%@taglib  prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib  prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>

<!DOCTYPE html>
<html>
    <title>Bootstrap Example</title>
    <meta charset="UTF-8">
    <!--Backward compatible with Internet Explorer 8.0-->
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <!--Responsive Apps, Size adjusted as per device size-->
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <!--Add Bootstrap CSS Before any other custom css -->
    <link rel="stylesheet" type="text/css" href="css/bootstrap.css" /> 
    <body>
        <div class="container">
            <%--(a) Obtain value of index from session--%>
            <c:set var="index" scope="session" value="${sessionScope.index}"/>
            <%--(b) If hacker is trying to bypass project, in that case index not found--%>
            <c:if test="${empty index}">
                <%--(c) Send it back to the login.html page--%>
                <jsp:forward page="login.html" />
            </c:if>
            <%--(d) Obtain question with current index from arraylist al into variable q--%>
            <c:set var="q" scope="session" value="${sessionScope.al.get(index)}" /> 
            <%--(e) Otherwise create a page header to display welcome userid--%>
            <div class="page-header">
                <h1>Welcome <c:out value="${sessionScope.qb.userid}"/> </h1>
            </div>
                <%--f. get value of variable maxQuestions from session--%>
                <c:set var="maxQuestions" scope="session" value="${sessionScope.maxQuestions}" />
                <input type="hidden" id="max" value="${maxQuestions}" />
                <%--g. Create a bootstrap panel for UI - User Interface--%>
                <div class="panel panel-primary">
                    <div class="panel-heading">
                        <%-- Q${qno+1} <label id="qq">${qno}</label>--%>
                        Q.No:<label id="qIndex">${index+1}</label>
                    </div>
                    <div class="panel-body">

                        <p><label id="question">${q.question}</label> </p> <%--Automatically calls getQuestion()--%>
                        <%--Display options in the form of Checkboxes--%>

                        <p><input type="checkbox" name="option" id="option1" value="1" ${(q.getOpted().indexOf("1")>=0) ? "checked":" "}/> <label id="op1">${q.option1}</label></p>
                        <p><input type="checkbox" name="option" id="option2" value="2" ${(q.getOpted().indexOf("2")>=0) ? "checked":" "}/> <label id="op2">${q.option2}</label></p>
                        <p><input type="checkbox" name="option" id="option3" value="3" ${(q.getOpted().indexOf("3")>=0) ? "checked":" "}/> <label id="op3">${q.option3}</label></p>
                        <p><input type="checkbox" name="option" id="option4" value="4" ${(q.getOpted().indexOf("4")>=0) ? "checked":" "}/> <label id="op4">${q.option4}</label></p>


                    </div>
                    <div class="panel-footer">
                        <%--<input type="hidden" id="oldqno" name="oldqno" value="${qno}" />--%>
                        <input type="button" value="Previous" id="previous" style="visibility: ${index>0 ? "visible": "hidden"};" class="btn btn-primary"/>                  
                        <input type="button" value="Next"  id="next" style="visibility: ${index<maxQuestions-1? "visible": "hidden"};" class="btn btn-primary"/>                  
                        <input type="button" value="Finish" id="finish" style="visibility: ${index==maxQuestions-1? "visible": "hidden"};"  class="btn btn-primary"/>                 


                        <%--(h) JSTL Displaying buttons at runtime for direct access of each question  --%>
                        <c:forEach var="i" begin="0" end="${maxQuestions-1}" step="1">
                            <c:set var="x" value="${sessionScope.al.get(i).opted}"
                                   scope="page" />
                            <input type="button"  id="btn${i}" 
                                   value="Q${i+1}" ${i eq index ?'disabled':' ' } 
                        style="background-color:
                        ${x eq '99' ?'grey':(x.length()>0?'green':'red')}"  />
                        </c:forEach>
                    </div> <%--End of Panel-Footer--%>
                    <%--JQuery use this id to get opted value of current question--%>
                    <input type="hidden" id="temp" name="temp" value="${q.opted}" />                   
  <%--Step 131 05-Apr-2021--%>               
  <div id="resultdiv"></div>                    
                </div>
                
            </div>
      
        <script src="script/jquery-3.5.1.min.js"></script>
        <script src="script/bootstrap.js"></script>
        <%--Our Custom code logic comes here--%>
        <script>
            //(a)31-Mar-2021 first event document.ready
            $(document).ready(function () {
                //(b) Registering click event on all input type='button', event sharing and passing current object (this)
                $("input[type='button']").click(function () {
                    navigationClick(this, $(this).val()); //this=>Current Object, Its Value
                });
             });
             //(b) 31-Mar-2021 Coding of UDF - To handle button events
               function navigationClick(btn, value) {
                //   (c) UDF to check which checkboxes are checked
                checkSelected(); //31-Mar-2021
                var opted = $("#temp").val();
                //(d) Generate QueryString for ajax/Servlet - Passing op,
                // opted value for current question
                //and which button is pressed
                var myurl = "QuizServlet?op=9&opted=" + opted + "&button=" + value;
                $.ajax({
                    url: myurl,
                    async: false,
                    type: 'POST', //success fn execute when servlet call ends
                    success: function (data) {  //Get data from Servlet
                         if(value=="Finish")
                        {
                            $("#resultdiv").html(data);
                            disableButtons(); //UDF-05-Apr-2021
                            return;
                        }
                        //Otherwise
                        arrayToText(data); //UDF
                        updateButtons(); //UDF
                    },
                    error: function (jqXHR, exception) {
                        console.log('arrayToText Exception ' + exception);
                    }
                });
            }
            //Step 133 05-Apr-2021
             function disableButtons(){
                $btn=$("input[type='button']");
                $btn.each(function () {
                         //$(this).prop("disabled" , "true");
             $(this).css("visibility" , "hidden");
                });
            }
            function checkSelected() {  //31-Mar-2021 Selected Checkboxes
                var opted = "";  //(a) local variable initialize to empty String
                var $checkedboxes = $('input[name=option]:checked');
                //(b) JQuery forEach loop to check value of checked checkbox
                $checkedboxes.each(function () {
                    opted += $(this).val();
                });
                //(c) Send value of opted back to hidden field id="temp"
                $("#temp").val(opted);
                //(d) Update color based on opted=>99:grey ==0: red else green
                var color = (opted == "99" ? 'grey' : opted.length == 0 ? 'red' : 'green');
                 //(e) Generate current index by subtracting 1 from current qIndex (Q.No)
                var index = $("#qIndex").text() - 1;
                var btn = "#btn" + index;  // # is need for id
                //Change css property using jQuery
                $(btn).css('background-color', color);
            }
           
            //31-Mar-2021 
            function updateButtons() {
                var index = $("#qIndex").text() - 1;
                var btn = "#btn" + index;  // # is need for id
                //Change css property using jQuery
               // $(btn).css('background-color', color);
                //Activating Navigation Buttons
                var max = $("#max").val();
                alert("index=" + index + " max=" + max);
                $("#previous").css("visibility", "hidden");
                $("#next").css("visibility", "hidden");
                $("#finish").css("visibility", "hidden");
                if (index == 0)
                    $("#next").css("visibility", "visible");
                else if (index < max - 1) {
                    $("#next").css("visibility", "visible");
                    $("#previous").css("visibility", "visible");
                } else if (index == max - 1) {
                    $("#finish").css("visibility", "visible");
                    $("#previous").css("visibility", "visible");
                }
            }
            //26-Mar-2021
            function arrayToText(data) {
                var array = data.split(",");
                // alert("inside arrau");
                $("#question").text(array[1]);
                $("#op1").text(array[3]);
                $("#op2").text(array[4]);
                $("#op3").text(array[5]);
                $("#op4").text(array[6]);
                $("#qIndex").text(new Number(array[8]) + 1);  //index
                var opted=new String(array[9]);  //opted
                $("#option1").prop("checked", opted.indexOf("1")>-1);
                $("#option2").prop("checked", opted.indexOf("2")>-1);
                $("#option3").prop("checked", opted.indexOf("3")>-1);
                $("#option4").prop("checked", opted.indexOf("4")>-1);
            }
            function switchPage(link) {
                //alert("Switch Page");
                //Obtain current time from hidden field time
                var timer = $("#time").val();
                //Obtain Hyperlink from parameter passed to this fn
                var href = $(link).attr("href");
                //Append current time with hyperlink
                href += "?time=" + timer;
                //Update href attribute
                $(link).attr("href", href);
                //alert("Time=" + timer + " Href=" + href);
                //If return false, hyperlink not fn
                return true; //means now redirect to the link
            }
        </script>
    </body>
</html>
