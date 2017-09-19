(::)
(:I pledge my honor that all parts of this project were done by me alone and:)
(:without collaboration with anybody else.:)
 
(:CSE532 - Project 3:)
(:File name: query5.xquery:)
(:Author: Yishuo Wang (108533945):)
(:Brief description: query5.xquery get the result of the fifth query:)
xquery version "3.1";
declare default element namespace "http://localhost:8080/exist/CSE532";
declare function local:indirect($direct as element()*,$indirect as element()*)
{
    let $inner_direct := 
        for $d in $direct/dir
        return
            <indirect>
                {$d/user1}
                {$d/user2}
            </indirect>
    
    let $inner_indirect :=
        for $d in $direct/dir,
            $ind in $indirect/dir
        return
            <indirect>
                {$d/user1}
                {$ind/user2}
            </indirect>
    
    let $union :=
        $inner_direct union $inner_indirect
        
    let $res:=
        for $u1 in distinct-values($union/user1),
            $u2 in distinct-values($union[user1 = $u1]/user2)
        return 
          <dir>
              <user1>{$u1}</user1>
              <user2>{$u2}</user2>
          </dir>
    
    return
        if (count($res)>count($indirect/dir))
        then
            local:indirect($direct,<indirect>{$res}</indirect>)
        else
            $res
};

let $cse532 := doc("/db/CSE532/CSE532.xml")/CSE532
let $avg_score :=
    <avg_score>
    {
        for $c1 in $cse532/Contestant,
            $a1 in $c1/Audition
        group by 
            $CId := $c1/CId
        order by $CId
        return element eachone{
            $CId,
            $a1/Artwork/AId,
            $a1/Show/SId,
            <avg> {avg($a1/Score)} </avg>,
            $c1/Name
        }
    }
    </avg_score>

let $direct :=
    <direct>
    {
        for $as1 in $avg_score/eachone,
            $as2 in $avg_score/eachone[Name != $as1/Name]
        where
            $as1/AId = $as2/AId and
            $as1/SId = $as2/SId and
            abs($as1/avg - $as2/avg) <= 0.2
        return element dir{
            <user1>{$as1/CId/string()}</user1>,
            <user2>{$as2/CId/string()}</user2>
        }
    }
    </direct>
let $indirect :=
    <indirect>
    {
        for $as1 in $avg_score/eachone,
            $as2 in $avg_score/eachone[Name != $as1/Name]
        where
            $as1/AId = $as2/AId and
            $as1/SId = $as2/SId and
            abs($as1/avg - $as2/avg) <= 0.2
        return element dir{
            <user1>{$as1/CId/string()}</user1>,
            <user2>{$as2/CId/string()}</user2>
        }
    }
    </indirect>
    
return
    <query5>
    {
        data(
        for $all in local:indirect($direct, $indirect),
            $c1 in $cse532/Contestant[CId = $all/user1],
            $c2 in $cse532/Contestant[CId = $all/user2]
        where
            $c2/Name > $c1/Name
        order by $c1/Name, $c2/Name
        return
            <result>
                ({$c1/Name/string()} , {$c2/Name/string()})
            </result>
    )}    
    </query5>
        
    
    
    