xquery version "3.1";
declare default element namespace "http://localhost:8080/exist/CSE532";

let $cse532 := doc("/db/CSE532/CSE532.xml")/CSE532

        for $a1 in $cse532/Auditions/Audition
        group by 
            $CId := $a1/CId/string(),
            $SId := $a1/SId/string(),
            $AId := $a1/AId/string()
        order by $CId, $SId, $AId
        return element persons{
            attribute CId {$CId}, 
            attribute SId {$SId}, 
            attribute AId {$AId}, 
            $a1/Score ! element Score {data()}
        }
