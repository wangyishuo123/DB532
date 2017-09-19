(::)
(:I pledge my honor that all parts of this project were done by me alone and:)
(:without collaboration with anybody else.:)

(:CSE532 - Project 3:)
(:File name: allQuery.xquery:)
(:Author: Yishuo Wang (108533945):)
(:Brief description: allQuery.xquery will run the all 5 query and get result:)

xquery version "3.1";
declare default element namespace "http://localhost:8080/exist/CSE532";
(:for query 5:)
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
(:  for query 2  :)
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
    
(:  for query 3  :)
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
(:  for query 4    :)
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
    <AllQuery>
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
    
    </AllQuery>