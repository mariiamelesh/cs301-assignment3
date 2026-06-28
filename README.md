# Practice Assignment 3
## Answers to theory questions
1. What is the difference between a function and a procedure in PostgreSQL?  
Main difference is that a function returns a value(or doesn't, it depends), whilst procedure cannot do that. Also, procedures are executed by the `call` statement while functions are called inside a `select` statement.
2. Can a trigger be executed manually? Why or why not?  
No. Trigger is executed after/before some particular event(like an update or deletion or insertion), and can't be executed manually. That's what procedures are for.
3. What are the advantages and disadvantages of storing business logic inside the database?  
If you store business logic in a database, the overall performance will be better, since everything performed with the data is direct. But on the other hand, the code implementation of business logic is less user friendly and harder to handle than high level alternatives like python scripts or applications.
## Query analysis
Full query execution plan can be found in `explain_analyze.txt`. 
Firstly, the query completes a Seq. scan on `customers`, `orders` and `order_items` tables:  
<img width="782" height="58" alt="image" src="https://github.com/user-attachments/assets/2803ac79-0fb1-453e-8eaa-3a32dd182d85" />  
<img width="783" height="38" alt="image" src="https://github.com/user-attachments/assets/b4660d04-d976-48ec-aa94-cfbcbcd5bec8" />  
<img width="786" height="33" alt="image" src="https://github.com/user-attachments/assets/995c1124-1b0b-4daa-ab86-22e25f382a37" />  

It is an optimal choice since the tables are not too big, so there's no point in indexing. Then it uses hash tables for 2 Hash Joins:  
<img width="779" height="67" alt="image" src="https://github.com/user-attachments/assets/f9a36328-3447-4be5-b63d-b040d5a85f73" />  
<img width="783" height="69" alt="image" src="https://github.com/user-attachments/assets/416db477-f865-41c5-b99a-424b648b4a8a" />  

After that, it completes a GroupAggregate by Group Key `customer_id` to calculate `sum()` and `count()` functions. At the top-level it does the Sort using quicksort by Sort key `total_items_bought` and arranges result by descending.
