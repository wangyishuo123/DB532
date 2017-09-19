xquery version "3.1";
declare default element namespace "http://localhost:8080/exist/CSE532";

let $cse532 := doc("/db/CSE532/CSE532.xml")/CSE532
return
  <query1>{
      distinct-values(
        for $c1 in $cse532/Contestants/Contestant,
            $c2 in $cse532/Contestants/Contestant[Name > $c1/Name],
            $a1 in $cse532/Auditions/Audition[CId = $c1/CId],
            $a2 in $cse532/Auditions/Audition[CId = $c2/CId],
            $s1 in $cse532/Shows/Show[SId = $a1/SId],
            $s2 in $cse532/Shows/Show[SId = $a2/SId]
        where
            $a1/AId = $a2/AId and $a1/Score = $a2/Score
            and $s1/Date = $s2/Date
        order by $c1/Name, $c2/Name
        return
            
            <result>
                {$c1/Name} {$c2/Name}
            </result>
            
  )}
  </query1>