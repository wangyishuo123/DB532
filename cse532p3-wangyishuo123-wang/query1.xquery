(::)
(:I pledge my honor that all parts of this project were done by me alone and:)
(:without collaboration with anybody else.:)
 
(:CSE532 - Project 3:)
(:File name: query1.xquery:)
(:Author: Yishuo Wang (108533945):)
(:Brief description: query1.xquery get the result of the first query:)
xquery version "3.1";
declare default element namespace "http://localhost:8080/exist/CSE532";

let $cse532 := doc("/db/CSE532/CSE532.xml")/CSE532
return
    <query1>{
        distinct-values(
            for $c1 in $cse532/Contestant,
                $c2 in $cse532/Contestant[Name > $c1/Name],
                $a1 in $c1/Audition,
                $a2 in $c2/Audition,
                $s1 in $a1/Show,
                $s2 in $a2/Show
            where
                $a1/Artwork/AId = $a2/Artwork/AId and 
                $a1/Score = $a2/Score and 
                $s1/Date = $s2/Date
            order by $c1/Name, $c2/Name
            return
                <result>
                    ({$c1/Name/string()} , {$c2/Name/string()})
                </result>
    )}
    </query1>
    