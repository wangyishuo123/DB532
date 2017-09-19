<%-- 
/****************************************************************************
CSE532 -- Project 2
File name:  query3.jsp
Author(s):  Yishuo Wang (108533945)
            Minghui Lin (109557872)
Brief description: query 3

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
        
        String createSameArtworkViewStr = 
                        "CREATE OR REPLACE VIEW \"SAME_ARTWORK\" AS " + 
                        "SELECT a1.\"CId\", a1.\"AId\", count(a1.\"JId\") \"JUDGE_NUM\", avg(a1.\"Score\") \"AVG_SCORE\" " +
                        "FROM \"Audition\" a1 " +
                        "GROUP BY a1.\"CId\", a1.\"AId\", a1.\"SId\" " +
                        "ORDER BY a1.\"CId\";";
                
        String sqlstr = 
                        "SELECT DISTINCT C1.\"Name\" name1, C2.\"Name\" name2 "+
                        "FROM \"SAME_ARTWORK\" S1, \"SAME_ARTWORK\" S2,"+ "\"Contestant\" C1, \"Contestant\" C2 "+
                        "WHERE " + 
                        "S1.\"CId\" = C1.\"CId\" AND "+
                        "S2.\"CId\" = C2.\"CId\" AND "+
                        "S1.\"CId\" != S2.\"CId\" AND "+
                        "C1.\"Name\" < C2.\"Name\" AND "+
                        "S1.\"AId\" = S2.\"AId\" AND "+
                        "S1.\"JUDGE_NUM\" = S2.\"JUDGE_NUM\" AND "+
                        "S1.\"AVG_SCORE\" = S2.\"AVG_SCORE\" "+                     
                        "ORDER BY C1.\"Name\";";
        
        System.out.println(createSameArtworkViewStr);
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
            
            // CREATE OR REPLACE VIEW NAMED "SAME_ARTWORK" 
            st.executeUpdate(createSameArtworkViewStr);
            
            // QUERY SAME_ARTWORK TO FIND OUT RESULT SET OF QUERY 3
            rs = st.executeQuery(sqlstr);
            
            // DISPLAY QUER QUESTIONS:
            out.println("<h3>Question#3:</h3>");
    %>
        <p>Find all pairs of contestants who auditioned the same artwork in (possibly different) shows that
            had the same number of judges and the two contestants received the same average score for that
            audition.
            This query also involves aggregates.</p><br/><hr/>
            
    <%
            // DISPLAY SQL QUERY STRING
            out.println("<h3>Query String:</h3>");
            out.println("<h4>"+createSameArtworkViewStr+"</h4><BR/>");
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
        <p> 1) First Create a view named SAME_ARTWORK which list info of 
            audition group by the Contestant Id, Artwork Id and Show Id</p>
        <p> 2) Self-Join SAME_ARTWORK and Join 2 Contestant Table to list all 
            pairs of Contestant Name which satisfy the condition (same judge 
            numbers and average of score).</p>
    
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
