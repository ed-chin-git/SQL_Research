
/* ******************** QUESTION #1 ******************** */
--> 1. Calculate the average rating given by students to each teacher for each session created. Also, provide the batch name for which session was conducted.
select a.session_id, b.name as batch, u.name as teacher, ROUND(AVG(a.rating)::decimal,2) as avg_rating
from attendances a
join sessions s on a.session_id = s.id
join batches b on b.id = s.batch_id
join users u on u.id = s.conducted_by
group by a.session_id, b.name, u.name
order by 1;
