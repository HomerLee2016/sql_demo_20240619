------------------------------
-- Option 1
------------------------------
select      a.*
from        [Table A] a
inner join  [Table A] b
      on    a.trainerid = b.trainerid
where       a.starttime <= b.endtime
      and   b.starttime <= a.endtime
;



/*
If the task is trying to check the clashes (which means typical overlapping questions),
it is impossible that there is only 1 record for each trainer in the example.
Overlapping is symmetric, which means if A overlaps with B,
then B must overlap with A unless we assume the earlier records are not issues.

However, we are not able to capture those overlap with exact same starttime and endtime.
*/
------------------------------
-- Option 2
------------------------------
-- assume the earlier records are not issues, then we introduce RANK()
with cte_overlap as (
      select      a.*
      from        [Table A] a
      inner join  [Table A] b
            on    a.trainerid = b.trainerid
      where       a.starttime <= b.endtime
            and   b.starttime <= a.endtime
)
select      *
from        (
            select      cte.*,
                        rnk = rank() over(partition by trainerid order by starttime)
            from        cte_overlap cte
            ) x
where       x.rnk > 1
;