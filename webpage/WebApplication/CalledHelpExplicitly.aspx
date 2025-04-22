<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CalledHelpExplicitly.aspx.cs" Inherits="WebApplication1.TookMedicine" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Help Me!</title>
</head>

<body bgcolor="E4E4E4">
    <form id="form1" runat="server">
        <div>
             <h1><FONT COLOR="0000CD">Help Me!</FONT></h1>

             <h2>Your primary contact has been contacted.</h2>

             <h3>Would you like to call someone else?</h3>

            <asp:Button ID="Button1" runat="server" Text="HELP!" PostBackUrl="~/CalledHelpAgain.aspx" />
            <asp:Button ID="btnConfirm" runat="server" Text="Back" PostBackUrl="~/Home.aspx" />

            <%--email text: Contact [IP_ADDRESS] needs help. They can be found in [PLACE]. [MESSAGE]--%>
        </div>
    </form>
</body>
</html>
