#  PostgreSQL + Go

1) \ui\static\sql\
    - scriptCreateTable.sql - script creates tables
    - scriptCreateFunctions.sql - script creates functions
    - scriptInsertData.sql - script fills tables with random data

2) cmd\pkg\storage\postgres\postgres.go - database package

## Revision

- Added table "Users" and functions for working with it: insert, update, delete, select
- Added table "Labels" and functions for working with it: insert, update, delete, select
- Added messages file 
- Added table "Tasks" and functions for working with it: insert, update, delete, select


## Usage:

**1.Enter this command to start the program:**

    go run .

**2.Open the web browser and go to:**

```sh
    http://127.0.0.1:8080/ or localhost:8080
```    

## Authors:
    @PolinaSvet


**! It is for test now !**