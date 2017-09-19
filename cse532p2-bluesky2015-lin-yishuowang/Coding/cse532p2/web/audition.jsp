<%-- 
/****************************************************************************
CSE532 -- Project 2
File name:  Audition.jsp
Author(s):  Minghui Lin (109557872)
            Yishuo Wang (108533945)
Brief description: Select all data from Audition Table

I (or We, if working with a partner) pledge my (or our) honor that all parts
of this project were done by me (or us) alone and without collaboration with
anybody else.
****************************************************************************/
--%>

<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.util.Properties"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>CSE 532 Project 2 | Display Page</title>
        
        <style>
            table, th, td {
                border: 1px solid black;
                border-collapse: collapse;
            }
            th, td {
                padding: 5px;
                text-align: left;
            }
        </style>
    </head>
    <body>
        
    <% 
        // VARIABLES
        String url = "jdbc:postgresql://localhost:5432/cse532db";
        Connection con;
        Statement st;
        ResultSet rs;

        String sqlstr = "SELECT * FROM public.\"Audition\" ORDER BY \"AId\" ASC, \"JId\" ASC, \"SId\" ASC, \"CId\" ASC";

        // INITIAL JDBC DRIVER
        try {
                Class.forName("org.postgresql.Driver");
        } catch(java.lang.ClassNotFoundException e) {
                System.err.print("ClassNotFoundException: ");
                System.err.println(e.getMessage());
        }
    %>

    <% 
        // INITIAL CONNECTION TO DATABASE
        try {
            con = DriverManager.getConnection(url,"postgres", "root");
            st = con.createStatement();
            rs = st.executeQuery(sqlstr);

            // OUTPUT TABLE HEADER
            out.println("<table>");
            out.println("<caption>Audition Table</caption>");
            out.println("<tr><th>Score</th><th>CId</th><th>AId</th><th>SId</th><th>JId</th></tr>");

            // OUTPUT TABLE DATA
            while(rs.next()) {
                String Score = rs.getString(1);
                String CId = rs.getString(2);
                String AId = rs.getString(3);
                String SId = rs.getString(4);
                String JId = rs.getString(4);
                out.println("<tr><th>"+ Score + "</th><th>" + CId + "</th><th>" + AId + "</th><th>" + SId + "</th><th>" + JId  +"</th></tr>");
            }

            // OUTPUT TABLE FOOTER
            out.println("</table>");

            // CLOSE CONNECTIONS
            rs.close();
            st.close();
            con.close();
        }

        catch(SQLException ex) {
            System.err.println("SQLException: " + ex.getMessage());
        }
    %>
    </body>
</html>
