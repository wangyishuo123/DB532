(::)
(:I pledge my honor that all parts of this project were done by me alone and:)
(:without collaboration with anybody else.:)
 
(:CSE532 - Project 3:)
(:File name: query2.xquery:)
(:Author: Yishuo Wang (108533945):)
(:Brief description: query2.xquery get the result of the second query:)
xquery version "3.1";
declare default element namespace "http://localhost:8080/exist/CSE532";

let $cse532 := doc("/db/CSE532/CSE532.xml")/CSE532

let $maxmin :=
    <maxmin>
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
            <max>{max($a1/Score)}</max>,
            <min>{min($a1/Score)}</min>
        }
    }
    </maxmin>
    
    
return
    <query2>
    {
        data(
        for 
            $a1 in $maxmin/eachone,
            $a2 in $maxmin/eachone[Name > $a1/Name]
        where
            $a1/aid = $a2/aid and
            $a1/max = $a2/max and
            $a1/min = $a2/min
        order by $a1/Name, $a2/Name
        return
            <result>
                ({$a1/Name/string()} , {$a2/Name/string()})
            </result>
    )}    
    </query2>

            

        
    
  