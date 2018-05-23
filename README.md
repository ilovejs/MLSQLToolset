# PanSQL toolbox
    Adapt best open source sql tools for daily sql development.
------
## Progress

    [Y] Parser
    [Y] Lexer
    [-] Code Formatter 
        tsql
        sqlite
        pgsql  (testing)

## Goal
* support pl/pgsql code formatting like jetbrain tool did, as well as sqlite, tsql.
* As a open source command line tool to help SQLworkbench, vscode as plugin.

## Tasks to finish
* Better coding standard, maybe `google sql guide`
* Code formmating rules.
* Better machine learning algorithm: random forrest.
* Better training example.

## How to run:
```bash
# tsql
java -jar target/codebuff-1.5.1.jar \
    -g org.antlr.codebuff.tsql \
    -rule tsql_file \
    -corpus corpus/sql/training \
    -files sql -indent 4 -comment LINE_COMMENT \
    rsc/sql1.sql

# sqlite
java -jar target/codebuff-1.5.1.jar \
    -g org.antlr.codebuff.SQLite \
    -rule parse \
    -corpus corpus/sql/training \
    -files sql -indent 4 -comment LINE_COMMENT \
    rsc/sql1.sql
    
# pl/pgsql
java -jar target/codebuff-1.5.1.jar \
    -g org.antlr.thirdparty.PostgreSql \
    -rule tsql_file \
    -corpus corpus/sql/training \
    -files sql -indent 4 -comment LINE_COMMENT \
    rsc/sql1.sql
```


more codebuff setup:
    
    * run-codebuff.sh
    * python/*
    * Doc/codebuff_readme.md (bad doc)

## Credits

Lexar

    * [antlr4-grammar-postgresql](https://github.com/tunnelvisionlabs/antlr4-grammar-postgresql)
    * this repo is in progress

    * [codebuff](https://github.com/antlr/codebuff)

Parser

    * [pg_sql_parser](https://github.com/valgog/pg_sql_parser)
    * [antlr_psql](https://github.com/tshprecher/antlr_psql)



