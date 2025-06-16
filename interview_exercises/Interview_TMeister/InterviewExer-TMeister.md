# Job-interview-like SQL exercise.

## What does "job-interview-like" mean?

The students of my online courses send me over their junior data science job interview questions from time to time. So I've seen more of these tasks than you could imagine.
And let's just say that I got inspired.

Recently, I created 20 job-interview-like SQL exercises for aspiring data scientists and added them to my 7-day SQL online course.

And today, I'll give you a sneak peek and share one of these tasks (and the actual datasets for it) with you! 

It's an exciting one.

So grab your keyboard and test yourself and your SQL skills!


## Tom's Pen Shop

Disclaimer: the business in this task is a hypothetical business. Any similarity to reality is purely coincidental.

Tom has a nice and simple e-commerce business.
He sells only one product: a super ergonomic pen.
Recently, Tom ran an A/B test with ~2,000 users. To 30% of his audience he showed (and sold) a new pen design with a red case. To the other 70% he showed (and sold) the original blue-case design. The data flew in and it's stored in an SQL database.

## You have 2 data tables: 

## abtest_users :

Every row in this table represents a unique user who was part of the AB-test. The table has two columns:

    user_id: this shows the unique user_id of a given user.
    segment: was the user in the blue or the red A/B test segment?
    
## abtest_purchases :

Every row represents a unique purchase event. One purchase event (one row in the table) means exactly one pen sold. But since one user can buy multiple times, the same user can show up more than once in this table. The table has two columns:

    purchase_id: the unique identifier for a purchase event (randomly generated for each purchase event)
    user_id: the unique user_id of a given user who made a given purchase
    
## Your task is:

### Put the data into SQL! Discover the data!
### Write an SQL query to answer this question:
### Which group won the A/B test? The red or the blue one?
    Note: Answer this question by writing one and only one SQL query. Also, make sure it's the best and simplest one. 



## The Solution:

Query:

    SELECT segment,
          COUNT(abtest_purchases.user_id)/
          COUNT(DISTINCT(abtest_users.user_id))::float AS ppu
    FROM abtest_users
    FULL JOIN abtest_purchases
    ON abtest_users.user_id = abtest_purchases.user_id
    GROUP BY segment;
    Brief explanation:
    
This was a tricky task.
But I can tell you, in a real job interview situation, you can expect similar ones.
So stay with me, I'll lead you through the solution.

The winner of the A/B test - by definition - is the group that has the highest conversion rate.

If you check the data, you can see that more blue pens were sold... But remember: blue pens were shown to 70% of the audience, while reds to only 30%. You should account for that, as well. 

What we are looking for is the average-number-of-purchases-per-user ratio - for both blue and red pens.

To get that, we will have to run a calculation in our SQL query:

the total number of purchases...
divided by...
the total number of users...
...for both blue and red pens.

## Let's see how it's done in SQL!

First, we will need to JOIN the abtest_purchases and abtest_users tables:

    SELECT *
    FROM abtest_users
    FULL JOIN abtest_purchases
    ON abtest_users.user_id = abtest_purchases.user_id;

Notice that we used a FULL JOIN. The reason is simple: there are users who didn't buy anything at all. (As I said, this was a tricky question. ;-)) To calculate the true conversion rate, we need to count them in, too. (With a simple inner JOIN they would have been - falsely - excluded.)

Next step.

Let's do the segmentation using the GROUP BY clause with a simple COUNT function:

    SELECT segment,
          COUNT(*)
    FROM abtest_users
    FULL JOIN abtest_purchases
    ON abtest_users.user_id = abtest_purchases.user_id
    GROUP BY segment;

And the last step is to replace the COUNT(*) function with our actual calculation:

The total number of purchases: COUNT(abtest_purchases.user_id)
The total number of unique users: COUNT(DISTINCT(abtest_users.user_id))

Important! Because of the FULL JOIN, it also matters which table you get the user_id data from. The total number of purchases should come from the abtest_purchases table, the total number of unique users should come from the abtest_users table.
(Note: if you don't get why, try to change the table names in your calculation and you'll see the difference in the results.)

## The final query is:

    SELECT segment,
    COUNT(abtest_purchases.user_id)/
    COUNT(DISTINCT(abtest_users.user_id))::float AS ppu
    FROM abtest_users
    FULL JOIN abtest_purchases
    ON abtest_users.user_id = abtest_purchases.user_id
    GROUP BY segment;
    
Eventually, I renamed my conversion column to ppu (that stands for "purchases per user") and converted it to float format for easier interpretation.
