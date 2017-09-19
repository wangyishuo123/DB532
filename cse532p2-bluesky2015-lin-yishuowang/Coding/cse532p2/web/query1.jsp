<%-- 
/****************************************************************************
CSE532 -- Project 2
File name:  query1.jsp
Author(s):  Yishuo Wang (108533945)
            Minghui Lin (109557872)
Brief description: query 1

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
        String sqlstr = "SELECT DISTINCT c1.\"Name\", c2.\"Name\" "
                + "FROM public.\"Contestant\" c1, public.\"Contestant\" c2, "
                + "public.\"Audition\" a1, public.\"Audition\" a2,"
                + "public.\"Show\" s1, public.\"Show\" s2 "
                + "WHERE c1.\"CId\" != c2.\"CId\" AND c1.\"Name\" < c2.\"Name\""
                + "AND a1.\"CId\" = c1.\"CId\" AND a2.\"CId\" = c2.\"CId\" AND a1.\"AId\" = a2.\"AId\" AND a1.\"Score\" = a2.\"Score\""
                + "AND a1.\"SId\" = s1.\"SId\" AND a2.\"SId\" = s2.\"SId\" AND s1.\"Date\" = s2.\"Date\"";
        System.out.println(sqlstr);
        
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
            
            // DISPLAY QUER QUESTIONS:
            out.println("<h3>Question#1:</h3>");
    %>
            <p>Find all pairs of contestants who auditioned the same artwork on the same date and got the
same score from at least one judge (not necessarily the same judge).
This is a warm-up rule.</p><br/><hr/>
            
            
    <%
            // DISPLAY SQL QUERY STRING
            out.println("<h3>Query String:</h3>");
            out.println("<h4>"+sqlstr+"</h4>");
            out.println("<br/><hr/>");
            
            // DISPLAY SQL QUERY RESULT
            out.println("<h3>Query Result:</h3>");
            
            // OUTPUT TABLE HEADER
            out.println("<table>");
            out.println("<tr><th>Name1</th><th>Name2</th></tr>");

            // OUTPUT TABLE DATA
            int num = 0;
            while(rs.next()) {
                String Name1 = rs.getString(1);
                String Name2 = rs.getString(2);
                
                out.println("<tr><th>"+ Name1 + "</th><th>" + Name2 + "</th></tr>");
                num++;
            }
            
            // OUTPUT TABLE FOOTER
            out.println("</table>");
            out.println("There are " + num + " solutions.");
            out.println("<br/><br/><hr/>");
            

            // OUTPUT QUERY IDEAS
            out.println("<h3>Query Ideas:</h3>");
            
    %>
        <p>Join 2 Contestant Table to list all pairs of Contestant Name which 
            satisfy the condition (same artwork on the same date and got the 
            same score from at least one judge (not necessarily the same 
            judge)). </p>
    
    <%
            out.println("<br/><hr/>");
            
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
