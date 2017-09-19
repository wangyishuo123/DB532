(::)
(:I pledge my honor that all parts of this project were done by me alone and:)
(:without collaboration with anybody else.:)
 
(:CSE532 - Project 3:)
(:File name: query3.xquery:)
(:Author: Yishuo Wang (108533945):)
(:Brief description: query3.xquery get the result of the third query:)
xquery version "3.1";
declare default element namespace "http://localhost:8080/exist/CSE532";

let $cse532 := doc("/db/CSE532/CSE532.xml")/CSE532
let $same_artwork :=
    <same_artwork>
    {
        for $c1 in $cse532/Contestant,
            $a1 in $c1/Audition
        group by 
            $CId := $c1/CId/string(),
            $SId := $a1/Show/SId/string(),
            $AId := $a1/Artwork/AId/string()
        order by $CId, $SId, $AId
        return element eachone{
            attribute CId {$CId}, 
            attribute SId {$SId}, 
            attribute AId {$AId},
            <cid> {$CId} </cid>,
            $c1/Name,
            <aid> {$AId} </aid>,
            <judge_num>{count($a1/Judge)}</judge_num>,
            <avg_score>{avg($a1/Score)}</avg_score>
        }
    }
    </same_artwork>


return
    <query3>{
        distinct-values(
            for 
                $s1 in $same_artwork/eachone,
                $s2 in $same_artwork/eachone[Name > $s1/Name]
            where
                $s1/aid = $s2/aid and
                $s1/judge_num = $s2/judge_num and
                $s1/avg_score = $s2/avg_score
            order by $s1/Name, $s2/Name
            return
                <result>
                    ({$s1/Name/string()} , {$s2/Name/string()})
                </result>
    )}
    </query3>
    

            

        
    
  