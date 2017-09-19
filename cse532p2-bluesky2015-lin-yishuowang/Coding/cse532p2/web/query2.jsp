<%-- 
/****************************************************************************
CSE532 -- Project 2
File name:  query2.jsp
Author(s):  Yishuo Wang (108533945)
            Minghui Lin (109557872)
Brief description: query 2

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
        String sqlstr = "SELECT R.name1, R.name2 FROM ( "
                + "SELECT DISTINCT c1.\"Name\" name1, c2.\"Name\" name2, "
                + "MAX(a1.\"Score\") OVER (PARTITION BY a1.\"CId\", a1.\"SId\", a1.\"AId\") max1, "
                + "MAX(a2.\"Score\") OVER (PARTITION BY a2.\"CId\", a2.\"SId\", a2.\"AId\") max2, "
                + "MIN(a1.\"Score\") OVER (PARTITION BY a1.\"CId\", a1.\"SId\", a1.\"AId\") min1, "
                + "MIN(a2.\"Score\") OVER (PARTITION BY a2.\"CId\", a2.\"SId\", a2.\"AId\") min2 "
                + "FROM public.\"Contestant\" c1, public.\"Contestant\" c2, "
                + "public.\"Audition\" a1, public.\"Audition\" a2 "
                + "WHERE c1.\"CId\" != c2.\"CId\" AND c1.\"Name\" < c2.\"Name\" "
                + "AND a1.\"CId\" = c1.\"CId\" AND a2.\"CId\" = c2.\"CId\" AND a1.\"AId\" = a2.\"AId\" "
                + "GROUP BY name1, name2, "
                + "a1.\"Score\", a2.\"Score\", "
                + "a1.\"CId\", a2.\"CId\", "
                + "a1.\"SId\", a2.\"SId\", "
                + "a1.\"AId\", a2.\"AId\" "
                + ") R "
                + "WHERE R.max1 = R.max2 AND R.min1 = R.min2 "
                + "ORDER BY R.name1";
        
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
            out.println("<h3>Question#2:</h3>");
    %>
        <p>Find all pairs of contestants who happened to audition the same artwork (in possibly different
        shows) and got the same maximal score and the same minimal score for that audition (from
        possibly different judges).
        This query involves aggregates.</p><br/><hr/>
            
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
        <p>Due to "aggregate functions are not allowed in WHERE" in postgreSQL, 
            we will create a "R", which will show the MAX, MIN of two tuples 
            that partition by "CId, SId, AId". Then using "R.max1 = R.max2 AND 
            R.min1 = R.min2" to satisfy the condition.</p>
    
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
