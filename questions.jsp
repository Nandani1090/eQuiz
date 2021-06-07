<%@page contentType="text/html"
        import="java.sql.*, com.tecdev.*"
        pageEncoding="UTF-8"
        session="true"
        errorPage="error.jsp"  
        %>
<%@taglib  prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
    <head>
        <title>eExam App-Questions Page</title>
        <meta charset="UTF-8">
        <!--Backward compatible with Internet Explorer 8.0-->
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <!--Responsive Apps, Size adjusted as per device size-->
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <!--Add Bootstrap CSS Before any other custom css -->
        <link rel="stylesheet" type="text/css" href="css/bootstrap.css" />
        <!-- Linking css File with html 
        <link rel="stylesheet" type="text/css" href="css/style1.css"/>-->
    </head>
    <body>
        <div class="container">
           
            <c:set var="msg" scope="session" value="${sessionScope.msg}" />
            <div class="well well-sm text-center" id="msg">${empty msg?"Welcome in eExam":msg}</div>
            <%--18-Sep-2020--%>
            <div class="well well-sm text-right">
              <%--  <%@include  file="top.txt" %>
                <jsp:include page="top.txt" />--%>
            </div>
            <c:if test="${not empty msg}">
                <c:remove var="msg" scope="session"/> <%--Semaphore--%>
            </c:if>          
            <div class="row">
                <div class="panel panel-primary">
                    <form id="form1" class="form" method="post" action="QuizServlet?op=5">
                        <div class="panel-heading text-center">
                            <h2>Questions Entry</h2>
                        </div>             
                        <div class="panel-body">
                            <%--Designing Row 1 for Category Label, ComboBox and add button--%>
                            <div class="form-group">
                                <div class="col-xs-3 text-right"> <label for="category">Category</label></div>
                                <div class="col-xs-6">
                                    <select name="category" class="form-control" id="category">
                                        <%
                                           ResultSet rs = DatabaseBean.executeQuery("select * from categories order by category");
                                           String value = "";
                                            String text = "" ,tag="";
                                            while (rs.next()) {       //Gives true till row found
                                                value = rs.getString("category");
                                                text=rs.getString("category_details");		
                                                tag= String.format("<option value='%s'>%s</option>", value, text);
                                                out.print(tag);
                                            }
                                        %>
                                    </select>
                                </div>
                                <div class="col-xs-3">
                                    <input class="form-control btn btn-primary" name="submit" id="add" type="button" value="Add" /></div>                                        
                            </div>
                                    <%--Row 2, Label, Text for Qid and [Edit] Button--%>
                            <div class="form-group">
                                <div class="col-xs-3 text-right"><label for="qid">Question Id [Read Only]</label></div>
                                <div class="col-xs-6"><input type="text" class="form-control" id="qid" name="qid" value="1" readonly/></div>
                                <div class="col-xs-3">
                                    <input class="form-control btn btn-primary" name="submit" id="edit" type="button" value="Edit" /></div>                                        
                            </div>
                            <div class="form-group">
                                <div class="col-xs-3 text-right">
                                    <label for="question">Question Text</label></div>
                                <div class="col-xs-6"><input disabled type="text" class="form-control" id="question" name="question" value="" required/></div>
                                <div class="col-xs-3">
                                    <input class="form-control btn btn-default" name="submit" id="save" type="button" value="Save" disabled /></div>                                        
                            </div>
                        
                        <div class="form-group">
                            <div class="col-xs-3 text-right"><label for="option1">Option1</label></div>
                            <div class="col-xs-6"><input disabled type="text" class="form-control" id="option1" name="option1" required/></div>                          
                            <div class="col-xs-3"><a href="search.jsp" id="search" class="btn btn-primary form-control">Search</a></div>                                        
                        </div>
                        <div class="form-group">
                            <div class="col-xs-3 text-right"><label for="option2">Option2</label></div>
                                <div class="col-xs-6"><input disabled type="text" class="form-control" id="option2" name="option2" required/></div>                           
                            <div class="col-xs-3"><input class="form-control btn btn-default" name="submit" id="cancel" type="button" value="Cancel" disabled /></div>                                            
                        </div>
                        <div class="form-group">
                            <div class="col-xs-3 text-right"><label for="option3">Option3</label></div>
                            <div class="col-xs-9 text-left"><input disabled type="text" class="form-control" id="option3" name="option3" required/></div>
                        </div>
                        <div class="form-group">
                            <div class="col-xs-3 text-right"><label for="option4">Option4</label></div>
                            <div class="col-xs-9 text-left"><input disabled type="text" class="form-control" id="option4" name="option4" required/></div>                           
                        </div>
                        <div class="form-group">
                            <div class="col-xs-3 text-right"><label for="answer">Answer [Enter in form of correct option like 1234]</label></div>
                            <div class="col-xs-9 text-left"><input disabled type="text" class="form-control" id="answer" name="answer" required/></div>                           
                        </div>
                </div>
                        <div class="panel-footer">
                           <div class="row ">
                                <%--Step II  Changed type=button--%>
                                <div class="col-xs-2 col-xs-offset-1">  <input class="form-control btn btn-primary" name="submit" id="first" type="button" value="First" /></div>
                                <div class="col-xs-2"> <input class="form-control btn btn-primary" name="submit" id="previous" type="button" value="Previous" /></div>
                                <div class="col-xs-2">  <input class="form-control btn btn-primary" name="submit" id="next" type="button" value="Next" /></div>
                                <div class="col-xs-2"> <input class="form-control btn btn-primary"  name="submit" id="last" type="button" value="Last" /></div>
                                <div class="col-xs-2">                                   
                                    <input class="form-control btn btn-primary" name="submit" id="find" type="button" value="Find" />
                                </div>
                            </div>
                                <%--Currently below lines are of no use--%>
                            <input type="hidden" id="operation" name="operation" value="" />
                            <input type="hidden" id="qno" name="qno" value="${sessionScope.qno}" />
                        </div>   
                    </form>                   
                </div>
            </div>
        </div>
        <script src="script/jquery-3.5.1.min.js"></script>
        <script src="script/bootstrap.min.js"></script>
        <script>
            //Below Fn called only when DOM is Ready
          
    jQuery(document).ready(
                    function () {
                        //Step 71 Register Click Event on Buttons
                        $("#add").on('click', addClick);    // #add represent if of element
                        $("#edit").on('click', editClick);
                        $("#cancel").on('click', cancelClick);
                        $("#find").on('click', findClick);
                        // Concept of event-sharing of Navigation Buttons
                        $("#first").on('click', function () {   navigationClick(1);    });
                        $("#previous").on('click', function () {  navigationClick(2);    });
                        $("#next").on('click', function () {  navigationClick(3);      });
                        $("#last").on('click', function () {    navigationClick(4);     });
                        $("#save").on('click' , saveClick); //16-Mar-2021
                    }); //End of ready fn 
           // Step 72: After end of above fn, we need to give definition of these UDF
       function addClick() {		//(*1)
                makeEditable();   //UDF-To allow typing inside input type='text'
                makeEmpty();     //UDF-To make fields empty
                $("#operation").val("add");  //Value of hidden field operation="add"
            }
            //Step 73: Now, we define fn for [Edit] Button
            function editClick() {		//(*1)
                makeEditable();   //UDF-To allow typing inside input type='text'
                $("#operation").val("edit");  //Value of hidden field operation="add"
            }
            //Step 74: Definition of UDF - makeEditable
            function makeEditable() {
                //Thanks to JQuery for shorter code - write less, do more
                //(a) Using JQuery get all elements which are input=text or select
                var $ui = $(":text,select");
                //(b) Perform for-each loop of those UI and remove attribute 'disabled'
                $ui.each(function () {
                    //(c) this - represent current object in the loop
                    $(this).removeAttr('disabled');
                });
                //Activate save and cancel buttons by removing 'disabled' attribute
                $("#save").removeAttr('disabled').removeClass('btn-default').addClass('btn-primary');
                $("#cancel").removeAttr('disabled').removeClass('btn-default').addClass('btn-primary');
                //Add disabled attribute to Remaining Buttons and change class to btn-default
                $("#add").attr('disabled', '').removeClass('btn-primary').addClass('btn-default');
                $("#edit").attr('disabled', '').removeClass('btn-primary').addClass('btn-default');
                 $("#first").attr('disabled', '').removeClass('btn-primary').addClass('btn-default');
                $("#previous").attr('disabled', '').removeClass('btn-primary').addClass('btn-default');
                 $("#next").attr('disabled', '').removeClass('btn-primary').addClass('btn-default');
                $("#last").attr('disabled', '').removeClass('btn-primary').addClass('btn-default');
                 $("#find").attr('disabled', '').removeClass('btn-primary').addClass('btn-default');
                $("#search").attr('disabled', '').removeClass('btn-primary').addClass('btn-default');
                 
            }
            //Step 75- UDF to make UI fields empty
            function makeEmpty() {
                //Asking JQuery to set value to empty text
                //elements which are either text or textarea
                $(":text, textarea").val("");
            }
            //Step 76: Coding of [Cancel] Button - Cancelling add/edit
             function cancelClick() {
                //(a) Select UI elements which are text or select
                var $ui = $(":text,select");
                $("#operation").val(""); //Clear value of hidden field
                //(b) Now add 'disabled' attribute at runtime
                $ui.each(function () {
                    $(this).attr('disabled', 'disabled'); //key,value
                });
                //(c) Activate Add and Edit and Navigation buttons
                $("#add").removeAttr('disabled').removeClass('btn-default').addClass('btn-primary');
                $("#edit").removeAttr('disabled').removeClass('btn-default').addClass('btn-primary');
                $("#first").removeAttr('disabled').removeClass('btn-default').addClass('btn-primary');
                $("#previous").removeAttr('disabled').removeClass('btn-default').addClass('btn-primary');
                $("#next").removeAttr('disabled').removeClass('btn-default').addClass('btn-primary');
                $("#last").removeAttr('disabled').removeClass('btn-default').addClass('btn-primary');
                $("#find").removeAttr('disabled').removeClass('btn-default').addClass('btn-primary');
                $("#search").removeAttr('disabled').removeClass('btn-default').addClass('btn-primary');
                //De-Activate Save and Cancel Buttons by adding disabled class
                $("#save").attr('disabled', '').removeClass('btn-primary').addClass('btn-default');
                $("#cancel").attr('disabled', '').removeClass('btn-primary').addClass('btn-default');
            }
            //Step 77: Coding of Save Button using JQuery/ajax
        function saveClick() {
                //(a) Ask for the Confirmation
                var c = confirm("Are you sure to Save?");
                if(!c)  //OR if(c==false) - means not sure
                {
                    return;  //Terminate Fn
                }
                //(b) Collect UI data in local variables
                var qid=$("#qid").val();
                var q=$("#question").val();
                var cat=$("#category").val();
                var op1=$("#option1").val();
                var op2=$("#option2").val();
                var op3=$("#option3").val();
                var op4=$("#option4").val();
                var ans=$("#answer").val();
                var sql="";
                //(c) Check value of hidden field operation
                var op=$("#operation").val(); //Value can be add or edit
               /* if(op=="add")
                        sql="insert into question values(qid_seq.nextval, '" + q + "' , '" + cat + "','" + op1 + "','" + op2 + "','" + op3 + "','" + op4 + "','" + ans + "')";
                else 
                        sql="Update question set question='" + q + "', category='" + cat + "', option1='"+ op1 + "',option2='"+ op2 + "',option3='"+op3+"',option4='" + op4 +"',answer='"+ ans +"' where qid='" + qid +"'"; 
               */
              if(op=="add")
                        sql="insert into question values(qid_seq.nextval, '" + q + "' , '" + cat + "','" + op1 + "','" + op2 + "','" + op3 + "','" + op4 + "','" + ans + "')";
                else 
                        sql="Update question set question='" + q + "', category='" + cat + "', option1='"+ op1 + "',option2='"+ op2 + "',option3='"+op3+"',option4='" + op4 +"',answer='"+ ans +"' where qid='" + qid +"'"; 
                //sql=_.escape(sql);
                alert("SQL=" + sql);
                //Generate URL to transfer op=5 and above SQL
                var myurl = "QuizServlet?op=5&sql=" + sql;
                // alert("MyURL=" + myurl);
               $.ajax({
                    url: myurl,
                    async: false,
                    type: 'POST',
                    success: function (data) {  //Get data from Servlet
                       // alert("Record Saved Successfully");
                       $("#msg").val(data);
                       alert(data);
                       cancelClick(); //Step 82: Calling one fn from with another fn
                        //Convert comma seperated data to array
                        //var array = data.split(",");
                        //User-Defined Fn to Display data
                        //arrayToText(array)
                    },
                    error: function (jqXHR, exception) {
                        console.log('arrayToText Exception ' + excepttion);
                        cancelClick(); //Step 82-18-Mar-2021
                    }    
                });
    }
      //Step 86: Coding of navigationClick    
           function navigationClick(n) {
                var myurl = "QuizServlet?op=6&choice=" + n;
                $.ajax({
                    url: myurl,
                    async: false,
                    type: 'POST',
                    success: function (data) {  //Get data from Servlet
                        //Convert comma seperated data to array
                        var array = data.split(",");
                        //User-Defined Fn to Display data
                        arrayToText(array)
                        //alert("All is Well = " + data);
                    },
                    error: function (jqXHR, exception) {
                        console.log('arrayToText Exception ' + excepttion);
                    }
                });
            }
            //Step 87-18-Mar-2021
            function arrayToText(array) {
                $("#qid").val(array[0]);
                $("#question").val(array[1]);
                //$("#category").val(array[2]);
               // alert(array[2]);
                var select = "#category option[value='" + array[2] + "']";
                $(select).attr("selected", "selected");
                $("#option1").val(array[3]);
                $("#option2").val(array[4]);
                $("#option3").val(array[5]);
                $("#option4").val(array[6]);
                $("#answer").val(array[7]);
                // $("#questiontype").val(array[8]);
                select = "#questiontype option[value='" + array[8] + "']";
                $(select).attr("selected", "selected");
            }
            //Step 91-20-Mar-2021 Coding to Find Record
            function findClick() {
                //Ask client to input/prompt qid at runtime 
                var qid = prompt("Enter Qid to Search");
                //Check if cancel pressed or nothing entered
                if (qid == null || qid.trim().length == 0) {
                    return false; //Terminate Fn
                }
                var myurl = "QuizServlet?op=7&qid=" + qid;
                $.ajax({
                    url: myurl,
                    async: false,
                    type: 'POST',
                    success: function (data) {  //Get data from Servlet
                     //   alert(data);
                        //Convert comma seperated data to array
                        if(data==-1){
                            alert("Sorry!!! Qid " + qid + " Not Found");
                            return;
                        }else{
                        //Otherwise
                        var array = data.split(",");
                        //User-Defined Fn to Display data
                        arrayToText(array)
                    }
                    },
                    error: function (jqXHR, exception) {
                        console.log('arrayToText Exception ' + exception);
                    }
                });
            }
    //function saveClick(){ }
    //function navigationClick(n) {     alert('Navigation Button Pressed' +n);            }
            //Step IV: 09-Sep-2020 Coding of navigationClick
           /* function navigationClick(n) {
                var myurl = "QuizServlet?op=8&choice=" + n;
                $.ajax({
                    url: myurl,
                    async: false,
                    type: 'POST',
                    success: function (data) {  //Get data from Servlet
                        //Convert comma seperated data to array
                        var array = data.split(",");
                        //User-Defined Fn to Display data
                        arrayToText(array)
                        //alert("All is Well = " + data);
                    },
                    error: function (jqXHR, exception) {
                        console.log('arrayToText Exception ' + excepttion);
                    }
                });
            }
            //14-Sep-2020 Step I: Calling navigationClick to display Last Row
            navigationClick(4);
            //07-Sep-2020
            
            //User-Defined Fn to Display Data inside UI
            function arrayToText(array) {
                $("#qid").val(array[0]);
                $("#question").val(array[1]);
                //$("#category").val(array[2]);
               // alert(array[2]);
                var select = "#category option[value='" + array[2] + "']";
                $(select).attr("selected", "selected");
                $("#option1").val(array[3]);
                $("#option2").val(array[4]);
                $("#option3").val(array[5]);
                $("#option4").val(array[6]);
                $("#answer").val(array[7]);
                // $("#questiontype").val(array[8]);
                select = "#questiontype option[value='" + array[8] + "']";
                $(select).attr("selected", "selected");
            }
           
            
   */
        </script>
    </body>
</html>
