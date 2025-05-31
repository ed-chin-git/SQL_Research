/* ******************** ALL TABLES ******************** */
select * from users;
select * from batches;
select * from student_batch_maps;
select * from instructor_batch_maps;
select * from sessions;
select * from attendances;
select * from tests;
select * from test_scores;




/* ******************** QUESTION #1 ******************** */
--> 1. Calculate the average rating given by students to each teacher for each session created. Also, provide the batch name for which session was conducted.
select a.session_id, b.name as batch, u.name as teacher, round(avg(a.rating)::decimal,2) as avg_rating
from attendances a
join sessions s on a.session_id = s.id
join batches b on b.id = s.batch_id
join users u on u.id = s.conducted_by
group by a.session_id, b.name, u.name
order by 1;




/* ******************** QUESTION #2 ******************** */
--> 2. Find the attendance percentage for each session for each batch. Also mention the batch name and users name who has conduct that session
with students_in_batch as
		(select batch_id, count(1) as students_in_batch
		from student_batch_maps
		where active = true
		group by batch_id),
	multiple_batch_students as
		(select inactive.user_id, inactive.batch_id as inactive_batch, active.batch_id  as active_batch
		from student_batch_maps active
		join student_batch_maps inactive on active.user_id = inactive.user_id
		where active.active = true
		and inactive.active = false),
	students_present as
		(select session_id, count(1) as students_present
		from attendances a
		join sessions s on s.id = a.session_id
		where (a.student_id,s.batch_id) not in (select user_id, inactive_batch from multiple_batch_students)
		group by session_id)
select s.id as session_id, b.name as batch, u.name as teacher, SB.students_in_batch, SP.students_present
, round((SP.students_present::decimal/SB.students_in_batch::decimal) * 100,2) as attendance_percentage
from sessions s
join students_present SP on s.id = SP.session_id
join students_in_batch SB on s.batch_id = SB.batch_id
join batches b on b.id = s.batch_id
join users u on u.id = s.conducted_by;




/* ******************** QUESTION #3 ******************** */
--> 3. What is the average marks scored by each student in all the tests the student had appeared?
select user_id as student, round(avg(score),2) as avg_score
from test_scores ts
group by user_id
order by 1;




/* ******************** QUESTION #4 ******************** */
--> 4. A student is passed when he scores 40 percent of total marks in a test. Find out how many students passed in each test. Also mention the batch name for that test.
select ts.test_id, b.name as batch, count(1) as students_passed
from tests t
left join test_scores ts on t.id = ts.test_id
join users u on u.id = ts.user_id
join batches b on b.id = t.batch_id
where ((ts.score::decimal/t.total_mark::decimal)*100) >= 40
group by ts.test_id,b.name
order by 1;




/* ******************** QUESTION #5 ******************** */
with total_sessions as
		(select SBM.user_id as student_id, count(1) as total_sessions_per_student
		from student_batch_maps SBM
		join sessions s on s.batch_id = SBM.batch_id
		where SBM.active = false
		group by SBM.user_id
		order by 1),
	multiple_batch_students as
		(select inactive.user_id, inactive.batch_id as inactive_batch, active.batch_id  as active_batch
		from student_batch_maps active
		join student_batch_maps inactive on active.user_id = inactive.user_id
		where active.active = true
		and inactive.active = false),
	attended_sessions as
		(select student_id, count(1) as sessions_attended_by_student
		from attendances a
		join sessions s on s.id = a.session_id
		where (a.student_id, s.batch_id)  in (select user_id, inactive_batch from multiple_batch_students)
		group by student_id)
select u.name as student
, round((coalesce(sessions_attended_by_student,0)::decimal/total_sessions_per_student::decimal) * 100,2) as student_attendence_percentage
from total_sessions TS
left join attended_sessions ATTS on ATTS.student_id = TS.student_id
join users u on u.id = TS.student_id
order by 1;




/* ******************** QUESTION #6 ******************** */
--> 6. What is the average percentage of marks scored by each student in all the tests the student had appeared?
with percentage_marks as
	(select u.name as student, ts.test_id, t.total_mark, ts.score
	, round((ts.score::decimal/t.total_mark::decimal)*100,2) as marks_percentage
	from test_scores ts
	join tests t on t.id = ts.test_id
	join users u on u.id = ts.user_id)
select student, round(avg(marks_percentage),2) as avg_marks_percent
from percentage_marks
group by student
order by 1;




/* ******************** QUESTION #7 ******************** */
--> 7. A student is passed when he scores 40 percent of total marks in a test. Find out how many percentage of students have passed in each test. Also mention the batch name for that test.
with students_passed as
		(select ts.test_id, b.name as batch, count(1) as students_passed
		from tests t
		left join test_scores ts on t.id = ts.test_id
		join users u on u.id = ts.user_id
		join batches b on b.id = t.batch_id
		where ((ts.score::decimal/t.total_mark::decimal)*100) >= 40
		group by ts.test_id,b.name),
	total_students_per_test as
		(select test_id, count(1) as tot_students
		 from test_scores
		group by test_id)
select TSPT.test_id, batch
, round((students_passed::decimal/tot_students::decimal)*100,2) as pass_percentage
from total_students_per_test TSPT
left join students_passed TP on TP.test_id = TSPT.test_id
order by 1;




/* ******************** QUESTION #8 ******************** */
--> 8. A student can be transferred from one batch to another batch. If he is transferred from batch a to batch b. batch b’s active=true and batch a’s active=false in student_batch_maps.
        At a time, one student can be active in one batch only. One Student can not be transferred more than four times.
        Calculate each student's attendance percentage for all the sessions created for his past batch. Consider only those sessions for which he was active in that past batch.

with total_sessions as
		(select SBM.user_id as student_id, count(1) as total_sessions_per_student
		from student_batch_maps SBM
		join sessions s on s.batch_id = SBM.batch_id
		where SBM.active = true
		group by SBM.user_id
		order by 1),
	multiple_batch_students as
		(select inactive.user_id, inactive.batch_id as inactive_batch, active.batch_id  as active_batch
		from student_batch_maps active
		join student_batch_maps inactive on active.user_id = inactive.user_id
		where active.active = true
		and inactive.active = false),
	attended_sessions as
		(select student_id, count(1) as sessions_attended_by_student
		from attendances a
		join sessions s on s.id = a.session_id
		where (a.student_id, s.batch_id) not in (select user_id, inactive_batch from multiple_batch_students)
		group by student_id)
select u.name as student
, round((coalesce(sessions_attended_by_student,0)::decimal/total_sessions_per_student::decimal) * 100,2) as student_attendence_percentage
from total_sessions TS
left join attended_sessions ATTS on ATTS.student_id = TS.student_id
join users u on u.id = TS.student_id
order by 1;
