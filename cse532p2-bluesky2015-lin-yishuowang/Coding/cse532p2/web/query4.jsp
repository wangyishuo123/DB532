<%-- 
/****************************************************************************
CSE532 -- Project 2
File name:  query4.jsp
Author(s):  Yishuo Wang (108533945)
            Minghui Lin (109557872)
Brief description: query 4

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
        
        String create_Show_Contestants_ViewStr = 
                        "CREATE OR REPLACE VIEW \"Show_Contestants\" AS " + 
                        "SELECT a1.\"CId\", a1.\"SId\" " +
                        "FROM \"Audition\" a1 \n" +
                        "GROUP BY a1.\"CId\", a1.\"SId\" " +
                        "ORDER BY a1.\"CId\";";
                
        String sqlstr = 
                        "SELECT DISTINCT contestant1.\"Name\", contestant2.\"Name\" "+
                        "FROM \"Contestant\" contestant1, \"Contestant\" contestant2 "+
                        "WHERE NOT EXISTS "+
                        "("+
                        "SELECT DISTINCT c1.\"Name\", c2.\"Name\" "+
                        "FROM "+
                        "\"Contestant\" c1, "+
                        "\"Contestant\" c2, "+
                        "\"Show_Contestants\" sc1, "+
                        "\"Show_Contestants\" sc2 "+
                        "WHERE "+
                        "contestant1.\"CId\" = c1.\"CId\" "+
                        "AND contestant2.\"CId\" = c2.\"CId\" "+
                        "AND c1.\"CId\" != c2.\"CId\""+
                        "AND sc1.\"CId\" = c1.\"CId\" "+
                        "AND sc2.\"CId\" = c2.\"CId\" "+
                        "AND sc2.\"SId\" NOT IN (SELECT sc3.\"SId\" "+
                        "FROM \"Show_Contestants\" sc3 "+
                        "WHERE sc3.\"CId\" = sc1.\"CId\" "+
                        ") "+
                        ") "+
                        "AND contestant1.\"CId\" != contestant2.\"CId\"";
        
        System.out.println(create_Show_Contestants_ViewStr);
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
            st.executeUpdate(create_Show_Contestants_ViewStr);
            
            // QUERY SAME_ARTWORK TO FIND OUT RESULT SET OF QUERY 3
            rs = st.executeQuery(sqlstr);
            
            // DISPLAY QUER QUESTIONS:
            out.println("<h3>Question#4:</h3>");
    %>
        <p>Find all pairs of contestants (by name) such that the first contestant in each pair performed in
           all the shows in which the second contestant did (possibly performing different artworks).
            Write this query using explicit quantifiers (forall and exists). All variables that do not occur
            in the query’s rule head must be quantified explicitly.
            This query also involves aggregates.</p><br/><hr/>
            
    <%
            // DISPLAY SQL QUERY STRING
            out.println("<h3>Query String:</h3>");
            out.println("<h4>"+create_Show_Contestants_ViewStr+"</h4><BR/>");
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
        <p> 1) First Create a view named Show_Contestants which list "CId, SId" 
            of audition group by the Contestant Id, Show Id.</p>
        <p> 2) Using not-exists. The query means "The C1 is in all the C2's 
            shows." Which means C1's shows include C2's and maybe have extra 
            shows that C2 does not attend. So first we will find all the pairs 
            that "C2 has some shows that C1 does not have". Then we use all the 
            pairs minus these pairs we get at the first steps.</p>
    
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
