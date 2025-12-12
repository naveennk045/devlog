

### Primary key generation in backend

|Strategy|Where ID is generated|When ID is generated|Speed|When to Use|
|---|---|---|---|---|
|**IDENTITY**|Database auto-increment column|After insert|Medium|MySQL, SQL Server|
|**SEQUENCE**|Database sequence object|Before insert|Fast|PostgreSQL, Oracle|
|**TABLE**|Custom table created by Hibernate|Before insert|Slow|Legacy DBs|


### Application properties & Configurations
