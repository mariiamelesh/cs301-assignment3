# Practice Assignment 3
## Answers to theory questions
1. What is the difference between a function and a procedure in PostgreSQL?  
Main difference is that a function returns a value(or doesn't, it depends), whilst procedure cannot do that. Also, procedures are executed by the `call` statement while functions are called inside a `select` statement.
2. Can a trigger be executed manually? Why or why not?  
No. Trigger is executed after/before some particular event(like an update or deletion or insertion), and can't be executed manually. That's what procedures are for.
3. What are the advantages and disadvantages of storing business logic inside the database?  
If you store business logic in a database, the overall performance will be better, since everything performed with the data is direct. But on the other hand, the code implementation of business logic is less user friendly and harder to handle than high level alternatives like python scripts or applications.
## Query analysis
