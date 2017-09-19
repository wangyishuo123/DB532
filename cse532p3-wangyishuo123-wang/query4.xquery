(::)
(:I pledge my honor that all parts of this project were done by me alone and:)
(:without collaboration with anybody else.:)
 
(:CSE532 - Project 3:)
(:File name: query4.xquery:)
(:Author: Yishuo Wang (108533945):)
(:Brief description: query4.xquery get the result of the fourth query:)
xquery version "3.1";
declare default element namespace "http://localhost:8080/exist/CSE532";

let $cse532 := doc("/db/CSE532/CSE532.xml")/CSE532
let $Contestant_show :=
    <Contestant_show>
    {
        for $c1 in $cse532/Contestant,
            $a1 in $c1/Audition
        group by 
            $CId := $c1/CId
        order by $CId
        return element eachone{
            attribute CId {$CId}, 
            <cid> {$CId} </cid>,
            <sid> {$a1/Show/SId} </sid>,
            $c1/Name
        }
    }
    </Contestant_show>

return
    <query4>
    {
        data(
        for 
            $cs1 in $Contestant_show/eachone,
            $cs2 in $Contestant_show/eachone[Name != $cs1/Name],
            $s1 in $cs1/sid,
            $s2 in $cs2/sid
        where
            every $s in $s2/SId satisfies ($s1/SId = $s)
        order by $cs1/Name, $cs2/Name
        return
            <result>
                ({$cs1/Name/string()} , {$cs2/Name/string()})
            </result>
    )}    
    </query4>            

    


    

            

        
    
  