/*Most performed composers*/
select composer_info$.nameComposer, count(programs_works$.Date) as number_of_performances
from programs_works$
join composer_info$
on composer_info$.composerID = programs_works$.composerID
group by composer_info$.nameComposer
order by count(programs_works$.Date) desc

--Percentile of performances per composer
select composer_info$.nameComposer, (count(programs_works$.Date)/64862.0)*100 AS percentile
from programs_works$
join composer_info$
on composer_info$.composerID = programs_works$.composerID
group by composer_info$.nameComposer
order by count(programs_works$.Date) desc

/*Most performed countries*/
select composer_info$.Country, count(programs_works$.Date) as Number_of_performances
from programs_works$
join composer_info$
on composer_info$.composerID = programs_works$.composerID
where year(programs_works$.Date) > 1950 and country is not null
group by composer_info$.Country
order by count(programs_works$.Date) desc

--Percentile of performances per country
select composer_info$.Country, (count(programs_works$.Date)/64862.0)*100 AS percentile
from programs_works$
join composer_info$
on composer_info$.composerID = programs_works$.composerID
where year(programs_works$.Date) > 1950 and country is not null
group by composer_info$.Country
order by count(programs_works$.Date) desc


/*Most performed works*/
select composer_info$.nameComposer, work_info$.workTitle, count(programs_works$.Date) as number_of_performances
from programs_works$
join composer_info$
on composer_info$.composerID = programs_works$.composerID
join work_info$
on work_info$.workID = programs_works$.workID
group by composer_info$.nameComposer, work_info$.workTitle
order by number_of_performances desc

/*Composers performed a single time*/
select composer_info$.nameComposer, count(programs_works$.Date) as number_of_performances
from programs_works$
join composer_info$
on composer_info$.composerID = programs_works$.composerID
group by composer_info$.nameComposer
having count(programs_works$.Date) = 1


/*Works performed a single time*/
select composer_info$.nameComposer, work_info$.workTitle, count(programs_works$.Date) as number_of_performances
from programs_works$
join composer_info$
on composer_info$.composerID = programs_works$.composerID
join work_info$
on work_info$.workID = programs_works$.workID
group by composer_info$.nameComposer, work_info$.workTitle
having count(programs_works$.Date) = 1


/*Number of composers performed a single time*/
with singlePerformer# as
(
select composer_info$.nameComposer, count(programs_works$.Date) as number_of_performances
from programs_works$
join composer_info$
on composer_info$.composerID = programs_works$.composerID
group by composer_info$.nameComposer
having count(programs_works$.Date) = 1
) SELECT count(number_of_performances)
from singlePerformer#


/*Number of works performed a single time*/
with singlePerformer# as
(
select work_info$.workTitle, programs_works$.composerID, count(programs_works$.Date) as number_of_performances
from programs_works$
join work_info$
on work_info$.workID = programs_works$.workID
group by work_info$.workTitle, programs_works$.composerID
having count(programs_works$.Date) = 1
) SELECT count(number_of_performances) as performed_a_single_time
from singlePerformer#


/*Current age of all performed composers*/
select nameComposer, year(getdate())-Birth as age from composer_info$
where Birth is not null
order by age

/*Composer age by performance (youngest to oldest)*/
select programs_works$.Date, composer_info$.nameComposer, year(programs_works$.Date)-composer_info$.Birth as years_old
from programs_works$
join composer_info$
on composer_info$.composerID = programs_works$.composerID
where composer_info$.Birth is not null
group by programs_works$.Date,composer_info$.nameComposer,composer_info$.Birth
order by years_old

/*Composer age by performance date*/
select programs_works$.Date, composer_info$.nameComposer, year(programs_works$.Date)-composer_info$.Birth as years_old
from programs_works$
join composer_info$
on composer_info$.composerID = programs_works$.composerID
where composer_info$.Birth is not null
group by programs_works$.Date,composer_info$.nameComposer,composer_info$.Birth
order by Date


/*Average of composer age by season*/
select programs_works$.season, CAST(AVG(year(programs_works$.Date)-composer_info$.Birth)as integer) as average_years_old
from programs_works$
join composer_info$
on composer_info$.composerID = programs_works$.composerID
where composer_info$.Birth is not null
group by programs_works$.season
order by programs_works$.season