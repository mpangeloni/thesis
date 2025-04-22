<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CalledHelpAgain.aspx.cs" Inherits="WebApplication1.WebForm2" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Help Me!</title>
</head>

<body bgcolor="E4E4E4">
    <form id="form1" runat="server">
        <div>
            <h1><FONT COLOR="0000CD">Help Me!</FONT></h1>

             <h2>Your secondary contact has been contacted as well.</h2>

            <asp:Button ID="btnConfirm" runat="server" Text="Back" PostBackUrl="~/Home.aspx" />
        </div>
    </form>
</body>
</html>
