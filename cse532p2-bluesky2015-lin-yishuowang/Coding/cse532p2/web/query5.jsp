<%-- 
/****************************************************************************
CSE532 -- Project 2
File name:  query5.jsp
Author(s):  Yishuo Wang (108533945)
            Minghui Lin (109557872)
Brief description: query 5

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
        
        String recursive_view_sql = 
                        "CREATE OR REPLACE RECURSIVE VIEW \"CLOSRURE\" (cid1, cid2) AS " +
                        "    SELECT DISTINCT view1.\"CId\" cid1, view2.\"CId\" cid2 " +
                        "    FROM \"AVG_VIEW\" view1, \"AVG_VIEW\" view2, " +
                        "        \"Audition\" A1, \"Audition\" A2 " +
                        "    WHERE " +
                        "    	view1.\"CId\" != view2.\"CId\" AND " +
                        "        view1.\"CId\" = A1.\"CId\" AND " +
                        "        view2.\"CId\" = A2.\"CId\" AND " +
                        "        A1.\"AId\" = A2.\"AId\" AND " +
                        "        A1.\"SId\" = A2.\"SId\" AND " +
                        "        abs(view1.\"AVG_SCORE\" - view2.\"AVG_SCORE\") <= 0.2  " +
                        " UNION " +
                        "    SELECT DISTINCT CL.\"cid1\" cid2, view2.\"CId\" cid1 " +
                        "    FROM \"AVG_VIEW\" view1, \"AVG_VIEW\" view2, " +
                        "        \"Audition\" A1, \"Audition\" A2, " +
                        "        \"CLOSRURE\" CL " +
                        "    WHERE " +
                        "        view1.\"CId\" != view2.\"CId\" AND " +
                        "        view1.\"CId\" = A1.\"CId\" AND " +
                        "        view2.\"CId\" = A2.\"CId\" AND " +
                        "        A1.\"AId\" = A2.\"AId\" AND " +
                        "        A1.\"SId\" = A2.\"SId\" AND " +
                        "        abs(view1.\"AVG_SCORE\" - view2.\"AVG_SCORE\") <= 0.2 AND " +
                        "        view1.\"CId\" = CL.\"cid2\";";
                
        String display_final_result_sql = 
                        "SELECT C1.\"Name\", C2.\"Name\" " +
                        "FROM \"CLOSRURE\" CL, \"Contestant\" C1, \"Contestant\" C2 " +
                        "WHERE CL.\"cid1\" = C1.\"CId\" AND " +
                        "CL.\"cid2\" = C2.\"CId\" AND " +
                        "C1.\"Name\" < C2.\"Name\" " +
                        "ORDER BY C1.\"Name\",C2.\"Name\";";
        
        System.out.println(recursive_view_sql);
        System.out.println(display_final_result_sql);
        
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
            st.executeUpdate(recursive_view_sql);
            
            // QUERY SAME_ARTWORK TO FIND OUT RESULT SET OF QUERY 3
            rs = st.executeQuery(display_final_result_sql);
            
            // DISPLAY QUER QUESTIONS:
            out.println("<h3>Question#5:</h3>");
    %>
        <p> Find all close rivals. The close rivals relation is the transitive closure of the following binary
            relation: X and Y are direct close rivals iff they both performed the same artwork in the same
            show and their overall average scores are within 0.2 of each other.
            This query involves recursion and aggregation.</p><br/><hr/>
            
    <%
            // DISPLAY SQL QUERY STRING
            out.println("<h3>Query String:</h3>");
            out.println("<h4>"+recursive_view_sql+"</h4><BR/>");
            out.println("<h4>"+display_final_result_sql+"</h4>");
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
        <p> 1) Create initial state(direct rivals) SQL string.</p>
        <p> 2) Create recursive view of close rivals.</p>
        <p> 2) Select final recursive view by a few conditions.</p>
    
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
