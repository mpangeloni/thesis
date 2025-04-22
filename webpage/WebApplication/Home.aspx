<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Home.aspx.cs" Inherits="WebApplication1.WebForm1" %>

<!DOCTYPE html>

<script>
    function startTimer(duration, display) {
        var timer = duration, minutes, seconds;
        var end = setInterval(function () {
            minutes = parseInt(timer / 60, 10);
            seconds = parseInt(timer % 60, 10);

            minutes = minutes < 10 ? "0" + minutes : minutes;
            seconds = seconds < 10 ? "0" + seconds : seconds;

            display.textContent = minutes + ":" + seconds;

            if (--timer < 0) {
                window.location = "DidntTake.aspx";
                clearInterval(end);
            }
        }, 1000);
    }

    window.onload = function () {
        var fiveMinutes = 5,
            display = document.querySelector('#time');
        startTimer(fiveMinutes, display);
    };
</script>


<script type="text/javascript">
    var thedate = new Date();
    var dayofweek = thedate.getUTCDay();
    var hourofday = thedate.getUTCHours();
    function onTime() {
        //if (dayofweek != 0 && (hourofday > 2 && hourofday < 7)) {
        if (hourofday == 15) {
            return true;
        }
        return false;
    }
</script>

<script>
    function myFunction() {
        document.body.style.backgroundColor = "yellow";
    }
</script>


<html xmlns="http://www.w3.org/1999/xhtml">

<head runat="server">
    <title>Help Me!</title>

    <style type="text/css">
        button { opacity: 0;}
    </style>
</head>

<body bgcolor="E4E4E4">
    <form id="form1" runat="server">

    <h1><FONT COLOR='0000CD'>Help Me!</FONT></h1>
    
    <asp:Label ruant="server" AssociatedControlID="txtempname"><b>Would you like to say something?</b></asp:Label><br />
    <asp:TextBox runat="server" Enabled="true" name="BrandName" ID="txtempname" CssClass="form-control input-sm" placeholder="Write your message here."></asp:TextBox>

    <h2>Press the button below if you would like to call for the help of your registered contact.</h2>
    <h3> </h3>

    <asp:Button ID="btnConfirm" runat="server" Text="Help!" PostBackUrl="~/CalledHelpExplicitly.aspx" OnClick="btnConfirm_Click"/>
    <h3></h3>

    <%--<p>If you wish to learn more about ParkinsonCom, please visit <a href="http://thedavidlawrenceshow.com/">our website</a>.</p>--%>
 
    <button type="button" ID="fall" onclick="myFunction()"> I fell </button>

    </form>
    
</body>

</html>